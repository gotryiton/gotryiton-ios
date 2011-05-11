//
//  GTIOMapGlobalsTTModel.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOMapGlobalsTTModel.h"
#import "GTIOGlobalVariableStore.h"

@interface RKRequestTTModel (Private)

- (void)modelsDidLoad:(NSArray*)models;

@end


@implementation GTIOMapGlobalsTTModel

//- (void)mapGlobalsFrom:(NSArray*)models {
//	
//	NSArray* reasons = nil;
//	for (NSDictionary* model in models) {
//		if ([model isKindOfClass:[NSDictionary class]]) {//[model respondsToSelector:@selector(valueForKey:)]
//			@try {
//				reasons = [model valueForKey:@"global_changeitReasons"];
//			}
//			@catch (NSException * e) {
//				NSLog(@"Failed to find any reasons: %@", e);
//			}
//			if (reasons) {
//				[GTIOGlobalVariableStore sharedStore].changeItReasons = reasons;
//				break;
//			}
//		}
//	}
//}
//
//- (void)modelsDidLoad:(NSArray*)models {
//	[self mapGlobalsFrom:models];
//	[super modelsDidLoad:models];
//}

@end
