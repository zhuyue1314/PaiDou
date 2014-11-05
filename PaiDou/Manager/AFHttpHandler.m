//
//  AFHttpHandler.m
//
//
//  Created by JSen on 14/9/24.
//  Copyright (c) 2014年 Gowalla. All rights reserved.
//

#import "AFHttpHandler.h"
#import "AFNetworkReachabilityManager.h"



@implementation AFHttpHandler

+ (instancetype)shared{
    static AFHttpHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[AFHttpHandler alloc]initWithBaseURL:[NSURL URLWithString:AFHttpHandlerBaseUrlString]];
       
    });
    return handler;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSString *newStr = nil;
    NSLog(@"URL--> %@ [GET] PARAM --> %@",URLString,parameters);
   return  [super GET:newStr parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSLog(@"URL--> %@ [POST] PARAM --> %@",URLString,parameters);
    return [super POST:URLString parameters:parameters success:success failure:failure];
}

- (void)requestWithUrlString:(NSString *)url withCache:(BOOL)yesOrNo completion:(successBlock)successBlock failed:(failedBlock)failedBlock{
    if (url.length == 0 ) {
        
        return ;
    }
    NSURLRequest *request = nil;
    if (yesOrNo) {
         request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadRevalidatingCacheData|NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    }else{
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
   
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (successBlock) {
            successBlock(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(operation,error);
        }
    }];
    
    [operation start];
//    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
  
}

@end
