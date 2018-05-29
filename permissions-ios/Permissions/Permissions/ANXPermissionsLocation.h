//
//  ANXPermissionsLocation.h
//  ANXPermissions
//
//  Created by Max Rozdobudko on 5/29/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ANXPermissions.h"

@interface ANXPermissionsLocation : NSObject

#pragma mark Shared Instance

+ (ANXPermissionsLocation*) sharedInstance;

#pragma mark API

- (NSString*)status;

- (void)requestWithCompletion:(RequestPermissionCompletion)completion;


@end

#pragma mark <CLLocationManagerDelegate>

@interface ANXPermissionsLocation (CLLocationManagerDelegate) <CLLocationManagerDelegate>

@end
