//
//  RSAppDelegate.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/14/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "RSAppDelegate.h"

#import "RSViewController.h"
#import "MapView.h"

static RSAppDelegate *sharedInstance;
@implementation RSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

-(id) init {
	if (sharedInstance) {
		NSLog(@"error: You created a second Reno Suggestions AppDelegate");
	}
	[super init];
	sharedInstance = self;
	return self;
}


+(RSAppDelegate *)sharedAppController {
	return sharedInstance;
}

#pragma mark Private methods


//check network connectivity for GPS and to email suggestions
-(BOOL)NetworkCheck
{
	Reachability *r = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	if (internetStatus == NotReachable) return NO;
	else return YES;
}

-(void) networkAlert 
{
	UIAlertView *netAlert = 
	[[UIAlertView alloc] initWithTitle:@"Network Unavailable"
							   message:@"No network connectivity.  Please exit this app and enable networking otherwise  email and location awareness functionality will not be available" 
							  delegate:nil 
					 cancelButtonTitle:@"OK"
					 otherButtonTitles:nil];
	[netAlert show];
	[netAlert release];
}

//phone interrupt handler, allow background music when not in phone call.

void PhoneCallInterruptionListener(void *inClientData, UInt32 inInterruptionState){
	
	
	RSAppDelegate *objDelegate=(RSAppDelegate *)inClientData;
	
    if( inInterruptionState == kAudioSessionBeginInterruption ) {
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CallInterrupt"];
        
    }
    else if(inInterruptionState == kAudioSessionEndInterruption){		
		[objDelegate addCallInterruptHandler];  		
    }	
}

//initializing audio session
-(void)addCallInterruptHandler{
	
    @try {
		
        AudioSessionInitialize (
                                NULL,                          // 'NULL' to use the default (main) run loop
                                kCFRunLoopDefaultMode,                          // 'NULL' to use the default run loop mode
                                PhoneCallInterruptionListener,  // a reference to your interruption callback
                                self                       // data to pass to your interruption listener callback
                                );
		
		
        UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
        AudioSessionSetProperty (
                                 kAudioSessionProperty_AudioCategory,
                                 sizeof (sessionCategory),
                                 &sessionCategory
                                 );
		
		
        AudioSessionSetActive(true);
    }
    @catch (NSException * e) {
		
    }
    @finally {
		
    }
}

-(NSString *)timestamp {
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:kDateFormat];
	NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
	return dateString;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[MapView alloc] initWithNibName:@"MapView" bundle:nil] autorelease];
    } else {
        self.viewController = [[[RSViewController alloc] initWithNibName:@"RSViewController_iPad" bundle:nil] autorelease];
    }
    
    // check for network connectivity
	if (![self NetworkCheck]) [self networkAlert];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
