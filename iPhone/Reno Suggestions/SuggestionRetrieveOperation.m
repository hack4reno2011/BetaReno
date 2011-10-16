//
//  SuggestionRetrieveOperation.m
//  Reno Suggestions
//
//  Created by jangelo on 10/14/11.
//  Copyright 2011 Apps42 Ltd, All rights reserved.
//

#import "SugggestionRetrieveOperation.h"



@implementation SuggestionRetrieveOperation

@synthesize suggestionList;
@synthesize target;
@synthesize executing;
@synthesize finished;

NSAutoreleasePool* suggestionListRetrieveOperationPool = nil;

- (void)start 
{
	if ([self isCancelled])	
	{
		[self willChangeValueForKey:@"isFinished"];
		
		finished = YES;
		
		[self didChangeValueForKey:@"isFinished"];
		
		return;
	}
	else
	{
		[self willChangeValueForKey:@"isExecuting"];
		
		[NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
		
		executing = YES;
		
		[self didChangeValueForKey:@"isExecuting"];
	}
}


- (void)main 
{
	suggestionListRetrieveOperationPool = [[NSAutoreleasePool alloc] init];
	
	//"get all" request to kinvey
    //example URL http://www.reno.suggestions.gov
	NSURL*					url			= [NSURL URLWithString:[NSString stringWithFormat:@"%@", kSuggestionsURL]];
    //NSLog(@"JJA get suggestions url = %@",[url absoluteString] );
	NSMutableURLRequest*	request		= [NSMutableURLRequest requestWithURL:url];
	NSError*				err			= nil;
	NSData*					response	= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];

	
	if (err == nil)
	{
		NSString*		respString          = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSArray*        suggestionsArray	= [respString JSONValue];

		for (int i = 0; i < [suggestionsArray count]; i++)
		{
			//pull data into view controller array.            
			
		}
		[target performSelectorOnMainThread:@selector(populateSuggstionsList:) 
								 withObject:self
							  waitUntilDone:YES];
	}
    	
	[suggestionListRetrieveOperationPool release];
	suggestionListRetrieveOperationPool = nil;
}




#pragma - Operation Status

- (BOOL)isConcurrent 
{	
    return YES;	
}


- (BOOL)isExecuting 
{	
    return executing;	
}


- (BOOL)isFinished 
{	
    return finished;	
}




#pragma - Memory Management

- (id) initWithTarget:(RSViewController*)t
{
	if (self == [super init])
	{		
		self.suggestionList	= [[[NSMutableArray alloc] init] autorelease];
		self.target		= t;
		self.executing	= NO;
		self.finished	= NO;
	}
	
	return self;
}

- (void) dealloc
{	
	[suggestionList release];
	[target release];
	
	[super dealloc];
}

@end
