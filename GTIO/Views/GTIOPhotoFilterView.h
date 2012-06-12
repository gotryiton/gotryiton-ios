//
//  GTIOPhotoFilterView.h
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOPhotoFilterView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign, getter = isFilterSelected) BOOL filterSelected;

@end
