//
//  ANXBridge.h
//  Bridge
//
//  Created by Max Rozdobudko on 12/24/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "ANXBridgeCall.h"

extern NSInteger ANX_BRIDGE_MAX_QUEUE_LENGTH;

@interface ANXBridge : NSObject

+(BOOL) setup: (uint32_t*) numFunctionsToSet functions: (FRENamedFunction**) functionsToSet;

+(ANXBridgeCall*) call: (FREContext) context;

+(ANXBridgeCall*) callWithId: (NSUInteger) anId;

@end
