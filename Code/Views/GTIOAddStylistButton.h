//
//  GTIOAddStylistButton.h
//  GTIO
//
//  Created by Duncan Lewis on 11/21/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOProfile.h"

@interface GTIOAddStylistButton : UIButton {
    BOOL _selected;
    UIImage* _checkBoxImage;
    UIImageView* _checkboxView;
}

- (id)initWithTitle:(NSString*)title subtitle:(NSString *)subtitle imageURL:(NSString*)imageURL;

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,retain) UIImageView* checkboxView;
@property (nonatomic,retain) GTIOProfile* profile;

@end
