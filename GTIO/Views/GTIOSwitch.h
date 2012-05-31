//
//  GTIOSwitch.h
//  GTIO
//
//  Created by Scott Penrose on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

typedef void(^GTIOSwitchChangeHandler)(BOOL on);

@interface GTIOSwitch : UIControl

@property (nonatomic, strong) UIImage *track;
@property (nonatomic, strong) UIImage *trackFrame;
@property (nonatomic, strong) UIImage *trackFrameMask;

@property (nonatomic, strong) UIImage *knob;
@property (nonatomic, strong) UIImage *knobOn;
@property (nonatomic, strong) UIImage *knobOff;

@property (nonatomic, assign, getter=isOn) BOOL on;

@property (nonatomic, copy) GTIOSwitchChangeHandler changeHandler;

@end
