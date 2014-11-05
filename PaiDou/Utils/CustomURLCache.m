//
//  CustomURLCache.m
//  wft
//
//  Created by JSen on 14/9/25.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "CustomURLCache.h"

static NSString *const CustomURLCacheExpirationKey = @"CustomURLCacheExpiration";
static NSTimeInterval const CustomURLCacheExpirationInterval = 600;

@implementation CustomURLCache

+(instancetype)standardURLCache {
    static CustomURLCache *_s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[CustomURLCache alloc]initWithMemoryCapacity:4*1024*1024 diskCapacity:30*1024*1024 diskPath:@"URLCache"];
    });
    return _s;
}


- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    
    if (cachedResponse) {
        if ([(NSDate *)cachedResponse.userInfo[CustomURLCacheExpirationKey] compare:[[NSDate date] dateByAddingTimeInterval:CustomURLCacheExpirationInterval]] == NSOrderedDescending ) {
            return nil;
        }
        
    }
    return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[CustomURLCacheExpirationKey]  = [NSDate date];
    
    NSCachedURLResponse *cachedRes = [[NSCachedURLResponse alloc]initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:cachedResponse.storagePolicy];
    
    [super storeCachedResponse:cachedRes forRequest:request];
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forDataTask:(NSURLSessionDataTask *)dataTask {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[CustomURLCacheExpirationKey]  = [NSDate date];
    
   NSCachedURLResponse *cachedRes = [[NSCachedURLResponse alloc]initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:cachedResponse.storagePolicy];
    
    [super storeCachedResponse:cachedRes forDataTask:dataTask];
}


@end
