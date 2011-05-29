//
//  GTIOEditProfilePictureViewController.h
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOEditProfilePictureViewController is a view controller that allows the current user to edit their profile picture selection

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
    NSArray* _imageViews; 
	GTIOUserIconOption* _facebookIconOption;
}
/// Initializes a new view controller with a given user name and location
- (id)initWithName:(NSString*)name location:(NSString*)location;

@end
