//
//  LocationBasedARViewController.m
//  testsender
//
//  Created by Noverio Joe on 18/04/18.
//  Copyright © 2018 ocbcnisp. All rights reserved.
//

#import "LocationBasedARViewController.h"
#import "MapPin.h"

@interface LocationBasedARViewController ()

@end

@implementation LocationBasedARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self){
        self.service = [GeneralServices new];
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLHeadingFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        self.mapView.showsUserLocation = YES; //show the user's location on the map, requires CoreLocation
        self.mapView.scrollEnabled = "YES";//the default anyway
        self.mapView.zoomEnabled = "YES";//the default anyway
        
        self.places = [NSMutableArray new];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLatitudeLongitudeWithValue : (NSString*)longt latitude : (NSString*)lat{
    self.currentLatitude = [lat doubleValue];
    self.currentLongitude = [longt doubleValue];
    
    self.lblLatitude.text = lat;
    self.lblLongitude.text = longt;
}

- (IBAction)btnOnLocation:(id)sender {
    [self renderInitialMap];
}

- (IBAction)showARViewController:(id)sender {
    self.arViewController = [ARViewController new];
    [self.arViewController setDataSource:self];
    self.arViewController.presenter.maxVisibleAnnotations = 30;
    
    [self.arViewController setAnnotations:self.places];
    [self presentViewController:self.arViewController animated:YES completion:nil];
}

//** Private Method **//
- (void)renderInitialMap{
    CLLocationCoordinate2D center;
    center.latitude =  self.currentLocation.coordinate.latitude;
    center.longitude = self.currentLocation.coordinate.longitude;
    
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .1f;
    zoom.longitudeDelta = .1f;
    
    MKCoordinateRegion myRegion;
    myRegion.center = center;//the location
    myRegion.span = zoom;//set zoom level
    
    [self.mapView setRegion:myRegion animated:YES];
    
    [self.service getBranchLocationsWithLat:self.currentLatitude longitude:self.currentLongitude :^(IOServiceModel *result) {
        self.branchDataLocations = [((NSDictionary*)(result.anyDataJsonContent)) objectForKey:@"data"];
        
        for (NSDictionary *object in self.branchDataLocations) {
            NSString *latt = (NSString*)[object objectForKey:@"Latitude"];
            NSString *longt = (NSString*)[object objectForKey:@"Longitude"];
            NSString *name = (NSString*)[object objectForKey:@"Name"];
            NSString *address = (NSString*)[object objectForKey:@"Address"];
            
            CLLocationCoordinate2D branchCoordinate;
            branchCoordinate.latitude = [latt doubleValue];
            branchCoordinate.longitude = [longt doubleValue];
            
            CLLocation *branchLocation = [[CLLocation alloc] initWithCoordinate:branchCoordinate altitude:-1 horizontalAccuracy:200.0 verticalAccuracy:200.0 timestamp:[NSDate date]];
            
            [self.places addObject:[[Place alloc] initWithLocation:branchLocation reference:@"test" name:name address:address]];
            
            MapPin *pin = [[MapPin alloc] init];
            pin.title = name;
            pin.subtitle = address;
            pin.coordinate = branchCoordinate;
            [self.mapView addAnnotation:pin];
        }
    }];

}

//** CLLocation Manager Delegate **//
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to Get Your Location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
     */
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways){
        [self.locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        self.currentLocation = currentLocation;
        [self updateLatitudeLongitudeWithValue:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]];
        
        //[self.locationManager stopUpdatingLocation];
    }
}


//** Annotation **//
- (void)didTouchWithAnnotationView:(AnnotationView * _Nonnull)annotationView{
    
}

//** ARDataSource Delegate **//
- (ARAnnotationView * _Nonnull)ar:(ARViewController * _Nonnull)arViewController viewForAnnotation:(ARAnnotation * _Nonnull)viewForAnnotation SWIFT_WARN_UNUSED_RESULT{
    AnnotationView *resultView = [AnnotationView new];
    resultView.annotation = viewForAnnotation;
    resultView.delegate = self;
    resultView.frame = CGRectMake(0, 0, 150, 50);
    
    return resultView;
}


@end








