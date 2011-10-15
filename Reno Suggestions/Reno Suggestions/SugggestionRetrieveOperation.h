//
//  SuggestionsRetrieveOperation.h
//  Reno Suggestions
//
//  Created by jangelo on 10/14/11.
//  Copyright 2011 v All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSViewController.h"
#import "SBJson.h"

@class RSViewController;

@interface SuggestionRetrieveOperation : NSOperation 
{
	NSMutableArray*					suggestionList;
	RSViewController*               target;
	BOOL							executing;
	BOOL							finished;
}


@property (nonatomic, retain)	NSMutableArray*					suggestionList;
@property (nonatomic, retain)	RSViewController*               target;
@property (nonatomic)			BOOL							executing;
@property (nonatomic)			BOOL							finished;


- (id)initWithTarget:(RSViewController*)t;

@end
