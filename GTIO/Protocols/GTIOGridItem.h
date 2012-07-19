//
//  GTIOGridItem.h
//  GTIO
//
//  Created by Scott Penrose on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTIOPhoto;
@class GTIOButtonAction;

@protocol GTIOGridItem <NSObject>

@required
@property (nonatomic, strong) GTIOButtonAction *action;
@property (nonatomic, strong) GTIOPhoto *photo;

@end
