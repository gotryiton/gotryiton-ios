//
//  GTIOTag.h
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOTag : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic, strong) GTIOButtonAction *action;

@end
