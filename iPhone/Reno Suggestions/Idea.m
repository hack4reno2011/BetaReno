//
//  Idea.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "Idea.h"

@implementation Idea

-(id)initIdea;
{
    [super init];
    if (self) {
        idea = [[NSDictionary alloc]init];
        
        /*
        [what setString:@""];
        [who setString:@""];
        [when setString:@""];
        [longitude setString:@""];
        [latitude setString:@""];
        [beforePictureURL setString:@""];
        [afterPictureURL setString:@""];
        beforePicture = nil;
        afterPicture = nil;
         
         */
        return self;
    }
    return nil;
}

-(void) dealloc;
{
    [what release];
    [who  release];
    [when release];
    [longitude release];
    [latitude release];
    [beforePicture  release];
    [afterPicture   release];

}


@end
