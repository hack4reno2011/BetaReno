//
//  ShowIdeaViewController.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/16/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Idea.h"

@interface ShowIdeaViewController : UIViewController <UIWebViewDelegate>

{
    NSString *strURL;
    IBOutlet UIWebView *m_objWebView; 
    

}

@property(nonatomic,retain) NSString *strURL;

-(IBAction) done;

@end
