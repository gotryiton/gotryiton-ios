//
//  GTIOPostALookViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOViewController.h"

typedef enum GTIOPostPhotoSection {
    GTIOPostPhotoSectionMain = 1,
    GTIOPostPhotoSectionTop,
    GTIOPostPhotoSectionBottom
} GTIOPostPhotoSection;

@interface GTIOPostALookViewController : GTIOViewController <UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) GTIOPostPhotoSection currentSection;

- (void)setOriginalImage:(UIImage *)originalImage filteredImage:(UIImage *)filteredImage filterName:(NSString *)filterName productID:(NSNumber *)productID;

- (void)reset;

@end
