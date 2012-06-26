//
//  GTIOPhotoConfirmationToolbarView.h
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOPhotoConfirmationToolbarView : UIView

@property (nonatomic, strong) GTIOUIButton *closeButton;
@property (nonatomic, strong) GTIOUIButton *confirmButton;

- (void)showPhotoShootGridButton:(BOOL)showPhotoShootGridButton;

@end
