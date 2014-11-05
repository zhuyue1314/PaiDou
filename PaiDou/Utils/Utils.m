  //
//  Utils.m
//  XYZ_iOS
//
//  Created by 建新 金 on 12-6-14.
//  Copyright (c) 2012年 焦点科技. All rights reserved.
//

#import "Utils.h"

#import "MD5Util.h"
#import "NSString+URLEncoding.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>

#include <net/ethernet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>

#include <net/if_dl.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import "InfoUIDevice.h"
#import "RegexKitLite.h"
#import "BlockUI.h"


//#include "GetAddresses.h"

#define min(a,b)    ((a) < (b) ? (a) : (b))
#define max(a,b)    ((a) > (b) ? (a) : (b))

#define BUFFERSIZE  4000

#define MAXADDRS 200

char *if_names[MAXADDRS];
char *ip_names[MAXADDRS];
char *hw_addrs[MAXADDRS];
unsigned long ip_addrs[MAXADDRS];

static int   nextAddr = 0;

void InitAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = hw_addrs[i] = NULL;
        ip_addrs[i] = 0;
    }
}

void FreeAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if (if_names[i] != 0) free(if_names[i]);
        if (ip_names[i] != 0) free(ip_names[i]);
        if (hw_addrs[i] != 0) free(hw_addrs[i]);
        ip_addrs[i] = 0;
    }
    InitAddresses();
}

void GetIPAddresses()
{
    int                 i, len, flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in  *sin;
    
    char temp[80];
    
    int sockfd;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
    {
        perror("ioctl error");
        return;
    }
    
    lastname[0] = 0;
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
    {
        ifr = (struct ifreq *)ptr;
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;  // for next one in buffer
        
        if (ifr->ifr_addr.sa_family != AF_INET)
        {
            continue;   // ignore if not desired address family
        }
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
        {
            *cptr = 0;      // replace colon will null
        }
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
        {
            continue;   /* already processed this interface */
        }
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0)
        {
            continue;   // ignore if interface not up
        }
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(if_names[nextAddr], ifr->ifr_name);
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(ip_names[nextAddr], temp);
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        
        ++nextAddr;
    }
    
    close(sockfd);
}

void GetHWAddresses()
{
    struct ifconf ifc;
    struct ifreq *ifr;
    int i, sockfd;
    char buffer[BUFFERSIZE], *cp, *cplim;
    char temp[80];
    
    for (i=0; i<MAXADDRS; ++i)
    {
        hw_addrs[i] = NULL;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, (char *)&ifc) < 0)
    {
        perror("ioctl error");
        close(sockfd);
        return;
    }
    
    ifr = ifc.ifc_req;
    
    cplim = buffer + ifc.ifc_len;
    
    for (cp=buffer; cp < cplim; )
    {
        ifr = (struct ifreq *)cp;
        if (ifr->ifr_addr.sa_family == AF_LINK)
        {
            struct sockaddr_dl *sdl = (struct sockaddr_dl *)&ifr->ifr_addr;
            int a,b,c,d,e,f;
            int i;
            
            strcpy(temp, (char *)ether_ntoa(LLADDR(sdl)));
            sscanf(temp, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
            sprintf(temp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
            
            for (i=0; i<MAXADDRS; ++i)
            {
                if ((if_names[i] != NULL) && (strcmp(ifr->ifr_name, if_names[i]) == 0))
                {
                    if (hw_addrs[i] == NULL)
                    {
                        hw_addrs[i] = (char *)malloc(strlen(temp)+1);
                        strcpy(hw_addrs[i], temp);
                        break;
                    }
                }
            }
        }
        cp += sizeof(ifr->ifr_name) + max(sizeof(ifr->ifr_addr), ifr->ifr_addr.sa_len);
    }
    
    close(sockfd);
}

@implementation Utils
+ (NSString *)deviceIPAdress {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

+ (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}


+ (NSString *)bundleIdString
{
    NSString *identifier =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    return identifier;
}

+ (NSString *)appVersionString
{
    NSString *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}

+ (UIAlertView *)showSimpleAlert:(NSString *)message delegate:(id)alertDelegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:alertDelegate cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
    return alert;
}


+ (void)showSimpleAlert:(NSString *)message
{
    [Utils showSimpleAlert:message delegate:nil];
}

+ (void)showToastWithMessage:(NSString *)mesage
{
    UIWindow *winodw = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:winodw animated:YES];
    hud.yOffset = 150;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = mesage;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:2.];
}

+ (void)showToastWithImage:(NSString *)image
{
    UIWindow *winodw = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:winodw animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    hud.userInteractionEnabled = NO;
    hud.opacity =0 ;
    [hud hide:YES afterDelay:2.];
}

/*
 * 根据字符串类型的16进制的色值返回相应的颜色
 * 传入参数  "0xFF0000"或者 "FFFFFF" 
 * 返回     UIColor
 */
+(UIColor*)colorWithHexString:(NSString *)stringToConvert  
{  
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
	
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return nil;  
	
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
	
    if ([cString length] != 6 &&[cString length] != 8) return nil;  
	
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
	
    // Scan values  
    unsigned int r, g, b,a=255.0;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
	if ([cString length] == 8)  
	{
		range.location = 6; 
		NSString *aString = [cString substringWithRange:range]; 
		[[NSScanner scannerWithString:aString] scanHexInt:&a]; 
	}
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:((float) a / 255.0f)];  
} 

