//
//  GTIOOutfitViewScrollDataSource.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOPaginatedTTModel.h"

@interface GTIOOutfitViewScrollDataSource : NSObject <TTScrollViewDataSource> {
	GTIOPaginatedTTModel* _model;
    BOOL _moreToLoad;
}

@property (nonatomic, retain) GTIOPaginatedTTModel *model;
@property (nonatomic, assign) BOOL moreToLoad;

@end
