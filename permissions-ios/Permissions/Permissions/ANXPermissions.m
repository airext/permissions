//
//  ANXPermissions.m
//  ANXPermissions
//
//  Created by Max Rozdobudko on 5/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import "ANXPermissions.h"
#import "ANXPermissionsCamera.h"
#import "ANXPermissionsLocation.h"

@implementation ANXPermissions

#pragma mark Shared Instance

static ANXPermissions* _sharedInstance = nil;
+ (ANXPermissions*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}

#pragma mark API

- (NSString*)authorizationStatusForPermission:(NSString*)permission {
    NSLog(@"[ANXPermissions authorizationStatusForPermission:%@]", permission);
    if ([permission isEqualToString:@"camera"]) {
        return [ANXPermissionsCamera.sharedInstance status];
    } else if ([permission isEqualToString:@"location"]) {
        return [ANXPermissionsLocation.sharedInstance status];
    }
    return nil;
}

- (void)request:(NSString*)permission withCompletion:(RequestPermissionCompletion)completion {
    NSLog(@"[ANXPermissions permission:%@ withCompletion:]", permission);
    if ([permission isEqualToString:@"camera"]) {
        [ANXPermissionsCamera.sharedInstance requestWithCompletion:completion];
    }else if ([permission isEqualToString:@"location"]) {
        [ANXPermissionsLocation.sharedInstance requestWithCompletion:completion];
    }
}

@end
