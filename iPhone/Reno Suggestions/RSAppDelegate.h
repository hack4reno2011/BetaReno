//
//  RSAppDelegate.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/14/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <AudioToolbox/AudioToolbox.h>

@class RSViewController;

@interface RSAppDelegate : UIResponder <UIApplicationDelegate> {
    
    
	BOOL					quit;
	BOOL					_wasInterrupted;
	Reachability*           internetReachable;
    Reachability*           hostReachable;
    NSURLConnection*        theConnection;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RSViewController *viewController;

//class methods
+(RSAppDelegate *)sharedAppController;
-(BOOL)NetworkCheck;
-(void) networkAlert;
-(void)addCallInterruptHandler;
-(NSString *)timestamp;


@end
