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
        sharedIdeas  = [[[AllIdeas alloc]init]retain];
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

-(id) initIdeas;
{

    [super init];
    return self;
}

-(NSMutableArray *) getListOfIdeas:(NSString *)longitude 
                           withLat:(NSString *)lat 
                         andRadius:(NSString *)radius;
{
    
    [ideasArray removeAllObjects];
    // - get all data from betareno.cyberhobo.net 
    //longitude = @"-119.813803";
	//lat = @"39.529633";
    
     NSURL*	url	= [NSURL URLWithString:[NSString stringWithFormat:@"%@lat=%@&lng=%@&r=%@", 
                                        kSuggestionsURL,lat, longitude, radius]];

     NSLog(@"JJA get suggestions url = %@",[url absoluteString] );
     NSMutableURLRequest*	request		= [NSMutableURLRequest requestWithURL:url];
     NSError*	err	= nil;
     NSData*	response	= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
     
     if (err == nil)
     {
         NSString*	respString   = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSDictionary* doc = [respString JSONValue];
         NSLog(@"JJA debug resp doc: %@",doc);
         ideasArray = [[doc objectForKey:@"ideas"]retain];
         NSLog(@"JJA debug ideas array: %@",ideasArray);

         //debug code
         for (int i = 0; i < [ideasArray count]; i++)
         {  
         NSLog(@"JJA what = %@",[[ideasArray objectAtIndex:i] objectForKey:@"what"]);
         }
         //
     }
     else
     {
     NSLog(@"JJA HTTP header error from cyberhobo = %@",[err localizedDescription]);
     }

    return ideasArray;
}

-(void) addIdeaToList:(Idea *)newIdea;
{
    [ideasArray insertObject:newIdea atIndex:0];  
}

-(void)removeItemFromList:(Idea *)oldIdea;
{
    //we dont need this now but maybe someday.
    return;
}


@end
