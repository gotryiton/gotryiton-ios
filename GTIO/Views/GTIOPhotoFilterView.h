//
//  GTIOPhotoFilterView.h
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOFilter.h"

@protocol GTIOPhotoFilterViewDelegate;

@interface GTIOPhotoFilterView : UIView

@property (nonatomic, assign) GTIOFilterType filterType;
@property (nonatomic, assign, getter = isFilterSelected) BOOL filterSelected;
@property (nonatomic, weak) id<GTIOPhotoFilterViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame filterType:(GTIOFilterType)filterType filterSelected:(BOOL)filterSelected;

@end

@protocol GTIOPhotoFilterViewDelegate <NSObject>

@required
- (void)didSelectFilterView:(GTIOPhotoFilterView *)filterView;

@end
