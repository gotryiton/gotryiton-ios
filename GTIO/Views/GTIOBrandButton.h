//
//  GTIOBrandButton.h
//  GTIO
//
//  Created by Scott Penrose on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"

#import "GTIOButton.h"

@interface GTIOBrandButton : GTIOUIButton

@property (nonatomic, strong) GTIOButton *buttonModel;

+ (id)gtio_brandButton:(GTIOButton *)buttonModel tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
