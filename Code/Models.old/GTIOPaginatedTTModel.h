//
//  GTIOPaginatedTTModel.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOProfile.h"
#import "GTIOMapGlobalsTTModel.h"

@interface GTIOPaginatedTTModel : GTIOMapGlobalsTTModel {
	NSString* _objectsKey;
	BOOL _isLoadingMore;
	// Will be populated if the root object was a profile.
	GTIOProfile* _profile;
	BOOL _noMoreToLoad;
}

@property (nonatomic, copy) NSString *objectsKey;
@property (nonatomic, readonly) GTIOProfile* profile;

- (BOOL)hasMoreToLoad;

@end
