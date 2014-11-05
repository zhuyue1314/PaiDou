

#import "ClickableUILabel.h"
#import "AFHttpHandler.h"

@implementation ClickableUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabel:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
     //   [self addGestureRecognizer:tap];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //响应手势
        self.userInteractionEnabled = YES;
        //增加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabel:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
     //   [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)handleClickEvent:(action)block{
    _block = [block copy];
    
    
}

- (void)clickLabel:(id)sender{
    if (_block) {
        _block(self);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_block) {
        _block(self);
    }
}

@end
