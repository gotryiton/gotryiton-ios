//
//  GTIOStyleSheet.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOStyleSheet.h"

// TODO: Don't love the location of this nor that they are C functions...
NSNumber* emailPickerChoiceAsNumber(TWTPickerControl* picker) {
	NSString* emailChoice = picker.textLabel.text;
	int choice = 0;
	if ([emailChoice isEqualToString:@"outfit alerts only"]) {
		choice = 2;
	} else if ([emailChoice isEqualToString:@"outfit alerts + site news"]) {
		choice = 1;
	} else if ([emailChoice isEqualToString:@"no emails"]) {
		choice = 0;
	}
	return [NSNumber numberWithInt:choice];
}

@interface TTBaseViewController (BarStyle)
@end

@implementation TTBaseViewController (BarStyle)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		_navigationBarStyle = UIBarStyleBlack;
		_statusBarStyle = UIStatusBarStyleBlackOpaque;
	}
	
	return self;
}

@end

@implementation GTIOStyleSheet

- (UIImage*)getStartedBackgroundImage {
	return [UIImage imageNamed:@"getstarted_bg.png"];
}

- (UIImage*)stepsBackgroundImage {
	return [UIImage imageNamed:@"upload-intro.png"];
}

- (UIImage*)modalBackgroundImage {
	return [UIImage imageNamed:@"full-wallpaper.png"];
}

- (UIImage*)rotateImage {
	return [UIImage imageNamed:@"rotate.png"];
}

- (UIImage*)zoomInImage {
	return [UIImage imageNamed:@"zoomin.png"];
}

- (UIImage*)zoomOutImage {
	return [UIImage imageNamed:@"zoomout.png"];
}

- (UIColor*)pinkColor {
	return RGBCOLOR(255,26,166);
}

- (UIColor*)greyTextColor {
	return RGBCOLOR(115,115,115);
}

- (UIFont*)gtioFont {
	UIFont* font = [UIFont fontWithName:@"Fette Engschrift" size:24];
	if (font == nil) {
		// If this font is not available or fails to load
		font = [UIFont boldSystemFontOfSize:24];
	}
	return font;
}

- (UIColor*)textColor {
	return [self greyTextColor];
}

- (UIImage*)giveAnOpinionTabBarImage {
	return [UIImage imageNamed:@"give.png"];
}

- (UIImage*)getAnOpinionTabBarImage {
	return [UIImage imageNamed:@"get.png"];
}

- (UIImage*)getAnOpinionTitleImage {
	return [UIImage imageNamed:@"get-an-opinion.png"];
}

- (UIImage*)getAnOpinionOverlayTitleImage {
	return [UIImage imageNamed:@"GET-header.png"];
}

- (UIImage*)getAnOpinionOverlayImage {
	return [UIImage imageNamed:@"overlay.png"];
}

- (UIImage*)profileTabBarImage {
	return [UIImage imageNamed:@"myprofile.png"];
}

- (UIImage*)settingsTabBarImage {
	return [UIImage imageNamed:@"settings_button.png"];
}

- (UIImage*)step1TitleImage {
	return [UIImage imageNamed:@"1-take-a-picture.png"];
}

- (UIImage*)tellUsAboutItTitleImage {
	return [UIImage imageNamed:@"2-tell-us-about-it.png"];
}

- (UIImage*)shareTitleImage {
	return [UIImage imageNamed:@"3-share.png"];
}

- (UIColor*)navigationBarTintColor {
	return RGBCOLOR(0,0,0);
}

- (UIColor*)toolbarTintColor {
	return [self navigationBarTintColor];
}

- (UIColor*)patternedPhotoBackgroundColor {
	return [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
}

- (UIImage*)blurButtonOffStateImage {
	return [UIImage imageNamed:@"blur-off.png"];
}

- (UIImage*)blurButtonOnStateImage {
	return [UIImage imageNamed:@"blur-on.png"];
}

- (UIImage*)newProfileHeaderImage {
	return [UIImage imageNamed:@"new-profile.png"];
}

- (UIImage*)editProfileHeaderImage {
	return [UIImage imageNamed:@"edit-profile.png"];
}

- (UIImage*)getStartedButtonImageNormal {
	return [UIImage imageNamed:@"upload-get-started-OFF.png"];
}

- (UIImage*)getStartedButtonImageHighlighted {
	return [UIImage imageNamed:@"upload-get-started-ON.png"];
}

- (UIFont*)tableHeaderPlainFont {
	return [UIFont boldSystemFontOfSize:12];
}

- (UIColor*)tableHeaderTextColor {
	return [UIColor blackColor];
}

- (UIFont*)tableFont {
	return [UIFont boldSystemFontOfSize:14];
}

- (UIImage*)facebookTableCellImage {
	return [UIImage imageNamed:@"facebook.png"];
}

- (UIImage*)twitterTableCellImage {
	return [UIImage imageNamed:@"twitter.png"];
}

- (UIImage*)createMyOutfitPageButtonImageNormal {
	return [UIImage imageNamed:@"upload-create-my-outfit-OFF.png"];
}

- (UIImage*)createMyOutfitPageButtonImageHighlighted {
	return [UIImage imageNamed:@"upload-create-my-outfit-ON.png"];
}

- (TTStyle*)greyText {
	return [TTTextStyle styleWithFont:self.tableFont color:self.greyTextColor textAlignment:UITextAlignmentCenter next:nil];
}

- (TTStyle*)addAdditionalEmails {
	return
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(40, 5, 6, 5) next:
	 [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:15] next:
	  [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:nil]]];
}

- (UIImage*)addAnotherOutfitButtonImageNormal {
	return [UIImage imageNamed:@"add-another-OFF.png"];
}

