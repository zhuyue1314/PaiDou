//
//  User.m
//  wft
//
//  Created by JSen on 14/9/28.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "User.h"

#define encObj(a,b) [aCoder encodeObject:(a) forKey:(b)]
#define encInt(a,b) [aCoder encodeInt:(a) forKey:(b)]
#define encInteger(a,b) [aCoder encodeInteger:(a) forKey:(b)]
#define encBool(a,b) [aCoder encodeBool:(a) forKey:(b)]

#define decObj(p) [aDecoder decodeObjectForKey:(p)];
#define decInt(p) [aDecoder decodeIntForKey:(p)];
#define decInteger(p) [aDecoder decodeIntegerForKey:(p)]

@implementation User

- (void)encodeWithCoder:(NSCoder *)aCoder {
    encObj(_uid, @"uid");
   
    encInteger(_score, @"score");
    encObj(_create_time, @"createTime");
    encObj(_mobile, @"mobile");
    encObj(_name, @"name");
    encObj(_passWord, @"password");
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _uid = decObj(@"uid");
        _mobile = decObj(@"mobile");
        _score = decInteger(@"score");
        _create_time = decObj( @"createTime");
        _name = decObj(@"name");
        _passWord = decObj(@"password");
    }
    return self;
}

@end
