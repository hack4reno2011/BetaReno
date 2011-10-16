//
//  RSViewController.h
//  Reno Suggestions
//
//  Created by Jack Angelo on 10/14/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import <MapKit/MapKit.h>



@interface RSViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>{
    
    
    UIButton*               cameraButton;
    UIButton*               locationButton;
    UIButton*               suggestionButton;
    MKMapView*              mapView; 
    NSNumber*               longitude;
	NSNumber*               latitude;
    CLLocationManager*      locationManager;
	CLLocation*             startingPoint;
    UIActivityIndicatorView  *aSpinner; 

    
    
}

@property (nonatomic, retain)   IBOutlet UIButton*      cameraButton;
@property (nonatomic, retain)   IBOutlet UIButton*      locationButton;
@property (nonatomic, retain)   IBOutlet UIButton*      suggestionButton;
@property (nonatomic, retain)   IBOutlet MKMapView*     mapView;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;
@property (nonatomic, retain) UIActivityIndicatorView *aSpinner;


-(IBAction)cameraButtonPressed:(id)sender;
-(IBAction)locationButtonPressed:(id)sender;
-(IBAction)suggestionButtonPressed:(id)sender;

-(NSString *)getLatestLatitude;
-(NSString *)getLatestLongitude;


@end
