//
//  AllIdeas.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "AllIdeas.h"

static AllIdeas *sharedIdeas;

@implementation AllIdeas

@synthesize ideasArray;
+(AllIdeas *) sharedIdeas
{
    if (!sharedIdeas) {
        sharedIdeas  = [[AllIdeas alloc]init];
    }
    return sharedIdeas;
}

+(id) allocWithZone:(NSZone *)zone 
{
    if (!sharedIdeas) {
        sharedIdeas = [super allocWithZone:zone];
        return sharedIdeas;
    } else {
        return nil;
    }
}

-(id) copyWithZone:(NSZone *)zone
{
    return self;
}

-(oneway void) release
{
    //do nothing
}


@end
