//
//  clickableUIView.m
//  LimitFree
//
//  Created by sensen on 13-12-19.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import "ClickableUIView.h"


@implementation ClickableUIView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.userInteractionEnabled = YES;
        _overlayView = [[UIView alloc ] initWithFrame:self.bounds];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0.4;
        [self insertSubview:_overlayView atIndex:[self.subviews count]];
        _overlayView.hidden =YES;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        _overlayView = [[UIView alloc ] initWithFrame:self.bounds];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0.4;
        [self insertSubview:_overlayView atIndex:[self.subviews count]];
        _overlayView.hidden =YES;
        
    }
    return self;
}


-(void)tapAct{
    if (_block) {
        _block(self);
    }
}

-(void)handleComplemetionBlock:(handleComleplement)block{
    _block = [block copy];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
   // [self addGestureRecognizer:tap];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _overlayView.frame = self.bounds;
    [self bringSubviewToFront:_overlayView];
    _overlayView.hidden = NO;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _overlayView.hidden = YES;
    [self tapAct];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    _overlayView.hidden = YES;
}
@end
