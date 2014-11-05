//
//  User.h
//  wft
//
//  Created by JSen on 14/9/28.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModelLib.h"

@interface User : JSONModel<NSCoding>

@property (nonatomic, copy) NSString *uid;  //用户的唯一id
@property (nonatomic, copy) NSString *mobile; //用户注册时填写的手机号
@property (nonatomic, assign) NSUInteger score;    //用户当前积分
@property (nonatomic, retain) NSString *create_time; //用户注册时间
@property (nonatomic, strong) NSString * name ;


@property (nonatomic, copy) NSString<Ignore> *passWord;

@end
