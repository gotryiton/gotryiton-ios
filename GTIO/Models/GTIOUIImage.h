//
//  GTIOUIImage.h
//  GTIO
//
//  Created by Simon Holroyd on 9/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOUIImage : UIImage


+ (NSString*)retinaImageString;
+ (NSURL*)deviceSpecificURL:(NSURL*)url;
+ (NSString*)deviceSpecificName:(NSString*)name;
+ (NSString*)retinaImageStringForUIImage:(BOOL)show2x;

@end
