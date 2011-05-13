//
//  GTIOBrowseListTTModel.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <RestKit/Three20/Three20.h>
#import "GTIOBrowseList.h"


@interface GTIOBrowseListTTModel : RKRequestTTModel {
    GTIOBrowseList* _list;
    BOOL _hasMoreToLoad;
}

@property (nonatomic, retain) GTIOBrowseList* list;
@property (nonatomic, assign) BOOL hasMoreToLoad;

@end
