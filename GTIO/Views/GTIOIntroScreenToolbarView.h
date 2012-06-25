//
//  GTIOIntroScreenToolbarView.h
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOPageControl.h"

@interface GTIOIntroScreenToolbarView : UIView

@property (nonatomic, strong) GTIOPageControl *pageControl;

@property (nonatomic, strong) GTIOUIButton *signInButton;
@property (nonatomic, strong) GTIOUIButton *nextButton;

- (void)hideButtons:(BOOL)hidden;

@end
