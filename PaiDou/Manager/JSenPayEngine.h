//
//  JSenPayEngine.h
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlixLibService.h"

static NSString *const kOrderID = @"OrderID";
static NSString *const kTotalAmount = @"TotalAmount";
static NSString *const kProductDescription = @"productDescription";
static NSString *const kProductName = @"productName";
static NSString *const kNotifyURL = @"NotifyURL";


static NSString *const kAppSchema = @"superWFTClient";

typedef void(^paymentFinishCallBack)(int statusCode, NSString *statusMessage, NSString *resultString, NSError *error, NSData *data);


@interface JSenPayEngine : NSObject <AlixPaylibDelegate>{
    
    NSString *_schema;
    NSString *_partnerKey;
    NSString *_sellerKey;
    NSString *_RSAPrivateKey;
    NSString *_RSAPublicKey;
    
    paymentFinishCallBack _finishBlock;
    SEL _resultSEL;
}


+ (instancetype)sharePayEngine;

+ (void)connectAliPayWithSchema:(NSString *)schema
                        partner:(NSString *)partnerKey
                         seller:(NSString *)sellerKey
                  RSAPrivateKey:(NSString *)privateKey
                  RSAPublicKey :(NSString *)publicKey;

+ (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block;
@end
