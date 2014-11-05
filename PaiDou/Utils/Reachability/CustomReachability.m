//
//  CustomReachability.m
//  iOSReachabilityTestARC
//
//  Created by JSen on 14/9/25.
//
//

#import "CustomReachability.h"
#import "Reachability.h"
#include <err.h>
#include<unistd.h>
#include<netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>



@implementation CustomReachability


+ (instancetype)sharedInstance {
    static CustomReachability *_s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _s = [[self alloc] init];
    });
    return _s;
}

- (instancetype)init{
    if (self = [super init]) {
        struct sockaddr_in serverAddr;
        serverAddr.sin_family = AF_INET;
        serverAddr.sin_len = sizeof(serverAddr);
        serverAddr.sin_port = htons(80);
        bzero(&(serverAddr.sin_zero), 8);
        serverAddr.sin_addr.s_addr = inet_addr("8.8.8.8");
        
        reachability = [Reachability reachabilityWithAddress:&serverAddr];
        
        __weak CustomReachability *weakSelf = self;
        reachability.reachableBlock = ^(Reachability *currentReach) {
            NetworkStatus status = [currentReach currentReachabilityStatus];
            switch (status) {
                case ReachableViaWiFi:
                case ReachableViaWWAN:
                    NSLog(@"reach by wifi or wwan, now test Internet connection...");
                    if ([weakSelf isInternetConnectionAvailable]) {
                        //broadcast
                        NSLog(@"broadCast -->has Internet Connection");
                        [[NSNotificationCenter defaultCenter ] postNotificationName:kInternetConnectionActiveNotification object:nil];
                    }else{
                        NSLog(@"broadCast -->no Internet Connection");
                        [[NSNotificationCenter defaultCenter] postNotificationName:kInternetConnectionDownNotification object:nil];
                    }
                    break;
                case NotReachable:
                    NSLog(@"can not reach");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kInternetConnectionDownNotification object:nil];
                    break;
                default:
                    break;
            }
        };
        
        reachability.unreachableBlock = ^(Reachability *currentReach) {
            //broadcast
            [[NSNotificationCenter defaultCenter] postNotificationName:kInternetConnectionDownNotification object:nil];
            NSLog(@"%s",__func__);
        };
        [reachability startNotifier];
        
      //  [self installNotification];
    }
    return self;
}
//Deprecated
- (void)installNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(reachabilityChanged:)
                                                name:kReachabilityChangedNotification
                                                object:nil];
}
//Deprecated

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    NetworkStatus status = [reach currentReachabilityStatus];
    switch (status) {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            NSLog(@"reach by wifi or wwan, now test Internet connection...");
            if ([self isInternetConnectionAvailable]) {
                //broadcast
                NSLog(@"broadCast -->has Internet Connection");
            }else{
                NSLog(@"broadCast -->no Internet Connection");
            }
            break;
        case NotReachable:
            NSLog(@"can not reach");
            break;
        default:
            break;
    }

   
}

/**
 检查是否有外网连接，注意：在连在诸如：CMCC,ChinaNet等网络上
 时gethostbyname() 可以得到正确结果，即这些网络会进行DNS解析
 故在hostinfo不为空时再次检查到baidu的连接是否ok
 */
- (BOOL)isInternetConnectionAvailable {
    char *hostname;
    struct hostent *hostinfo = NULL;
    hostname = "baidu.com";
    hostinfo = gethostbyname (hostname);
    
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
        
        return [self hasInternetConnection];
    }

}
//检查外网连接
- (BOOL)hasInternetConnection {
    NSString *str =  [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.baidu.com"] encoding:NSUTF8StringEncoding error:nil];
    if (str.length) {
        NSLog(@"-> connection established!\n ");
    }else{
        NSLog(@"->no connection!");
    }

    return str.length ? YES:NO;
}

+(BOOL)networkConnectionAvailable {
   return  [[CustomReachability sharedInstance] hasInternetConnection];
}
@end
