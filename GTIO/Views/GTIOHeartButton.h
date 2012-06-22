//
//  GTIOHeartButton.h
//  GTIO
//
//  Created by Scott Penrose on 6/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"

@interface GTIOHeartButton : GTIOUIButton

@property (nonatomic, assign, getter = isHearted) BOOL hearted;

+ (id)heartButtonWithTapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
