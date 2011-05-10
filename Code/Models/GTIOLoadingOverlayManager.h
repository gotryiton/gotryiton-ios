//
//  GTIOLoadingOverlayManager.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOLoadingOverlayManager : NSObject {
	NSMutableArray* _views;
}

+ (GTIOLoadingOverlayManager*)sharedManager;

@end
