//
//  GTIOMasonGridItemWithFrameView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMasonGridItem.h"

static CGFloat const kGTIOGridItemPhotoPadding = 4.0f;
static CGFloat const kGTIOGridItemPhotoBottomPadding = 5.0f;

typedef void(^GTIOMasonGridItemTapHandler)(GTIOMasonGridItem *gridItem);

@interface GTIOMasonGridItemWithFrameView : UIView

@property (nonatomic, strong) GTIOMasonGridItem *gridItem;
@property (nonatomic, copy) GTIOMasonGridItemTapHandler tapHandler;

- (id)initWithFrame:(CGRect)frame gridItem:(GTIOMasonGridItem *)gridItem;

@end
