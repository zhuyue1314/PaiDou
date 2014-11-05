//
//  BaseViewController.h
//  wft
//
//  Created by JSen on 14/9/28.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (UIView *)errorView ;
- (UIView *)loadingView;
- (void)showLoadingAnimated:(BOOL)animated ;
- (void)hideLoadingViewAnimated:(BOOL)animated ;
- (void)showErrorViewAnimated:(BOOL)animated;
- (void)hideErrorViewAnimated:(BOOL)animated;

- (void)showHUDText:(NSString *)text xOffset:(float)x yOffset:(float)y ;

- (void)showLeftBackBarbuttonItemWithSelector:(SEL)sel;
@end
