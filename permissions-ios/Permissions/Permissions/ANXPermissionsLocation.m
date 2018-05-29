//
//  ANXPermissionsLocation.m
//  ANXPermissions
//
//  Created by Max Rozdobudko on 5/29/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import "ANXPermissionsLocation.h"

@implementation ANXPermissionsLocation {
    CLLocationManager* _locationManager;
    RequestPermissionCompletion _authorizationCompletionHandler;
}

#pragma mark Shared Instance

static ANXPermissionsLocation* _sharedInstance = nil;
+ (ANXPermissionsLocation*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}

#pragma mark API

- (NSString*)status {
    NSLog(@"ANXPermissionsLocation.status");
    return [self stringFromAuthorizationStatus:[CLLocationManager authorizationStatus]];
}

- (void)requestWithCompletion:(RequestPermissionCompletion)completion {
    NSLog(@"[ANXPermissionsLocation requestWithCompletion:]");
    _authorizationCompletionHandler = completion;

    if (!_locationManager) {
        NSLog(@"[ANXPermissionsLocation: create location manager]");
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }

    [_locationManager requestWhenInUseAuthorization];
}

#pragma mark Internal methods

- (NSString*)stringFromAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            return ANXAuthorizationStatusDenied;
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return ANXAuthorizationStatusGranted;
            break;

        default:
            return ANXAuthorizationStatusUnknown;
            break;
    }
}

@end

#pragma mark <CLLocationManagerDelegate>

@implementation ANXPermissionsLocation (CLLocationManagerDelegate)

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"[ANXPermissionsLocation locationManager:%@ didChangeAuthorizationStatus:%i]", manager, status);
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    if (_authorizationCompletionHandler) {
        _authorizationCompletionHandler([self stringFromAuthorizationStatus:status]);
        _authorizationCompletionHandler = nil;
    }
    _locationManager = nil;
}

@end
