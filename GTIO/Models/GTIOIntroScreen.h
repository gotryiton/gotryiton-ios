//
//  GTIOIntroScreen.h
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOIntroScreen : NSObject <NSCoding>

@property (nonatomic, strong) NSString *introScreenID;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *track;

@end
