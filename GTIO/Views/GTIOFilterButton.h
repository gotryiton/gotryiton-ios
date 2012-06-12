//
//  GTIOFilterButton.h
//  GTIO
//
//  Created by Scott Penrose on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOButton.h"
#import "GTIOPhotoFilterView.h"

@interface GTIOFilterButton : GTIOButton

+ (id)buttonWithFilter:(GTIOFilter)filter tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