- (UIImage*)addAnotherOutfitButtonImageHighlighted {
	return [UIImage imageNamed:@"add-another-ON.png"];
}

- (UIImage*)doneWithPhotosButtonImageNormal {
	return [UIImage imageNamed:@"done-with-OFF.png"];
}

- (UIImage*)doneWithPhotosButtonImageHighlighted {
	return [UIImage imageNamed:@"done-with-ON.png"];
}

- (UIImage*)photoGuidelinesButtonImageNormal {
	return [UIImage imageNamed:@"guidelines-OK.png"];
}

- (UIImage*)photoGuidelinesButtonImageHighlighted {
	return [UIImage imageNamed:@"guidelines-OK-on.png"];
}

- (UIImage*)photoGuidelinesBackgroundImage {
	return [UIImage imageNamed:@"guidelines.png"];
}

- (UIImage*)photoGuidelinesHeaderImage {
	return [UIImage imageNamed:@"header.png"];
}

- (TTStyle*)pinkQuote {
	return [TTTextStyle styleWithFont:kGTIOFontHelveticaRBCOfSize(13) color:kGTIOColorBrightPink textAlignment:UITextAlignmentCenter next:nil];
}

- (TTStyle*)quoteStyle {
	TTTextStyle* style = [TTTextStyle styleWithFont:kGTIOFontHelveticaRBCOfSize(13) color:kGTIOColor9A9A9A textAlignment:UITextAlignmentCenter next:nil];
	style.minimumFontSize = 13;
	return style;
	
}

- (TTStyle*)whiteQuote {
	TTTextStyle* style = [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13] color:[UIColor whiteColor] textAlignment:UITextAlignmentCenter next:nil];
	return style;
}

- (TTStyle*)darkQuoteStyle {
	TTTextStyle* style = [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13] color:[UIColor darkGrayColor] textAlignment:UITextAlignmentCenter next:nil];
	style.minimumFontSize = 13;
	return style;
}

- (UIFont*)verdictLabelFont {
	return kGTIOFontHelveticaNeueOfSize(14.5);
}

- (TTStyle*)verdictLabelStyle {
	TTTextStyle* style = [TTTextStyle styleWithFont:kGTIOFontBoldHelveticaNeueOfSize(14) color:[UIColor whiteColor] next:nil];
	return style;
}

- (TTStyle*)verdictTextStyle {
	TTTextStyle* style = [TTTextStyle styleWithFont:[self verdictLabelFont] color:kGTIOColorED139A next:nil];
	return style;
}

- (UIFont*)reasonTextFont {
	return kGTIOFontHelveticaNeueOfSize(12);
}

- (TTStyle*)reasonTextStyle {
	TTTextStyle* style = [TTTextStyle styleWithFont:[self reasonTextFont] color:[UIColor whiteColor] next:nil];
	return style;
}

- (TTStyle*)reviewTextStyle {
    TTTextStyle* style = [TTTextStyle styleWithFont:kGTIOFontHelveticaRBCOfSize(15) color:kGTIOColor888888 next:nil];
	return style;
}

- (TTStyle*)linkText:(UIControlState)state {
    if (state == UIControlStateHighlighted) {
        return
            [TTTextStyle styleWithFont:kGTIOFontHelveticaRBCOfSize(15) color:kGTIOColor888888 next:nil];
    } else {
        return
        [TTTextStyle styleWithFont:kGTIOFontHelveticaRBCOfSize(15) color:kGTIOColorBrightPink next:nil];
    }
}

- (UIColor*)tableErrorTextColor {
    return RGBCOLOR(96,96,96);
}

- (UIFont*)errorTitleFont {
    return kGTIOFontHelveticaNeueOfSize(15);
}


- (UIFont*)errorSubtitleFont {
    return kGTIOFontHelveticaNeueOfSize(15);
}

- (TTStyle*)addAStylistTabStyle {
    UIColor* border = kGTIOColorBrightPink;
    return
    [TTSolidFillStyle styleWithColor:[UIColor clearColor] next:
     [TTFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:2 next:nil]];
}

- (TTStyle*)addAStylistTab:(UIControlState)state {
    TTShape* tabShape = [TTRoundedRectangleShape shapeWithTopLeft:4.5 topRight:4.5 bottomRight:0 bottomLeft:0];
    UIEdgeInsets tabInsets = UIEdgeInsetsMake(14, 2, 2, 2);
    UIEdgeInsets textInsets = UIEdgeInsetsMake(18, 2, 2, 2);
    UIColor* mediumGray = RGBCOLOR(220,220,220);
    UIColor* lightGray = RGBCOLOR(229,229,229);
    UIColor* darkGray = RGBCOLOR(122,122,122);
    UIFont* tabFont = kGTIOFetteFontOfSize(16);
    if (state == UIControlStateSelected) {
        return [TTShapeStyle styleWithShape:tabShape next:
                [TTInsetStyle styleWithInset:tabInsets next:
                 [TTSolidFillStyle styleWithColor:kGTIOColorBrightPink next:
                  [TTBoxStyle styleWithPadding:textInsets next:
                   [TTTextStyle styleWithFont:tabFont color:[UIColor whiteColor]
                                textAlignment:UITextAlignmentCenter next:nil]]]]];
    } else {
        return [TTShapeStyle styleWithShape:tabShape next:
                [TTInsetStyle styleWithInset:tabInsets next:
                 [TTSolidFillStyle styleWithColor:lightGray next:
                   [TTFourBorderStyle styleWithTop:mediumGray right:mediumGray bottom:nil left:mediumGray width:1 next:
                    [TTBoxStyle styleWithPadding:textInsets next:
                     [TTTextStyle styleWithFont:tabFont color:darkGray
                                 textAlignment:UITextAlignmentCenter next:nil]]]]]];
    }
}

@end
