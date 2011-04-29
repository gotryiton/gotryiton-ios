//
//  AppLaunchSpec.m
//  GTIO
//
//  Created by Blake Watters on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISpec.h"

@interface AppLaunchSpec : NSObject <UISpec> {
    
}

@end

@implementation AppLaunchSpec

- (void)itShouldRunSpecs {
    NSLog(@"Log something...");
}

@end
