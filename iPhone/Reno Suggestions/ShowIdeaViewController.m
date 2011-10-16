//
//  ShowIdeaViewController.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/16/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "ShowIdeaViewController.h"

@implementation ShowIdeaViewController
@synthesize strURL;

-(void)dealloc
{
    [strURL release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction) done;
{
     [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_objWebView.delegate = self;
    NSLog(@"beta url = %@",strURL);
	NSURL *url = [NSURL URLWithString:strURL];	
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];	
	[m_objWebView loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
