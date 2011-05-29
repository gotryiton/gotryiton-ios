//
//  GTIOTakeAPictureViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOTakeAPictureViewController is a TTViewController that handles taking a photo for a [GTIOOpinionRequest](GTIOOpinionRequest)

#import <Three20/Three20.h>
#import <Three20/Three20+Additions.h>
#import "GTIOPhoto.h"
#import "GTIOBlurrableImageView.h"

@interface GTIOTakeAPictureViewController : TTViewController <UIScrollViewDelegate, UIActionSheetDelegate, GTIOBlurrableImageViewDelegate> {
	GTIOPhoto* _photo;
	UIScrollView* _scrollView;
	GTIOBlurrableImageView* _blurrableImageView;
	UIView* imageBorder;
	UIButton* _blurButton;
	UIToolbar* _toolbar;	
	
	BOOL _useDoneButton;
	BOOL _useCancelButton;
	CGPoint _offsetPoint;
}

/**
 * The photo currently being edited
 */
@property (nonatomic, readonly) GTIOPhoto* photo;

/**
 * Returns YES when we are using the done button instead of cancel/next
 */
@property (nonatomic, readonly) BOOL useDoneButton;

@property (nonatomic, readonly) BOOL useCancelButton;

@end
