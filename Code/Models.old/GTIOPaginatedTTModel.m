//
//  GTIOPaginatedTTModel.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOPaginatedTTModel.h"
#import "GTIOOutfit.h"

@implementation GTIOPaginatedTTModel

@synthesize objectsKey = _objectsKey;
@synthesize profile = _profile;

- (void)dealloc {
	[_objectsKey release];
	_objectsKey = nil;
	[_profile release];
	_profile = nil;

	[super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (more) {
		GTIOOutfit* lastOutfit = [self.objects lastObject];
		NSLog(@"Load Next Page");
		NSLog(@"Last Object: %@", lastOutfit.timestamp);
		
		RKObjectLoader* objectLoader = [[[RKObjectManager sharedManager] objectLoaderWithResourcePath:_resourcePath delegate:self] retain];
		objectLoader.method = self.method;
//		objectLoader.objectClass = _objectClass;
//		objectLoader.keyPath = _keyPath;
		
		NSMutableDictionary* paramsForNextPage = [[self.params mutableCopy] autorelease];
		[paramsForNextPage setObject:lastOutfit.timestamp forKey:@"lasttime"];
		objectLoader.params = paramsForNextPage;
		
		_isLoading = YES;
		_isLoadingMore = YES;
		[self didStartLoad];
		[objectLoader send];
		
	} else {
		_isLoadingMore = NO;
		[super load:cachePolicy more:more];
	}
}

- (NSArray*)objectsFromArray:(NSArray*)objects {
	for (id object in objects) {
		if ([object isKindOfClass:[NSDictionary class]]) {
			id val = [object valueForKey:_objectsKey];
			if (val) {
				return val;
			}
		} else {
			if ([object isKindOfClass:[GTIOProfile class]]) {
				_profile = (GTIOProfile*)[object retain];
			}
			SEL sel = NSSelectorFromString(_objectsKey);
			if ([object respondsToSelector:sel]) {
				id val = (NSArray*)[object performSelector:sel];
				if (val) {
					return val;
				}
			}
		}
	}
	return objects;
}

- (BOOL)isLoadingMore {
	return _isLoadingMore;
}

- (BOOL)hasMoreToLoad {
	BOOL ret = !_noMoreToLoad;
	return ret;
}

- (void)modelsDidLoad:(NSArray*)models {
	if (_isLoadingMore) {
		NSArray* objects = [self objectsFromArray:models];
		NSArray* newObjects = [[_objects arrayByAddingObjectsFromArray:objects] retain];
		_noMoreToLoad = ([newObjects count] == [_objects count]);
		[_objects release];
		_objects = newObjects;
	} else {
		_noMoreToLoad = NO;
		[_objects release];
		_objects = [[self objectsFromArray:models] retain];
	}
	_isLoadingMore = NO;
	_isLoading = NO;
	_isLoaded = YES;
	[self didFinishLoad];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[super objectLoader:objectLoader didLoadObjects:objects];
	_isLoadingMore = NO;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	[super objectLoader:objectLoader didFailWithError:error];
	_isLoadingMore = NO;
}

@end
