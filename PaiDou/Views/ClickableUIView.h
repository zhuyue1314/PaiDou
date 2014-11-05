//
//  clickableUIView.h
//  LimitFree
//
//  Created by sensen on 13-12-19.
//  Copyright (c) 2013年 sensen. All rights reserved.
//


@class ClickableUIView;
typedef  void(^handleComleplement)(ClickableUIView *view);
@interface ClickableUIView : UIView
{

    handleComleplement _block;
    UIView *_overlayView;
}


-(void)handleComplemetionBlock:(handleComleplement)block;
@end
