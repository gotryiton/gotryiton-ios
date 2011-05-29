//
//  GTIOBrowseListTTModel.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOBrowseListTTModel is a generic [RKRequestTTModel](RKRequestTTModel) for all browse lists in GTIO
/// handles pagination
#import <RestKit/Three20/Three20.h>
#import "GTIOBrowseList.h"


@interface GTIOBrowseListTTModel : RKRequestTTModel {
    GTIOBrowseList* _list;
    BOOL _hasMoreToLoad;
}
/// Browse List for Model
@property (nonatomic, retain) GTIOBrowseList* list;
/// True if there are more objects available to load
@property (nonatomic, assign) BOOL hasMoreToLoad;

@end
