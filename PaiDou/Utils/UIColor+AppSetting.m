//
//  UIColor+AppSetting.m
//  wft
//
//  Created by JSen on 14/10/8.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "UIColor+AppSetting.h"

@implementation UIColor (AppSetting)


+ (UIColor *)appBackgroundColor {
    return UIColorFromRBGString(@"0xffffff");
}

+ (UIColor *)appBlackTextColor {
    return UIColorFromRGB(0x333333);
}

+ (UIColor *)appRedTextColor {
    return UIColorFromRGB(0xcf0033);
}

+ (UIColor *)appGrayTextColor{
    return UIColorFromRGB(0x616161);
}

+ (UIColor *)appBlueTextColor {
    return UIColorFromRGB(0x0ee1b2);
}
@end
