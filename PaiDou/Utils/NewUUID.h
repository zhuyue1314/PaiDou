//
//  NewUUID.h
//  XYZ_iOS1
//
//  Created by vision on 13-12-5.
//  Copyright (c) 2013年 anddo. All rights reserved.
//


#define NEW_UUID_KEY	@"uuid_created_by_developer"

@interface NewUUID : NSObject {
    
	NSString *uuid;
    
}

+ (NSString *)identifier;

@property (nonatomic, retain) NSString *uuid;

@end