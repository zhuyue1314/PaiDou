//
//  Define.h
//  AFNetworking iOS Example
//
//  Created by JSen on 14/9/24.
//  Copyright (c) 2014年 Gowalla. All rights reserved.
//


static NSString *const AFHttpHandlerBaseUrlString = @"http://jifenmall.sinaapp.com/api/";

static NSString *const kInternetConnectionActiveNotification = @"InternetConnectionActive";
static NSString *const kInternetConnectionDownNotification = @"InternetConnectionTearDown";

static NSString *const kSafePaySuccessNotificatino = @"AliSafePaySuccess";
static NSString *const kSafePayFailedNotification = @"AliSafePayFailed";

static NSString *const kSafePayResultKey = @"safePayResult";

static NSInteger const kHotSelectVCPosterHeight = 150;

//placeholder image name
static NSString *const kPlaceHolderImageName = @"bg_commodity_placeholderPhoto.png";
static NSString *const kPlaceHolderText = @"加载中...";

//商品支付类型
static NSString *const kProductTypeCash = @"cash";
static NSString *const kProductTypeScore = @"score";
static NSString *const kProductTypeMixed = @"mixed";

//订单状态
//wait_for_pay、payed、consumed、refunding、refunded
static NSString *const kOrderStatusWait_for_pay = @"wait_for_pay";
static NSString *const kOrderStatusPayed = @"payed";
static NSString *const kOrderStatusConsumed = @"consumed";
static NSString *const kOrderStatusRefunding = @"refunding";
static NSString *const kOrderStatusRefunded = @"refunded";

//sign
static NSString *const kSignAppID = @"1002";
static NSString *const kSignAppKEY = @"49AU6oSDJrsjE8nM";


#define DEV_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define PropertyString(p) @property(nonatomic,copy) NSString *(p)
#define PropertyFloat(p) @property (nonatomic, assign) CGFloat (p)
#define PropertyInt(p) @property (nonatomic, assign) NSInteger (p)
#define PropertyUInt(p) @property (nonatomic, assign) NSUInteger (p)
#define PropertyBool(p) @property (nonatomic,assign) BOOL (p)
#define PropertyNumber(p) @property (nonatomic,retain) NSNumber *(p)

//-------
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{4,16}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,32}"
//#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\[0-9]{4}\\[0-9]{4}"
#define REGEX_PHONE_DEFAULT @"[0-9]{11}"
#define REGEX_RANDOMCODE @"[0-9]{6}"
#define debugUID @"U926C5B7E6F7F84E21AEE49D44DDFA483"

#define kBaseUrl(str) [NSString stringWithFormat:@"%@%@",AFHttpHandlerBaseUrlString,str]

//获取短信验证码 post
#define kRandomVaildateCodeUrl  kBaseUrl(@"sms/send?")

//验证短信验证码 post
#define kVerifyVaildateCodeUrl kBaseUrl(@"sms/verify?")

//用户注册
#define kRegisterURL kBaseUrl(@"user/register?")

//获取用户基本信息 get
#define kUserBasicInfoUrl kBaseUrl(@"user/item?")

//登录 post
#define kLoginURL kBaseUrl(@"user/login?")
//5.5获取用户的积分收支列表（分页）
#define kScoreListURL kBaseUrl(@"user/score_list?")

//5.8 更改用户信息
#define kModifyUserInfo kBaseUrl(@"user/update")

//5.7 修改登录密码
#define kChangePass kBaseUrl(@"user/update_password")
/*
 6 商户
 */
//6.3 查找商户列表（分页）
#define kBizsListURL kBaseUrl(@"bizs/list?")

//6.4获取指定商户的详细信息
#define kBizsDetailURL kBaseUrl(@"bizs/item?")
/*
 7 产品
 */
//7.5 获取产品列表（分页）
#define kProductsListSearchURL kBaseUrl(@"products/search?")

//7.3 获取指定商户的产品列表（不分页,带bid为获取商户下的产品列表，不带为所有产品列表）
#define kProductsListUrl kBaseUrl(@"products/list")

//7.4 获取指定产品的详细信息
#define kProductDetailURL kBaseUrl(@"products/item?")

/*
 8 订单
 */
#define kCreateOrderURL kBaseUrl(@"orders/new_order?")

//8.5获取某用户的订单列表（分页）
#define kGetUserOrdersURL kBaseUrl(@"orders/list?")

#define kDeleteUserOrderURL kBaseUrl(@"orders/del_order")

//8.7 申请退单
#define kRefoundUserOrderURL kBaseUrl(@"orders/apply_refund?")

//8.10 获取用户的兑换码（验证码）
#define kGetVerifyCodesURL kBaseUrl(@"orders/verify_codes?")

//http://jifenmall.sinaapp.com/api/redeem/list?uid=111&oid=123
#define kGetCommodityCodesURL kBaseUrl(@"redeem/list?")

/*十三 广告
 13.1 获取广告信息
 */
#define kAdvertisementURL kBaseUrl(@"ad/all?")

/*
 十四）积分任务
 */
//14.1 更新任务
#define kTaskComplete kBaseUrl(@"task/complete?")

//14.2 获取用户任务完成情况。
#define kTaskMy kBaseUrl(@"task/my?")

//14.3 获取用户任务列表。
#define kTaskList kBaseUrl(@"task/list?")

#define kAlipayNotifyURL kBaseUrl(@"payment/alipay_notify")
