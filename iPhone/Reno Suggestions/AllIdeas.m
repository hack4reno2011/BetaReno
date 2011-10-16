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

-(id) initIdeas:(NSString *)longitude 
        withLat:(NSString *)lat 
      andRadius:(NSString *)radius;
{

    [super init];
    [self getListOfIdeas:longitude withLat:lat andRadius:radius];
    return self;
}

-(NSMutableArray *) getListOfIdeas:(NSString *)longitude 
                           withLat:(NSString *)lat 
                         andRadius:(NSString *)radius;
{
    
    [ideasArray removeAllObjects];
    // - get all data from betareno.cyberhobo.net 
     
     NSURL*					url			= [NSURL URLWithString:[NSString stringWithFormat:@"%@", kSuggestionsURL]];
     //NSLog(@"JJA get suggestions url = %@",[url absoluteString] );
     NSMutableURLRequest*	request		= [NSMutableURLRequest requestWithURL:url];
     NSError*	err	= nil;
     NSData*	response	= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
     
     if (err == nil)
     {
         NSString*	respString   = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        ideasArray = [respString JSONValue];

         for (int i = 0; i < [ideasArray count]; i++)
         {
         //pull data into view controller array.  
         NSLog(@"JJA response from cyberhobo = %@",respString);
         NSLog(@"JJA jason parsed as = %@",ideasArray);
         }
     }
     else
     {
     NSLog(@"JJA error from cyberhobo = %@",[err localizedDescription]);
     }

    return ideasArray;
}

-(void) addIdeaToList:(Idea *)newIdea;
{
    [ideasArray addObjectAtIndex:0];  
}

-(void)removeItemFromList:(Idea *)oldIdea;
{
    //we dont need this now but maybe someday.
    return;
}


@end