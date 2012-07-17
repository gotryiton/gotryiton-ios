//
//  GTIOLooksSegmentedControlView.h
//  GTIO
//
//  Created by Scott Penrose on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTab.h"

typedef void(^GTIOLooksSegmentedControlValueChangedHandler)(GTIOTab *tab);

@interface GTIOLooksSegmentedControlView : UIView

@property (nonatomic, strong) NSArray *tabs;
@property (nonatomic, copy) GTIOLooksSegmentedControlValueChangedHandler segmentedControlValueChangedHandler;

@end
