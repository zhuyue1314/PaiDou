//
//  BaseViewController.m
//  wft
//
//  Created by JSen on 14/9/28.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

static int const kErrorViewTag = 11;
static int const kLoadingViewTag = 12;

@interface BaseViewController (){
    MBProgressHUD *_baseHUD;
}

@end

@implementation BaseViewController

- (NSArray *)getAnimatedImages:(NSString *)imageName01, ...NS_REQUIRES_NIL_TERMINATION{
    va_list args;
    va_start(args, imageName01);
    
    NSMutableArray *array = [NSMutableArray array];
    UIImage *image = [UIImage JSenImageNamed:imageName01];
    if (image) {
        [array addObject:image];
    }
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        if ([arg isKindOfClass:[NSString class]]){
            UIImage *image = [UIImage JSenImageNamed:arg];
            if(image){
                [array addObject:image];
            }
        }
    }
    va_end(args);
    
    return [array copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor appBlackTextColor]};
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
}

- (void)showLeftBackBarbuttonItemWithSelector:(SEL)sel{
    UIBarButtonItem *leftItem = [Utils leftbuttonItemWithImage:@"nav_left.png" highlightedImage:nil target:self action:sel];
    self.navigationItem.leftBarButtonItem = leftItem;
}



- (UIView *)errorView {
    UIView *view = [self.view viewWithTag:kErrorViewTag];
    if (view) {
        return view;
    }
    
    UIView *errorView = [[UIView alloc]initWithFrame:self.view.bounds];
    UILabel *label = [[UILabel alloc]initWithFrame:errorView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"加载失败";
    [errorView addSubview:label];

    return errorView;
}
- (UIView *)loadingView {
    UIView *view = [self.view viewWithTag:kLoadingViewTag];
    if (view) {
        return view;
    }
    
    UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    loadingView.backgroundColor = [UIColor whiteColor];
    loadingView.tag = kLoadingViewTag;
//    UILabel *labelLoad = [[UILabel alloc]initWithFrame:loadingView.bounds];
//    labelLoad.textAlignment = NSTextAlignmentCenter;
//    labelLoad.textColor = [UIColor blackColor];
//    labelLoad.backgroundColor = [UIColor clearColor];
//    labelLoad.text = @"加载中";
//    [loadingView addSubview:labelLoad];
    UIImageView *iView = [[UIImageView alloc]init];
    iView.size = CGSizeMake(200, 200);
    iView.center = loadingView.center;
    
    iView.animationImages = [self getAnimatedImages:@"icon_loading_animating_1.png",@"icon_loading_animating_2.png", nil];
    iView.animationRepeatCount = 0;
    iView.animationDuration = 0.2;
    [iView startAnimating];
    [loadingView addSubview:iView];
    
    return loadingView;
}
- (void)showLoadingAnimated:(BOOL)animated {
    UIView *loadingView = [self loadingView];
    loadingView.alpha = 1.0;
    [self.view insertSubview:loadingView atIndex:self.view.subviews.count];
//    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    
    double duration = animated ? 0.3: 0;
    [UIView animateWithDuration:duration animations:^{
        loadingView.alpha = 1.0f;
    }];
}
- (void)hideLoadingViewAnimated:(BOOL)animated {
   __block UIView *loadingView = [self loadingView];
    
    double duration = animated ? 0.4f: 0;
    [UIView animateWithDuration:duration animations:^{
        loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }];
}
- (void)showErrorViewAnimated:(BOOL)animated {
    UIView *errorView = [self errorView];
    errorView.alpha = 0;
    [self.view addSubview:errorView];
    [self.view bringSubviewToFront:errorView];
    
    double duration = animated ? 0.3f:0;
    [UIView animateWithDuration:duration animations:^{
        errorView.alpha = 1.0f;
    }];
}
- (void)hideErrorViewAnimated:(BOOL)animated {
    __block UIView *errorView = [self errorView];
    double duration = animated ? 0.3f: 0;
    [UIView animateWithDuration:duration animations:^{
        errorView.alpha = 0;
    } completion:^(BOOL finished) {
        [errorView removeFromSuperview];
        errorView = nil;
    }];
}

- (void)showHUDText:(NSString *)text xOffset:(float)x yOffset:(float)y {
    
   _baseHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _baseHUD.userInteractionEnabled = NO;
    _baseHUD.mode = MBProgressHUDModeText;
    _baseHUD.xOffset = x;
    _baseHUD.yOffset = y;
    _baseHUD.margin = 10;
    _baseHUD.detailsLabelText = text;
    _baseHUD.detailsLabelFont =[UIFont systemFontOfSize:16];
    _baseHUD.minShowTime = 1;
    [_baseHUD show:YES];
  
    [_baseHUD hide:YES afterDelay:1.0f];
    
}

/*
 - (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
 completionBlock:(MBProgressHUDCompletionBlock)completion;
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
