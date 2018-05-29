//
//  ANXPermissionsCamera.m
//  ANXPermissions
//
//  Created by Max Rozdobudko on 5/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import "ANXPermissionsCamera.h"
#import <AVFoundation/AVFoundation.h>

@implementation ANXPermissionsCamera

#pragma mark Shared Instance

static ANXPermissionsCamera* _sharedInstance = nil;
+ (ANXPermissionsCamera*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}

#pragma mark API

- (NSString*)status {

    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            return ANXAuthorizationStatusGranted;
            break;

        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            return ANXAuthorizationStatusDenied;
            break;

        default:
            return ANXAuthorizationStatusUnknown;
            break;
    }
}

- (void)requestWithCompletion:(RequestPermissionCompletion)completion {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            completion(ANXAuthorizationStatusGranted);
        } else {
            completion(ANXAuthorizationStatusDenied);
        }
    }];
}

@end