+ (MBProgressHUD *)showLoadingViewInWindowWithTitle:(NSString*)title delegate:(id<MBProgressHUDDelegate>) delegate
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSInteger windowCount = [windows count];
    UIWindow *window = windows[windowCount-1];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    hud.labelText = title;
    hud.delegate = delegate;
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    return hud;
}

+ (MBProgressHUD *)showPromptViewInWindowWithTitle:(NSString*)title afterDelay:(NSTimeInterval)delay{
    UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hud];
    if (title) {
        hud.labelText = title;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    if (delay > 0) {
        [hud hide:NO afterDelay:delay];
    }
    return hud;
}

#define MAX_BACK_BUTTON_WIDTH 160.0


+ (UIBarButtonItem *)leftbuttonItemWithImage:(NSString *)imageUrl  highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,25, 25);
    [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    //[button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)rightbuttonItemWithImage:(NSString *)imageUrl highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UILabel *)titleLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 31)];
    label.text = title;
    label.font = [UIFont appNavTitleFont];
    label.textAlignment= NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor appBlackTextColor];
//    [label setShadowColor:[UIColor darkGrayColor]];
//    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    return label;
}

+ (UILabel *)titleLabelWithTitle:(NSString *)title color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 31)];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment= UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    //    [label setShadowColor:[UIColor darkGrayColor]];
    //    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    return label;
}

//+ (void)showAppPage{
//    //软件首页
//    NSString *str2 = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",APP_ID];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2]];
//}

//+ (void)showAppPage{
//    //软件首页
//    NSString *str2 = [NSString stringWithFormat:@"%@%@",ITMS_APPS,APP_ID];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2]];
//}

+ (void)showNetworkError
{
    
}

+ (BOOL)isValidEmail:(NSString *)value
{

    NSString *regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    return [value isMatchedByRegex:regex];
}

+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2
{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}

+ (NSString*)getDistanceOutputString:(double)distance
{
    if (distance < 1000) {
        return [NSString stringWithFormat:@"%.0f%@",distance,LocalizedString(@"m")];
    }else if (distance < 1000*1000){
        return [NSString stringWithFormat:@"%.0f%@",distance/1000,LocalizedString(@"km")];
    }else {
        return [NSString stringWithFormat:@">1000%@",LocalizedString(@"km")];
    }
}


+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



+ (NSString *)getDeviceID{
    NSString *idStr =[[InfoUIDevice currentDevice] getIdentifierForVendor];
    idStr = [idStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (idStr.length>17) {
        idStr = [idStr substringToIndex:16];
    }
    
    return idStr;
}

//MARK: FOR THE PROJECT
+ (NSString *)processedPassWordString:(NSString *)originalPass phoneNumber:(NSString *)phoneNumer {
    if (!originalPass.length || !phoneNumer.length) {
        return nil;
    }
    NSString *newStr = [NSString stringWithFormat:@"%@%@",phoneNumer,originalPass];
    return [MD5Util md5Encrypt:newStr];
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage actionBlock:(void(^)(id sender))block {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    UIImage *imageNormal = [UIImage JSenImageNamed:normalImage];
    UIImage *selectImage = [UIImage JSenImageNamed:selectedImage];
    if (imageNormal) {
        [btn setBackgroundImage:imageNormal forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [btn setBackgroundImage:selectImage forState:UIControlStateSelected];
    }
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:block];
    return btn;
}

#pragma mark - 分-->元
+ (NSString *)fenToYuan:(NSInteger )oriPrice{
 
    if (oriPrice <= 0) {
        return [NSString stringWithFormat:@"0"];
    }
    int money = oriPrice /100;//元
    int change = oriPrice % 100;//
    

    
    if (money == 0 && change == 0) {
        return [NSString stringWithFormat:@"0"];
    }else if (0 == money && 0 < change && 9 >= change ){
        return [NSString stringWithFormat:@"0.0%d",change];
    }else if (0 == money && 9 < change){
        if (0 == change%10 ) {
            change = change/10;
        }
        return [NSString stringWithFormat:@"0.%d",change];
    }
    else if (0 != money && 0 != change){
        if (0 == change%10 ) {
            change = change/10;
        }
         return [NSString stringWithFormat:@"%d.%d",money,change];
    }else if (0 != money && 0 == change){
        return [NSString stringWithFormat:@"%d",money];
    }
    return nil;
}


+ (NSString *)orderStatusToChinese:(NSString *)orderStatus {
    if (!orderStatus.length) {
        return @"";
    }
    if ([orderStatus isEqualToString:kOrderStatusWait_for_pay]) {
        return @"未支付";
    }else if ([orderStatus isEqualToString:kOrderStatusPayed]){
        return @"已支付";
    }else if ([orderStatus isEqualToString:kOrderStatusConsumed]){
        return @"已完成";
    }else if ([orderStatus isEqualToString:kOrderStatusRefunding]){
        return @"退款中";
    }else if ([orderStatus isEqualToString:kOrderStatusRefunded]){
        return @"已退款";
    }
    return @"";
}
+ (NSString *)dateFromTimeInterval:(NSInteger)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
@end
