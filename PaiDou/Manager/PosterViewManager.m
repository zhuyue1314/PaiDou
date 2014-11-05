//
//  PosterViewManager.m
//  wft
//
//  Created by JSen on 14/10/9.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "PosterViewManager.h"

@implementation PosterViewManager

+(instancetype)share {
    static id _s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[self alloc]init];
    });
    return _s;
}

+(void)loadPosterData {
    
}

+ (UIView *)viewAtIndex:(NSInteger)index {
    PosterView *view = [[PosterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHotSelectVCPosterHeight)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

@end

@implementation PosterView

- (void)setDict:(NSDictionary *)dict {
    
}

@end
