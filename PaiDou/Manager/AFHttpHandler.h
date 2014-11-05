//
//  AFHttpHandler.h
//  AFNetworking iOS Example
//
//  Created by JSen on 14/9/24.
//  Copyright (c) 2014年 Gowalla. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

typedef void(^successBlock)(AFHTTPRequestOperation *op, id JSON);
typedef void(^failedBlock)(AFHTTPRequestOperation *op, NSError *err);

@interface AFHttpHandler : AFHTTPSessionManager

+(instancetype)shared;

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id JSON))success failure:(void (^)(NSURLSessionDataTask *task, NSError *err))failure;

- (void )requestWithUrlString:(NSString *)url withCache:(BOOL)yesOrNo completion:(successBlock)successBlock failed:(failedBlock)failedBlock;


@end
