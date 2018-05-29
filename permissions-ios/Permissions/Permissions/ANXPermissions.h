//
//  ANXPermissions.h
//  ANXPermissions
//
//  Created by Max Rozdobudko on 5/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Callbacks

typedef void(^RequestPermissionCompletion)(NSString *authorizationStatus);

#pragma mark Authorization Status

#define ANXAuthorizationStatusGranted @"granted"
#define ANXAuthorizationStatusDenied @"denied"
#define ANXAuthorizationStatusUnknown @"unknown"

@interface ANXPermissions : NSObject

#pragma mark Shared Instance

+ (ANXPermissions*) sharedInstance;

#pragma mark API

- (NSString*)authorizationStatusForPermission:(NSString*)permission;

- (void)request:(NSString*)permission withCompletion:(RequestPermissionCompletion)completion;

@end
