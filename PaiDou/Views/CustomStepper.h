//
//  CustomStepper.h
//  wft
//
//  Created by JSen on 14/10/21.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomStepper : UIView<UITextFieldDelegate>{
    NSInteger _number;
   void (^_block)(int number);
    MBProgressHUD *_hud;
    
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)textChanged:(UITextField *)sender;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;

- (IBAction)btnDecreaseAction:(UIButton *)sender;
- (IBAction)btnIncreaseAction:(UIButton *)sender;



-(instancetype)init;

- (UIView *)getCustomStepper;

- (void)textDidChanged:(void(^)(int number))block;

//销毁view 之前必须调用
- (void)removeObserver;
@end
