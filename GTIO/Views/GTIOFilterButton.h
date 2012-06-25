//
//  GTIOFilterButton.h
//  GTIO
//
//  Created by Scott Penrose on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"
#import "GTIOPhotoFilterView.h"

@interface GTIOFilterButton : GTIOUIButton

+ (id)buttonWithFilterType:(GTIOFilterType)filterType tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
