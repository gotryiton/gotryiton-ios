//
//  GTIOOutfitViewScrollDataSource.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOOutfitViewScrollDataSource is the [TTScrollViewDataSource](TTScrollViewDataSource) 
/// that powers [GTIOOutfitViewController](GTIOOutfitViewController) from a [GTIOPaginatedTTModel](GTIOPaginatedTTModel)

#import <Foundation/Foundation.h>
#import "GTIOPaginatedTTModel.h"

@interface GTIOOutfitViewScrollDataSource : NSObject <TTScrollViewDataSource> {
	GTIOPaginatedTTModel* _model;
    BOOL _moreToLoad;
}

/// Model
@property (nonatomic, retain) GTIOPaginatedTTModel *model;
/// true if there are more objects to load
@property (nonatomic, assign) BOOL moreToLoad;

@end
