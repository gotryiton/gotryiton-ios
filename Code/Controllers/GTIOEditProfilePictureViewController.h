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
	BOOL _slidingState;
	GTIOUserIconOption* _facebookIconOption;
}

@end
