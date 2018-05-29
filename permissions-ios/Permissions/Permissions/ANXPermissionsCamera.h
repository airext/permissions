//
//  ANXPermissionsCamera.h
//  ANXPermissions
//
//  Created by Max Rozdobudko on 5/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANXPermissions.h"

@interface ANXPermissionsCamera : NSObject

#pragma mark Shared Instance

+ (ANXPermissionsCamera*) sharedInstance;

#pragma mark API

- (NSString*)status;

- (void)requestWithCompletion:(RequestPermissionCompletion)completion;

@end
