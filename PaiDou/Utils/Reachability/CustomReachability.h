//
//  CustomReachability.h
//  iOSReachabilityTestARC
//
//  Created by JSen on 14/9/25.
//
//

#import <Foundation/Foundation.h>

@class Reachability;
@interface CustomReachability : NSObject{
    Reachability *reachability;
}


+ (instancetype)sharedInstance;

+(BOOL)networkConnectionAvailable;

@end
