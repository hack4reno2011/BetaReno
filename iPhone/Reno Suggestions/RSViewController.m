//
//  RSViewController.m
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/14/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import "RSViewController.h"
#import "AddressAnnotation.h"
#import "submitViewController.h"

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

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
		  fromLocation:(CLLocation *)oldLocation
{
	if (startingPoint == nil)
		self.startingPoint = newLocation;
	latitude = [[NSNumber alloc] initWithDouble:(double)newLocation.coordinate.latitude];
	longitude = [[NSNumber alloc] initWithDouble:(double)newLocation.coordinate.longitude];
}

-(void) showAddress {
    
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.2;
	span.longitudeDelta = 0.2;
	
	CLLocationCoordinate2D cord;
	cord.longitude = -119.813803;
	cord.latitude = 39.529633; 
	//cord.longitude = [longitude doubleValue];
	//cord.latitude = [latitude doubleValue];
	region.span = span;
	region.center = cord;
	AddressAnnotation *addAnnotation = nil;
    
	if(addAnnotation != nil) {
		[mapView removeAnnotation:addAnnotation];
		[addAnnotation release];
		addAnnotation = nil;
	}
    
	addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:cord];
	addAnnotation.mTitle = @"TEST123";
    addAnnotation.mSubTitle = @"My Subtitle";
    [mapView addAnnotation:addAnnotation];
    
    
    cord.longitude = -119.853803;
	cord.latitude = 39.529633;
    AddressAnnotation *addAnnotation1 = [[AddressAnnotation alloc] initWithCoordinate:cord];
	addAnnotation1.mTitle = @"test";
    addAnnotation.mSubTitle = @"My Subtitle2";
    [mapView addAnnotation:addAnnotation1];
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
}

-(IBAction)cameraButtonPressed:(id)sender
{
    [self showAddress];
}
-(IBAction)locationButtonPressed:(id)sender
{
    ListViewController *vc = [[[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentModalViewController:navController animated:YES];
    
    return;
}
-(IBAction)suggestionButtonPressed:(id)sender
{
    submitViewController *vc = [[[submitViewController alloc] initWithNibName:@"submitViewController" bundle:nil] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentModalViewController:navController animated:YES];
    
   
    
    return;
}

//Table View Protocols





#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation]; 
//     get the most current emailed suggestions
	
    [super viewDidLoad];
    [self showAddress];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [locationManager release];

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
