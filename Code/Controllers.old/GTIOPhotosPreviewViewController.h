//
//  GTIOPhotosPreviewViewController.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOPhotosPreviewViewController is a TTViewController that previews the photos a user has included in their [GTIOOpinionRequest](GTIOOpinionRequest)

#import "GTIOTableViewController.h"
#import "GTIOOpinionRequest.h"

@interface GTIOPhotosPreviewViewController : TTViewController <UIActionSheetDelegate> {
	GTIOOpinionRequest* _opinionRequest;	
	UIButton* _addAnotherOutfitButton;
	UIButton* _doneWithPhotosButton;
	NSMutableArray* _photoPreviews;
}

/// request object
@property (nonatomic, readonly) GTIOOpinionRequest* opinionRequest;

@end
