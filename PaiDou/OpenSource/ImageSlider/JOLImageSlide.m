//
//  JOLImageSlide.m
//  JOLImageSlider
//
//  Created by Jayson Lane on 4/27/13.
//  Copyright (c) 2013 Jayson Lane. All rights reserved.
//

#import "JOLImageSlide.h"

@implementation JOLImageSlide

@synthesize image = _image;
@synthesize title = _title;
@synthesize infoDict = _infoDict;

- (NSString *)description {
    return [NSString stringWithFormat:@"%@",_infoDict];
}
@end
