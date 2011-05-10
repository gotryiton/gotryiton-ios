//
//  UINavigationController+Background.m
//  GTIO
//
//  Created by Daniel Hammond on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UINavigationController+Background.h"

@implementation UINavigationBar (Background)

- (void)drawRect:(CGRect)rect  
{  
	UIImage *image = [UIImage imageNamed:@"navbar.png"];  
  
	[image drawInRect:rect];  
}  


@end
