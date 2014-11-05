//
//  JSenPayEngine.m
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "JSenPayEngine.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixLibService.h"
#import <UIKit/UIKit.h>

@implementation JSenPayEngine


+ (instancetype)sharePayEngine {
    static JSenPayEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _resultSEL = @selector(paymentResult:);
    }
    return self;
}
-(void)paymentResultDelegate:(NSString *)result {
    [self paymentResult:result];
}
- (void)paymentResult:(NSString *)resultd {
    AlixPayResult *result  = [[AlixPayResult alloc] initWithString:resultd];
    
    if (result) {
        
        if (result.statusCode == 9000) {
            NSString *key = AlipayPubKey;
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString]) {
                NSLog(@"交易成功");
                if (_finishBlock) {
                    _finishBlock(result.statusCode, result.statusMessage, result.resultString, nil, nil);
                }
            }
        }else {
            NSLog(@"交易失败");
            if (_finishBlock) {
                _finishBlock(result.statusCode, result.statusMessage, result.resultString, nil, nil);
            }
        }
        
    }else {
        NSLog(@"交易失败");
        if (_finishBlock) {
            _finishBlock(-1, nil, nil, nil, nil);
        }
    }

}

- (void)setAliPaySchema:(NSString *)schema
                partner:(NSString *)partnerKey
                 seller:(NSString *)sellerKey
          RSAPrivateKey:(NSString *)privateKey
           RSAPublicKey:(NSString *)publickKey
{
    _schema = schema;
    _partnerKey = partnerKey;
    _sellerKey = sellerKey;
    _RSAPrivateKey = privateKey;
    _RSAPublicKey = publickKey;
}


+ (void)connectAliPayWithSchema:(NSString *)schema
                        partner:(NSString *)partnerKey
                         seller:(NSString *)sellerKey
                  RSAPrivateKey:(NSString *)privateKey
                  RSAPublicKey :(NSString *)publicKey
{
    [[JSenPayEngine sharePayEngine] setAliPaySchema:schema
                                    partner:partnerKey
                                    seller:sellerKey
                                    RSAPrivateKey:privateKey
                                    RSAPublicKey:publicKey];
}

+ (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block {
    [[JSenPayEngine sharePayEngine] paymentWithInfo:payInfo result:block];
}

- (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block {
    _finishBlock = [block copy];
    
    NSString *orderID = payInfo[kOrderID];
    NSString *total = payInfo[kTotalAmount];
    NSString *produceDes = payInfo[kProductDescription];
    NSString *productName = payInfo[kProductName];
    NSString *notifyURL = kAlipayNotifyURL;
    
    if (orderID.length == 0) {
        orderID = [self generateTradeNO];
    }
    if (_partnerKey.length == 0 || _sellerKey.length == 0) {
        NSError *err = [NSError errorWithDomain:@"partner或seller参数为空" code:-1 userInfo:nil];
        if (_finishBlock) {
            _finishBlock(-1, nil, nil, err, nil);
        }
        return ;
    }
    
    AlixPayOrder *aliOrder = [[AlixPayOrder alloc]init];
    aliOrder.partner = _partnerKey;
    aliOrder.seller = _sellerKey;
    aliOrder.tradeNO = orderID;
    aliOrder.productDescription = produceDes;
    aliOrder.productName = productName;
    aliOrder.amount = @"0.01";  //暂时
    aliOrder.notifyURL = notifyURL;
    
      //将商品信息拼接成字符串
    NSString *orderSpec = [aliOrder description];
    NSString *signedStr = [self doRsa:orderSpec];
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             aliOrder, signedStr, @"RSA"];
    
    [AlixLibService payOrder:orderString AndScheme:kAppSchema seletor:_resultSEL target:[JSenPayEngine sharePayEngine]];
}


-(NSString*)doRsa:(NSString*)orderInfo
{
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}


@end
