//
//  NSObject+Localizable.m
//  Access
//
//  Created by IMAC_jinjianxin on 13-5-22.
//  Copyright (c) 2013年 anddo. All rights reserved.
//

#import "NSObject+Localizable.h"

@implementation NSObject (Localizable)

- (NSString *)getStringForKey:(NSString *)key
{
    return NSLocalizedString(key, nil);
}

@end
