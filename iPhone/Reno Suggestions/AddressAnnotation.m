//
//  AddressAnnotation.m
//  Reno Suggestions
//
//  Created by Erik Hanchett on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "AddressAnnotation.h"


@implementation AddressAnnotation

@synthesize coordinate;
@synthesize mTitle;
@synthesize mSubTitle;

- (NSString *)subtitle{
	return mSubTitle;
}

- (NSString *)title{

    return mTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}
@end
