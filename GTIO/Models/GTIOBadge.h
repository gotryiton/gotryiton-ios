//
//  GTIOBadge.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOBadge : NSObject

@property (nonatomic, strong) NSURL *path;

- (NSURL *)badgeImageURL;

@end
