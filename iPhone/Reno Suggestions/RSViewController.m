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
#import "AllIdeas.h"
#import "Idea.h"

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

-(NSString *)getLatestLatitude;
{
    return [NSString stringWithFormat:@"%lf", [latitude doubleValue]];
}

-(NSString *)getLatestLongitude;
{
    return [NSString stringWithFormat:@"%lf", [longitude doubleValue]];
}

-(void) showAddress {
    
    
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.01;
	span.longitudeDelta = 0.01;
	
	CLLocationCoordinate2D cord;
		AddressAnnotation *addAnnotation = nil;
    
	if(addAnnotation != nil) {
		[mapView removeAnnotation:addAnnotation];
		[addAnnotation release];
		addAnnotation = nil;
	}
   // cord.longitude = -119.813803;
	//cord.latitude = 39.529633; 

    cord.longitude = [longitude doubleValue];
	cord.latitude = [latitude doubleValue];
    NSLog(@"Latitude:%f",cord.latitude);
	region.span = span;
	region.center = cord;
	
    
    AllIdeas *allIdeas = [[[AllIdeas alloc] initIdeas]retain];
    
    
    
    NSArray *arrayIdeas =[[AllIdeas sharedIdeas]getListOfIdeas:[NSString stringWithFormat:@"%lf", cord.longitude] withLat:[NSString stringWithFormat:@"%lf", cord.latitude] andRadius:kRadius];
    
    for(int i = 0; i < [arrayIdeas count]; ++i)
    {
        NSDictionary *dictIdea = [arrayIdeas objectAtIndex:i];
        cord.longitude = [[dictIdea objectForKey:@"longitude"] doubleValue];
        cord.latitude = [[dictIdea objectForKey:@"latitude"] doubleValue]; 
        addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:cord];
        addAnnotation.mTitle = [dictIdea objectForKey:@"who"];
        addAnnotation.mSubTitle = [dictIdea objectForKey:@"what"];
        NSLog(@"submission %@", addAnnotation.mTitle);
        [mapView addAnnotation:addAnnotation];

    }
    
    
    
	
    
    
    //cord.longitude = -119.853803;
	//cord.latitude = 39.529633;
    //AddressAnnotation *addAnnotation1 = [[AddressAnnotation alloc] initWithCoordinate:cord];
	//addAnnotation1.mTitle = @"test";
    //addAnnotation.mSubTitle = @"My Subtitle2";
    //[mapView addAnnotation:addAnnotation1];
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

    vc.currentLongitude = [NSString stringWithFormat:@"%lf", [longitude doubleValue]];
    vc.currentLatitude = [NSString stringWithFormat:@"%lf", [latitude doubleValue]];

    
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentModalViewController:navController animated:YES];
    
    return;
}
-(IBAction)suggestionButtonPressed:(id)sender
{
    submitViewController *vc = [[[submitViewController alloc] initWithNibName:@"submitViewController" bundle:nil] autorelease];
    vc.lastLatitude = [NSString stringWithFormat:@"%lf", [latitude doubleValue]];
    vc.lastLongitude = [NSString stringWithFormat:@"%lf", [longitude doubleValue]];
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentModalViewController:navController animated:YES];
   
    
    return;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation]; 
    
    [super viewDidLoad];
     [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showAddress) userInfo:nil repeats:NO];
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
     [self showAddress];
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
