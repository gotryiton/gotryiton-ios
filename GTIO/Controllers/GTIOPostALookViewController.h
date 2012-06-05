//
//  GTIOPostALookViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOViewController.h"

@interface GTIOPostALookViewController : GTIOViewController <UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *mainImage;
@property (nonatomic, strong) UIImage *secondImage;
@property (nonatomic, strong) UIImage *thirdImage;

@end
