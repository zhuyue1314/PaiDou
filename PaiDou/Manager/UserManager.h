//
//  UserManager.h
//  wft
//
//  Created by JSen on 14/9/28.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject{
    User *_currUser;
    
}
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, assign) BOOL hasSignin;
+ (instancetype)sharedManager;

- (void)getUserInfo;

- (void) setLoginUser:(User *)m;

- (void)saveToDisk:(User *)m;

- (User *) readFromDisk;

- (void)autoLogin ;
- (NSString *)uid ;

//sign in 签到
- (void)signIn:(void(^)(BOOL isSuccess,int score))block ;
//能否点击签到24h为期
- (BOOL)canSignin ;
@end
