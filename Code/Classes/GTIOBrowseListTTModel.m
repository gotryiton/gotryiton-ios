//
//  GTIOBrowseListTTModel.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOBrowseListTTModel.h"
#import "GTIOOutfit.h"

@interface RKObjectLoaderTTModel (Private)

- (void)saveLoadedTime;

@end

@implementation GTIOBrowseListTTModel

@synthesize list = _list;
@synthesize hasMoreToLoad = _hasMoreToLoad;

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (more) {
		GTIOOutfit* lastOutfit = [self.objects lastObject];
        if (nil == lastOutfit || _isLoading) {
            return;
        }
		NSLog(@"Load Next Page");
		NSLog(@"Last Object: %@", lastOutfit.timestamp);
		
		RKObjectLoader* objectLoader = [[[RKObjectManager sharedManager] objectLoaderWithResourcePath:_objectLoader.resourcePath delegate:self] retain];
		objectLoader.method = _objectLoader.method;
        objectLoader.cachePolicy = _objectLoader.cachePolicy;
        objectLoader.cacheTimeoutInterval = _objectLoader.cacheTimeoutInterval;
		
		NSMutableDictionary* paramsForNextPage = [[_objectLoader.params mutableCopy] autorelease];
        if (nil == paramsForNextPage) {
            paramsForNextPage = [NSMutableDictionary dictionary];
        }
		
        [paramsForNextPage setObject:lastOutfit.timestamp forKey:@"lasttime"];
        [paramsForNextPage setObject:[NSString stringWithFormat:@"%d", [self.objects count]] forKey:@"offset"];
        
		objectLoader.params = paramsForNextPage;
		
		_isLoading = YES;
		[objectLoader send];
	} else {
        self.list = nil;
		[super load:cachePolicy more:more];
	}
}

- (BOOL)hasMoreToLoad {
    if (_list.outfits == nil && _list.myLooks == nil && _list.reviews == nil) {
        return NO;
    }
    return _hasMoreToLoad;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    // don't call super here.
    ;
}

- (void)setObjects:(NSArray*)objects {
    [objects retain];
    [_objects release];
    _objects = objects;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
    NSLog(@"Dictionary: %@", dictionary);
    _isLoading = NO;
    if (self.list) {
        // loaded more.
        NSLog(@"LoadedMore");
        GTIOBrowseList* list = [dictionary objectForKey:@"list"];
        
        NSArray* moreOutfits = list.outfits;
        if (nil == moreOutfits) {
            moreOutfits = list.myLooks;
        }
        if (nil == moreOutfits) {
            moreOutfits = list.reviews;
        }
        
        if ([moreOutfits count] < kGTIOPaginationLimit) {
            NSLog(@"Setting has more to load to NO. Only loaded %d outfits", [moreOutfits count]);
            _hasMoreToLoad = NO;
        }
        NSArray* newObjects = [[_objects arrayByAddingObjectsFromArray:moreOutfits] retain];
        [_objects release];
        _objects = newObjects;
        [self didFinishLoad];
    } else {
        _hasMoreToLoad = YES;
        [self saveLoadedTime];
        self.list = [dictionary objectForKey:@"list"];
    
        NSArray* models = self.list.categories;
        if (nil == models) {
            models = self.list.outfits;
        }
        if (nil == models) {
            models = self.list.myLooks;
        }
        if (nil == models) {
            models = self.list.reviews;
        }
        [models retain];
        
        [_objects release];
        _objects = nil;
        _objects = models;
        _isLoaded = YES;
        [self didFinishLoad];
    }
}

- (BOOL)isOutdated {
    if (nil == self.list) {
        return YES;
    }
    return [super isOutdated];
}

@end
