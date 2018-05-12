//
//  LocationBasedARViewController.h
//  testsender
//
//  Created by Noverio Joe on 18/04/18.
//  Copyright © 2018 ocbcnisp. All rights reserved.
//

#import "GeneralServices.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationBasedARViewController : UIViewController<CLLocationManagerDelegate,ARDataSource,AnnotationViewDelegate>

@property double currentLatitude;
@property double currentLongitude;
@property NSArray *branchDataLocations;
@property CLLocation *currentLocation;
@property ARViewController *arViewController;

@property NSMutableArray *places;
@property (strong, atomic) GeneralServices *service;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *lblLongitude;
@property (weak, nonatomic) IBOutlet UILabel *lblLatitude;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
