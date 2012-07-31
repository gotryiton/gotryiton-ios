//
//  GTIOError.h
//  GTIO
//
//  Created by Scott Penrose on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlert.h"

@interface GTIOError : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) GTIOAlert *alert;

@end
