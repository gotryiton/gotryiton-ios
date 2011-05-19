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
	UIScrollView* _scrollView;
	UISlider* _scrollSlider;
    UILabel* _myLooksLabel;
    UILabel* _facebookLabel;
    UIView* _seperator;
	BOOL _slidingState;
    NSArray* _options;
    int _currentSelection;
	GTIOUserIconOption* _facebookIconOption;
    TTImageView* _previewImageView;
    NSString* _profileName;
    NSString* _profileLocation;
}

- (id)initWithName:(NSString*)name location:(NSString*)location;

@end
