//
//  GTIOOutfitReviewControlBar.h
//  GTIO
//
//  Created by Joshua Johnson on 2/8/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GTIOOutfitReviewControlBarTapHandler)(void);

@interface GTIOOutfitReviewControlBar : UIView

@property (nonatomic, copy) GTIOOutfitReviewControlBarTapHandler productSuggestHandler;
@property (nonatomic, copy) GTIOOutfitReviewControlBarTapHandler submitReviewHandler;

@end
