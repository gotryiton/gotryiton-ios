//
//  GTIOEditProfilePictureViewController.h
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOUserIconOption.h"

@interface GTIOEditProfilePictureViewController : UIViewController <RKObjectLoaderDelegate, UIScrollViewDelegate> {
    // subviews
    UIView* _seperator;
	UIScrollView* _scrollView;
	UISlider* _scrollSlider;
    UILabel* _myLooksLabel;
    UILabel* _facebookLabel;
    TTImageView* _previewImageView;
    // ivars
    BOOL _slidingState;
    int _currentSelection;
    NSString* _profileName;
    NSString* _profileLocation;
    NSArray* _options;
	GTIOUserIconOption* _facebookIconOption;
}

- (id)initWithName:(NSString*)name location:(NSString*)location;

@end
