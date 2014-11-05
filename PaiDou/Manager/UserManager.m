//
//  UserManager.m
//  wft
//
//  Created by JSen on 14/9/28.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "UserManager.h"
#import "User.h"
//最近一次签到时间
static NSString *const kLattestSignInTime = @"lattest sing in time";

@implementation UserManager

+ (instancetype)sharedManager {
    static UserManager *_s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[self alloc]init];
    });
    return _s;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)getUserInfo {
    
}

- (NSString*) getCurrUserFile{
    return [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"/Library/Caches/CurrUser"];
}

- (void) setLoginUser:(User *)m{
    _currUser = m;
    [self saveToDisk:m];
}

- (void)saveToDisk:(User *)m{
    if (_currUser != m) _currUser = m;
    NSString *f = [self getCurrUserFile];
    NSLog(@"current user file path %@",f);
    BOOL isOk = [NSKeyedArchiver archiveRootObject:m toFile:f];
    if (!isOk) {
        NSLog(@"write to file %@ fail ",f);
    }else{
        NSLog(@"write to file %@ success !",f);
    }
}

- (User *) readFromDisk{
    NSString *f = [self getCurrUserFile];
    if(![[NSFileManager defaultManager]fileExistsAtPath:f])
    {
        //bu cun zai
//        _currUser = [[User alloc]init];
//        return _currUser;
        return nil;
    }
    User *u = [NSKeyedUnarchiver unarchiveObjectWithFile:f];
    if(_currUser == nil) _currUser = u;
    return u;
}

- (void)autoLogin {
    User *user = [self readFromDisk];
    if (user) {
        [self _updateUserInfo:user];
    }
}
- (void)_updateUserInfo:(User *)user {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = @{@"mobile":user.mobile,
                           @"password":[Utils processedPassWordString:user.passWord phoneNumber:user.mobile]
                           };
    [manager POST:kLoginURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@ %@",operation,responseObject);
        NSDictionary *resDict = (NSDictionary *)responseObject;
        if ([resDict[@"err_code"] intValue] == 0) {
            NSError *error;
            User *updatedUser = [[User alloc]initWithDictionary:responseObject[@"user"] error:&error];
         
            if (error) {
                NSLog(@"%@",error);
               // return ;
            }
            updatedUser.passWord = user.passWord;
            [[UserManager sharedManager] setLoginUser:updatedUser];
            [UserManager sharedManager].hasLogin  = YES;
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ %@",operation,error);
   
    }];

}

- (NSString *)uid {
    return _currUser.uid;
}
- (void)signIn:(void(^)(BOOL isSuccess,int score))block {
    if (!_hasLogin) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    NSDictionary *param = @{
                            @"type":@"sign_in",
                            @"uid":[self uid],
                            @"data":@""
                   };
    [manager POST:kTaskComplete parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"err_code"] intValue] == 0) {
            int s = [responseObject[@"score"] intValue];
            User *user = [[UserManager sharedManager]readFromDisk];
            
            //save last sign in time
            [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:kLattestSignInTime];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            user.score += s;
            _hasSignin = YES;
            if (block) {
                block(YES,s);
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _hasSignin = NO;
        if (block) {
            block(NO,-1);
        }

    }];
    
}

- (BOOL)canSignin {
    NSDate *lastDate = [(NSDate *)[NSUserDefaults standardUserDefaults] valueForKey:kLattestSignInTime];
    if (!lastDate) {
        return YES;
    }
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //check year
    [formatter setDateFormat:@"yyyy"];
    int lastYear = [[formatter stringFromDate:lastDate]intValue];
    int currYear = [[formatter stringFromDate:currentDate] intValue];
    if ((currYear - lastYear) >= 1) {
        return YES;
    }
    
    //check month
    [formatter setDateFormat:@"MM"];
    int lastMonth = [[formatter stringFromDate:lastDate] intValue];
    int currMonth = [[formatter stringFromDate:currentDate] intValue];
    if ((currMonth - lastMonth) >= 1) {
        return YES;
    }
    
    //check day
    [formatter setDateFormat:@"dd"];
    int lastDay = [[formatter stringFromDate:lastDate] intValue];
    int today = [[formatter stringFromDate:currentDate] intValue];
    if ((today - lastDay) >= 1){
        return YES;
    }
    
    
    return NO;
}
@end
