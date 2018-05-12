//
//  GeneralServices.h
//  testsender
//
//  Created by Noverio Joe on 18/04/18.
//  Copyright © 2018 ocbcnisp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "testsender-Swift.h"

@interface GeneralServices : NSObject
@property HttpObject *httpCaller;

-(void) getBranchLocationsWithLat : (double)lat longitude : (double)lonng : (void(^)(IOServiceModel *))onGetBranchFinish;
@end
