//
//  GTIOBrowseListTTModel.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOBrowseListTTModel.h"
#import "GTIOOutfit.h"

@interface RKRequestTTModel (Private)

- (void)saveLoadedTime;

@end

@implementation GTIOBrowseListTTModel

@synthesize list = _list;
@synthesize hasMoreToLoad = _hasMoreToLoad;

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (more) {
		GTIOOutfit* lastOutfit = [self.objects lastObject];
		NSLog(@"Load Next Page");
		NSLog(@"Last Object: %@", lastOutfit.timestamp);
		
		RKObjectLoader* objectLoader = [[[RKObjectManager sharedManager] objectLoaderWithResourcePath:_resourcePath delegate:self] retain];
		objectLoader.method = self.method;
		
		NSMutableDictionary* paramsForNextPage = [[self.params mutableCopy] autorelease];
		[paramsForNextPage setObject:lastOutfit.timestamp forKey:@"lasttime"];
		objectLoader.params = paramsForNextPage;
		
		_isLoading = YES;
		[objectLoader send];
	} else {
		[super load:cachePolicy more:more];
	}
}

- (BOOL)hasMoreToLoad {
    if (_list.outfits == nil) {
        return NO;
    }
    return _hasMoreToLoad;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    ;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
    NSLog(@"Dictionary: %@", dictionary);
    if (self.list) {
        // loaded more.
        NSLog(@"LoadedMore");
        GTIOBrowseList* list = [dictionary objectForKey:@"list"];
        NSArray* moreOutfits = list.outfits;
        
        //TODO: this is the pagination limit. if it's not a full page, there are no more right?
        if ([moreOutfits count] < 20) {
            NSLog(@"Setting has more to load to NO. Only loaded %d outfits", [moreOutfits count]);
            _hasMoreToLoad = NO;
        }
        NSArray* newObjects = [[_objects arrayByAddingObjectsFromArray:moreOutfits] retain];
        [_objects release];
        _objects = newObjects;
        [self didFinishLoad];
    } else {
        _isLoading = NO;
        _hasMoreToLoad = YES;
        [self saveLoadedTime];
        self.list = [dictionary objectForKey:@"list"];
    
        NSArray* models = self.list.categories;
        if (nil == models) {
            models = self.list.outfits;
        }
        [models retain];
        
        [_objects release];
        _objects = nil;
        _objects = models;
        _isLoaded = YES;
        [self didFinishLoad];
    }
}

@end
