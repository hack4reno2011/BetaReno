//
//  Idea.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "Idea.h"

@implementation Idea
@synthesize idea;

-(id)initIdea;
{
    [super init];
    if (self) {
        idea = [[NSMutableDictionary alloc]initWithCapacity:10];
        return self;
    }
    return nil;
}

-(void) dealloc;
{
    [idea release];

}

-(void) saveIdeaField:(id)obj withKey:(NSString *)key;
{
    [idea setObject:obj forKey:key];
}



@end
