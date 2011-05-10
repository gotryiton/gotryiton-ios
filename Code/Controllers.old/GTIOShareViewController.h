//
//  GTIOShareViewController.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/3/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTableViewController.h"
#import "GTIOOpinionRequest.h"
#import "CustomUISwitch.h"

@interface GTIOShareViewController : GTIOTableViewController {
	GTIOOpinionRequest* _opinionRequest;
	UIButton* _createMyOutfitPageButton;
	CustomUISwitch* _shareSwitch;
	CustomUISwitch* _facebookSwitch;
	CustomUISwitch* _twitterSwitch;
	CustomUISwitch* _alertMeWithFeedbackSwitch;
	CustomUISwitch* _keepThisLookPrivateSwitch;
	
	UILabel* _privateLabel;
}

@property (nonatomic, retain) GTIOOpinionRequest* opinionRequest;

@end
