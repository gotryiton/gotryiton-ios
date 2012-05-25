//
//  GTIOPhotoToolbarView.h
//  GTIO
//
//  Created by Scott Penrose on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOCameraToolbarView : UIView

@property (nonatomic, strong) GTIOButton *closeButton;
@property (nonatomic, strong) GTIOButton *photoPickerButton;
@property (nonatomic, strong) GTIOButton *photoShootGridButton;
@property (nonatomic, strong) GTIOButton *shutterButton;

@end
