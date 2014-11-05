//
//  Utils.h
//  XYZ_iOS
//
//  Created by 建新 金 on 12-6-14.
//  Copyright (c) 2012年 焦点科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@class MD5Util;


@interface Utils : NSObject

+ (NSString *)deviceIPAdress;

+ (NSString *)localWiFiIPAddress;

//获取info.plist定义app的bundleId
+ (NSString *)bundleIdString;

//获取info.plist定义的app版本号
+ (NSString *)appVersionString;

//显示一个简单的AlertView（只有一个确认按钮）
+ (UIAlertView *)showSimpleAlert:(NSString *)message delegate:(id)alertDelegate;

+ (void)showSimpleAlert:(NSString *)message;

+ (void)showToastWithMessage:(NSString *)mesage;

+ (void)showToastWithImage:(NSString *)image;

//将6为rgp十六进制字符串转为UIColor对象
+ (UIColor*)colorWithHexString:(NSString *)stringToConvert;

+ (UIBarButtonItem *)leftbuttonItemWithImage:(NSString *)imageUrl highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;

//创建一个应用于导航栏右侧的按钮
+ (UIBarButtonItem *)rightbuttonItemWithImage:(NSString *)imageUrl highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;

//创建一个导航栏标题风格的label
+ (UILabel *)titleLabelWithTitle:(NSString *)title;

+ (UILabel *)titleLabelWithTitle:(NSString *)title color:(UIColor *)color;

//创建一个显示在窗口中的提示view
+ (MBProgressHUD *)showLoadingViewInWindowWithTitle:(NSString*)title delegate:(id<MBProgressHUDDelegate>) delegate;

//创建一个自动消息的显示在窗口中的提示view
+ (MBProgressHUD *)showPromptViewInWindowWithTitle:(NSString*)title afterDelay:(NSTimeInterval)delay;

+ (UIImage *)createImageWithColor: (UIColor *) color;
+ (void)showAppPage;

+ (void)showNetworkError;

+ (BOOL)isValidEmail:(NSString *)value;
+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;
+ (NSString*)getDistanceOutputString:(double)distance;



+ (NSString *)getDeviceID;

// NEW FOR THE PROJECT
//MD5(phone+pwd)
+ (NSString *)processedPassWordString:(NSString *)originalPass phoneNumber:(NSString *)phoneNumer ;

+ (UIButton *)createButtonWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage actionBlock:(void(^)(id sender))block;

+ (NSString *)fenToYuan:(NSInteger)oriPrice;
+ (NSString *)orderStatusToChinese:(NSString *)orderStatus;
+ (NSString *)dateFromTimeInterval:(NSInteger)timeInterval;
@end
