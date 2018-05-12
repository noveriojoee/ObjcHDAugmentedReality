//
//  GeneralServices.m
//  testsender
//
//  Created by Noverio Joe on 18/04/18.
//  Copyright © 2018 ocbcnisp. All rights reserved.
//

#import "GeneralServices.h"

@implementation GeneralServices


-(id)init{
    if (self){
        self = [super init];
        
        self.httpCaller = [HttpObject new];
    }
    
    return self;
}

-(void) getBranchLocationsWithLat : (double)lat longitude : (double)lonng : (void(^)(IOServiceModel *))onGetBranchFinish{
    IOServiceModel *result = [IOServiceModel new];
    result.errCode = @"999";
    result.errMessage = @"Unknown Error";
    
    NSMutableDictionary *requestData = [NSMutableDictionary new];
    [requestData setValue:[[NSNumber alloc] initWithDouble:lat] forKey:@"latitude"];
    [requestData setValue:[[NSNumber alloc] initWithDouble:lonng] forKey:@"longitude"];
    [requestData setValue:[[NSNumber alloc] initWithDouble:10] forKey:@"radius"];
    [requestData setValue:@"xxxxxxxxxx" forKey:@"token"];

    
    NSString *strUrl = @"https://pddigitalbankingcloudservice.azurewebsites.net/api/Location/NearByMe";
    [self.httpCaller CallHTTPServiceWithEndpointURL:strUrl jsonDataRequest:requestData isSecuredRequest:NO httpComplete:^(IOServiceModel *getBranchResult) {
        result.errCode = getBranchResult.errCode;
        result.errMessage = getBranchResult.errMessage;
        result.anyDataJsonContent = getBranchResult.anyDataJsonContent;
        onGetBranchFinish(result);
    }];
}
@end
