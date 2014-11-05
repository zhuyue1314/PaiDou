//
//  NewUUID.m
//  XYZ_iOS1
//
//  Created by vision on 13-12-5.
//  Copyright (c) 2013年 anddo. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "NewUUID.h"

@implementation NewUUID

@synthesize uuid;

- (id)init {
	self = [super init];
	if (self) {
		uuid = NULL;
		return self;
	}
    
	return nil;
}

+ (id)_instance {
	static id obj = nil;
	if( nil == obj ) {
		obj = [[self alloc] init];
	}
    
	return obj;
}

+ (NSString *)identifier {
    
	NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
	[[NewUUID _instance] setUuid:[NSString stringWithFormat:@"%@", [handler objectForKey:NEW_UUID_KEY]]];
    
	if (NULL == [[NewUUID _instance] uuid] || 46 > [[[NewUUID _instance] uuid] length]) {
        
		CFUUIDRef uuid = CFUUIDCreate(NULL);
		CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        
		NSString *result = [NSString stringWithFormat:@"%@",uuidStr];
        
		CFRelease(uuidStr);
		CFRelease(uuid);
        
		[[NewUUID _instance] setUuid:result];
        
        
		[handler setObject:[[NewUUID _instance] uuid] forKey:NEW_UUID_KEY];
		[handler synchronize];
	}
    
	return [[NewUUID _instance] uuid];
}

@end
