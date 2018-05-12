//
//  MapPin.h
//  testsender
//
//  Created by Noverio Joe on 19/04/18.
//  Copyright © 2018 ocbcnisp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject<MKAnnotation>
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@end
