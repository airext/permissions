//
//  ANXPermissionsConversionRoutines.h
//  ANXPermissions
//
//  Created by Max Rozdobudko on 5/28/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

@interface ANXPermissionsConversionRoutines : NSObject

#pragma mark Conversion methods

+(FREObject) convertNSStringToFREObject:(NSString*) string;
+(NSString*) convertFREObjectToNSString: (FREObject) string;

+(BOOL) convertFREObjectToBool: (FREObject) value;
+(FREObject) convertBoolToFREObject: (BOOL) value;

@end
