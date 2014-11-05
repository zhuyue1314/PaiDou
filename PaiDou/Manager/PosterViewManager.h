//
//  PosterViewManager.h
//  wft
//  海报管理类，包括获取海报数据，创建海报view，取得海报数据等
//  Created by JSen on 14/10/9.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PosterView;

@interface PosterViewManager : NSObject {
    NSDictionary *dictSource;
    NSMutableArray *_arrayViews; //保存创建好的view
}
+(void)loadPosterData;
+(instancetype)share;
+ (UIView *)viewAtIndex:(NSInteger)index;
@end

@interface PosterView : UIView

- (void)setDict:(NSDictionary *)dict;
@end