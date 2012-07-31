//
//  GTIOAlert.h
//  GTIO
//
//  Created by Scott Penrose on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

@interface GTIOAlert : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *buttons;

@end
