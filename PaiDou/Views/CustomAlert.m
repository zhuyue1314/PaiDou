//
//  CustomAlert.m
//  wft
//
//  Created by JSen on 14/10/10.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "CustomAlert.h"


@implementation CustomAlert{
    UIWindow *_cusWindow;
    NSString *_title;
    NSString *_description;
    
}



- (id)initWithTitle:(NSString *)title description:(NSString *)description {
    if (self = [super init]) {
        _title = title;
        _description = description;
          self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        [self _addTextToView];
    }
    return self;
    
}

- (void)_addTextToView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-200, self.width, 200)];
    view.backgroundColor = [UIColor whiteColor];
    
  UILabel *titleLabel = [self _createTitleLabel];
    [view addSubview:titleLabel];
    
    UILabel *desLabel = [self _createDesLabel];
    [view addSubview:desLabel];
    [self addSubview:view];
}

- (UILabel *)_createDesLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, self.width-40, 50)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont appCommonFont];
    label.text = _description;
    return label;
}

- (UILabel *)_createTitleLabel{
    UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(0, 10, self.width, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont appCommonFont];
    label.text = _title;
    return label;
}


- (void)tappedCancel
{
    [UIView animateWithDuration:0.25f animations:^{
      //  [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


- (void)show {
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
