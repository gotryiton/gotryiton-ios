//
//  GTIOStyleSheet.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Three20/Three20.h>
#import <TWTPickerControl.h>
#import "GTIOUser.h"

NSNumber* emailPickerChoiceAsNumber(TWTPickerControl* picker);
TWTPickerControl* emailPickerForUser(GTIOUser* user);

#undef TTSTYLESHEET
#define TTSTYLESHEET ((GTIOStyleSheet*)[TTStyleSheet globalStyleSheet])

@interface GTIOStyleSheet : TTDefaultStyleSheet {

}

@property (nonatomic, readonly) UIImage* getStartedBackgroundImage;
@property (nonatomic, readonly) UIImage* stepsBackgroundImage;
@property (nonatomic, readonly) UIColor* pinkColor;
@property (nonatomic, readonly) UIColor* greyTextColor;
@property (nonatomic, readonly) UIFont* gtioFont;
@property (nonatomic, readonly) UIImage* getAnOpinionTitleImage;
@property (nonatomic, readonly) UIImage* getAnOpinionOverlayImage;
@property (nonatomic, readonly) UIImage* getAnOpinionOverlayTitleImage;
@property (nonatomic, readonly) UIImage* getAnOpinionTabBarImage;
@property (nonatomic, readonly) UIImage* giveAnOpinionTabBarImage;
@property (nonatomic, readonly) UIImage* profileTabBarImage;
@property (nonatomic, readonly) UIImage* settingsTabBarImage;
@property (nonatomic, readonly) UIImage* step1TitleImage;
@property (nonatomic, readonly) UIImage* modalBackgroundImage;
@property (nonatomic, readonly) UIImage* rotateImage;
@property (nonatomic, readonly) UIImage* zoomInImage;
@property (nonatomic, readonly) UIImage* zoomOutImage;
@property (nonatomic, readonly) UIColor* patternedPhotoBackgroundColor;
@property (nonatomic, readonly) UIImage* blurButtonOffStateImage;
@property (nonatomic, readonly) UIImage* blurButtonOnStateImage;
@property (nonatomic, readonly) UIImage* newProfileHeaderImage;
@property (nonatomic, readonly) UIImage* editProfileHeaderImage;
@property (nonatomic, readonly) UIImage* getStartedButtonImageNormal;
@property (nonatomic, readonly) UIImage* getStartedButtonImageHighlighted;
@property (nonatomic, readonly) UIImage* tellUsAboutItTitleImage;
@property (nonatomic, readonly) UIImage* shareTitleImage;
@property (nonatomic, readonly) UIImage* facebookTableCellImage;
@property (nonatomic, readonly) UIImage* twitterTableCellImage;
@property (nonatomic, readonly) UIImage* createMyOutfitPageButtonImageNormal;
@property (nonatomic, readonly) UIImage* createMyOutfitPageButtonImageHighlighted;

@property (nonatomic, readonly) UIImage* addAnotherOutfitButtonImageNormal;
@property (nonatomic, readonly) UIImage* addAnotherOutfitButtonImageHighlighted;
@property (nonatomic, readonly) UIImage* doneWithPhotosButtonImageNormal;
@property (nonatomic, readonly) UIImage* doneWithPhotosButtonImageHighlighted;

@property (nonatomic, readonly) UIImage* photoGuidelinesButtonImageNormal;
@property (nonatomic, readonly) UIImage* photoGuidelinesButtonImageHighlighted;
@property (nonatomic, readonly) UIImage* photoGuidelinesBackgroundImage;
@property (nonatomic, readonly) UIImage* photoGuidelinesHeaderImage;

- (UIFont*)verdictLabelFont;
- (UIFont*)reasonTextFont;

@end
