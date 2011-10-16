//
//  AllIdeas.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllIdeas : NSObject
{
    NSMutableArray*  ideasArray;
}

@property (nonatomic, retain) NSMutableArray* ideasArray;

+(AllIdeas *) Ideas;

@end
