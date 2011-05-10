//
//  GTIOLoadingOverlayManager.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOLoadingOverlayManager.h"

@implementation GTIOLoadingOverlayManager

static GTIOLoadingOverlayManager* sharedManager;

+ (GTIOLoadingOverlayManager*)sharedManager {
	if (nil == sharedManager) {
		sharedManager = [GTIOLoadingOverlayManager new];
	}
	return sharedManager;
}

- (id)init {
	if (self = [super init]) {
		_views = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)showLoading {
	UIViewController* top = [[TTNavigator navigator] topViewController];
	TTActivityLabel* label = [[TTActivityLabel alloc] initWithFrame:top.view.bounds style:TTActivityLabelStyleBlackBox text:@"loading..."];
	[_views addObject:label];
	[top.view addSubview:label];
	[label release];
}

- (void)stopLoading {
	for (UIView* view in _views) {
		[view removeFromSuperview];
	}
	[_views removeAllObjects];
}

- (void)dealloc {
	[self stopLoading];
	[_views release];
	[super dealloc];
}

@end
