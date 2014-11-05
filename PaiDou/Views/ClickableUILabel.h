

#import <UIKit/UIKit.h>

@class ClickableUILabel;

typedef void (^action)(ClickableUILabel *label);

@interface ClickableUILabel : UILabel
{
    action _block;
}

- (void)handleClickEvent:(action)block;
@end
