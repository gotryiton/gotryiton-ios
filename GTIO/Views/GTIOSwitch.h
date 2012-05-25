//
//  GTIOSwitch.h
//  GTIO
//
//  Created by Scott Penrose on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "RCSwitch.h"

@interface GTIOSwitch : UIView

@property (nonatomic, strong) UIImage *trackOn;
@property (nonatomic, strong) UIImage *trackOff;

@property (nonatomic, strong) UIImage *knob;
@property (nonatomic, strong) UIImage *knobOn;
@property (nonatomic, strong) UIImage *knobOff;

@property (nonatomic, assign, getter=isOn) BOOL on;

@end
