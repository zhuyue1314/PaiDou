//
//  UIFont+AppSetting.m
//  wft
//
//  Created by JSen on 14/10/8.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

//apple 支持的font 请参见http://support.apple.com/kb/ht5878

#import "UIFont+AppSetting.h"

@implementation UIFont (AppSetting)

+ (UIFont *)appNavTitleFont {
    return [UIFont systemFontOfSize:20];
}

+ (UIFont *)appCommonFont {
    return [UIFont fontWithName:@"Times New Roman" size:20];
}

+ (UIFont *)appCellTitleFont {
    return [UIFont systemFontOfSize:15];
}
+ (UIFont *)appCellDetailFont {
    return [UIFont systemFontOfSize:13];
}

@end
