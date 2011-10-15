//
//  AddressAnnotation.h
//  Reno Suggestions
//
//  Created by Erik Hanchett on 10/15/11.
//  Copyright (c) 2011 Apps42, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>


@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *mTitle;
	NSString *mSubTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
