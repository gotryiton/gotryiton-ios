//
//  GTIOTab.h
//  GTIO
//
//  Created by Scott Penrose on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOTab : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *endpoint;
@property (nonatomic, copy) NSString *tabType;
@property (nonatomic, strong) NSNumber *selected;

@end
