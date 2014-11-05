//
//  CustomStepper.m
//  wft
//
//  Created by JSen on 14/10/21.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "CustomStepper.h"

#define kIncrease_btn_tag 101
#define kDecrease_btn_tag 100

@implementation CustomStepper


- (UIView *)getCustomStepper {
    return [[[NSBundle mainBundle] loadNibNamed:@"CustomStepperView" owner:self options:nil] lastObject];
}




-(instancetype)init {
    self = [super init];
    if (self) {
        _number = 1;

        [self addObserver:self forKeyPath:@"_number" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

//
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"keyPath:%@ %@",keyPath,change);
    int new = [change[@"new"] intValue];
    int old = [change[@"old"] intValue];
    if (new != old && _block) {
        _block(new);
    }
    if (new == 1) {
        [_btns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == kDecrease_btn_tag) {
                btn.enabled = NO;
            }else if (btn.tag == kIncrease_btn_tag){
                btn.enabled = YES;
            }
        }];
    }else if (new > 99) {
        [_btns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == kDecrease_btn_tag) {
                btn.enabled = YES;
            }else if (btn.tag == kIncrease_btn_tag){
                btn.enabled = NO;
            }
        }];
    }else if(new > 1 && new <= 99) {
        [_btns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *btn = (UIButton *)obj;
            btn.enabled = YES;
        }];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str  = [textField.text stringByAppendingString:string];
    if ([str intValue] > 99 ) {
        [self showHUD];
        return NO;
    }else if ([str intValue] > 1 && [str intValue] <= 99){
        return YES;
    }
    return NO;
}// return NO to not change text

- (void)showHUD{
    RDVTabBarController *tab = (RDVTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
    
    _hud = [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.userInteractionEnabled  = NO;
    _hud.labelText = @"抱歉，最多能选折择99件商品";
    _hud.margin = 10;
    _hud.minShowTime = 1.0f;
    
    [_hud hide:YES];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return NO;
}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)removeObserver{

    [self removeObserver:self forKeyPath:@"_number"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)textChanged:(UITextField *)sender {
  //  NSLog(@"%@",sender.text);
    [self setValue:@([sender.text intValue]) forKey:@"_number"];
    
}

- (void)textDidChanged:(void(^)(int number))block {
    _block = [block copy];
}
- (IBAction)btnDecreaseAction:(UIButton *)sender {
    int num = [_textField.text integerValue];
    num--;
    if (num <= 0 || num > 99) {
        return;
    }
    _textField.text = [NSString stringWithFormat:@"%@",@(num)];
  
    [self setValue:@(num) forKey:@"_number"];

}
- (IBAction)btnIncreaseAction:(UIButton *)sender {
    int num = [_textField.text integerValue];
    num++;
    if (num <= 0 || num > 99) {
        return;
    }
    _textField.text = [NSString stringWithFormat:@"%@",@(num)];
   
    [self setValue:@(num) forKey:@"_number"];

}
@end
