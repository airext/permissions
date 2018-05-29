//
//  Permissions.m
//  Permissions
//
//  Created by Max Rozdobudko on 5/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANXPermissionsFacade.h"
#import "FlashRuntimeExtensions.h"
#import "ANXBridge.h"
#import "ANXBridgeCall.h"
#import "ANXPermissions.h"
#import "ANXPermissionsConversionRoutines.h"

@implementation ANXPermissionsFacade

@end

#pragma mark API

FREObject ANXPermissionsIsSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    FREObject result;
    FRENewObjectFromBool(YES, &result);
    return result;
}

FREObject ANXPermissionsCheck(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXPermissionsCheck");

    if (argc == 0) {
        return NULL;
    }

    NSString* permission = [ANXPermissionsConversionRoutines convertFREObjectToNSString:argv[0]];

    NSString* status = [ANXPermissions.sharedInstance authorizationStatusForPermission:permission];

    return [ANXPermissionsConversionRoutines convertNSStringToFREObject:status];
}

FREObject ANXPermissionsRequest(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXPermissionsRequest");

    if (argc == 0) {
        return NULL;
    }

    ANXBridgeCall* call = [ANXBridge call:context];

    NSString* permission = [ANXPermissionsConversionRoutines convertFREObjectToNSString:argv[0]];

    [ANXPermissions.sharedInstance request:permission withCompletion:^(NSString *authorizationStatus) {
        [call result:authorizationStatus];
    }];

    return [call toFREObject];
}

FREObject ANXPermissionsOpenSettings(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSURL* appSettingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (appSettingsURL != nil) {
        [UIApplication.sharedApplication openURL:appSettingsURL];
    }
    return NULL;
}

#pragma mark ContextInitialize/ContextFinalizer

void ANXPermissionsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet){
    NSLog(@"ANXPermissionsContextInitializer");

    *numFunctionsToSet = 4;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));

    // functions

    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &ANXPermissionsIsSupported;

    func[1].name = (const uint8_t*) "check";
    func[1].functionData = NULL;
    func[1].function = &ANXPermissionsCheck;

    func[2].name = (const uint8_t*) "request";
    func[2].functionData = NULL;
    func[2].function = &ANXPermissionsRequest;

    func[3].name = (const uint8_t*) "openSettings";
    func[3].functionData = NULL;
    func[3].function = &ANXPermissionsOpenSettings;

    // setup bridge

    [ANXBridge setup:numFunctionsToSet functions:&func];

    *functionsToSet = func;
}

void ANXPermissionsContextFinalizer(FREContext ctx)
{
    NSLog(@"ANXPermissionsContextFinalizer");
}

#pragma mark Initializer/Finalizer

void ANXPermissionsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    NSLog(@"ANXPermissionsInitializer");

    *extDataToSet = NULL;

    *ctxInitializerToSet = &ANXPermissionsContextInitializer;
    *ctxFinalizerToSet = &ANXPermissionsContextFinalizer;
}

void ANXPermissionsFinalizer(void* extData)
{
    NSLog(@"ANXPermissionsFinalizer");
}
