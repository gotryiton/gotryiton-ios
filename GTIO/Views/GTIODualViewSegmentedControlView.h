//
//  GTIODualViewSegmentedControlView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUserProfile.h"
#import "GTIOPostMasonryView.h"
#import "GTIOSegmentedControl.h"

extern NSString * const kGTIOMyHeartsTitle;

@interface GTIODualViewSegmentedControlView : UIView

@property (nonatomic, strong) GTIOPostMasonryView *leftPostsView;
@property (nonatomic, strong) GTIOPostMasonryView *rightPostsView;

@property (nonatomic, strong) GTIOSegmentedControl *dualViewSegmentedControl;

- (id)initWithFrame:(CGRect)frame leftControlTitle:(NSString *)leftControlTitle leftControlPostsType:(GTIOPostType)leftControlPostsType rightControlTitle:(NSString *)rightControlTitle rightControlPostsType:(GTIOPostType)rightControlPostsType;
- (void)setItems:(NSArray *)items GTIOPostType:(GTIOPostType)postType userProfile:(GTIOUserProfile *)userProfile;

@end
