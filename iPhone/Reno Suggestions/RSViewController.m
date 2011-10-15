//
//  RSViewController.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/14/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "RSViewController.h"
#import "AddressAnnotation.h"

@implementation RSViewController

@synthesize cameraButton;
@synthesize locationButton;
@synthesize suggestionButton;
@synthesize mapView;
@synthesize longitude;
@synthesize latitude;
@synthesize locationManager;
@synthesize startingPoint;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

//actions

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorGreen;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
}

-(void) showAddress {
    
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.2;
	span.longitudeDelta = 0.2;
	
	CLLocationCoordinate2D cord;
	//cord.longitude = -119.813803;
	//cord.latitude = 39.529633; 
	cord.longitude = [longitude doubleValue];
	cord.latitude = [latitude doubleValue];
	region.span = span;
	region.center = cord;
	AddressAnnotation *addAnnotation = nil;
    
	if(addAnnotation != nil) {
		[mapView removeAnnotation:addAnnotation];
		[addAnnotation release];
		addAnnotation = nil;
	}
	addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:cord];
	[mapView addAnnotation:addAnnotation];
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
}

-(IBAction)cameraButtonPressed:(id)sender;
{
    return;
}
-(IBAction)locationButtonPressed:(id)sender;
{
    return;
}
-(IBAction)suggestionButtonPressed:(id)sender;
{
    return;
}

//Table View Protocols





#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	[self showAddress];
    // Do any additional setup after loading the view, typically from a nib.
    
    // get the most current emailed suggestions
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
