//
//  GTIOPhotoFilterSelecterView.h
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFilter.h"

typedef void(^GTIOPhotoFilterSelectedHandler)(GTIOFilterType filterType);

@interface GTIOPhotoFilterSelectorView : UIView

@property (nonatomic, copy) GTIOPhotoFilterSelectedHandler photoFilterSelectedHandler;

@end
