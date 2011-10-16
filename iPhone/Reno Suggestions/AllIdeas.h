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

+(AllIdeas *) sharedIdeas;
+(id) allocWithZone:(NSZone *)zone;
-(id) copyWithZone:(NSZone *)zone;
-(oneway void) release;

-(id) initIdeas:(NSString *)longitude 
    withLat:(NSString *)lat 
        andRadius:(NSString *)radius;


 
-(NSMutableArray *) getListOfIdeas:(NSString *)longitude 
                           withLat:(NSString *)lat 
                         andRadius:(NSString *)radius;

-(void) addIdeaToList:(Idea *)newIdea;

-(void)removeItemFromList:(Idea *)oldIdea;
@end
