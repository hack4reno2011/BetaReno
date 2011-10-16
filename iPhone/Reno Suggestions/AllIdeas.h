//
//  AllIdeas.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Idea.h"
#import "SBJson.h"

@interface AllIdeas : NSObject
{
    NSMutableArray*  ideasArray;
}

@property (nonatomic, retain) NSMutableArray* ideasArray;

+(AllIdeas *) Ideas;

-(id) initIdeas:(NSString *)longitude 
    withLat:(NSString *)lat 
        andRadius:(NSString *)radius;


 
-(NSMutableArray *) getListOfIdeas:(NSString *)longitude 
                           withLat:(NSString *)lat 
                         andRadius:(NSString *)radius;

-(void) addIdeaToList;

-(Idea *)removeItemFromList;
@end
