//
//  GTIOWelcomeViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOWelcomeViewController is the first view controller seen by user's not logged in, it displays a login button and an array of outfit images

@interface GTIOWelcomeViewController : TTModelViewController {
    IBOutlet UIButton* _welcomeButton;
    IBOutlet UIView* _outfitImagesView;
    IBOutlet UIActivityIndicatorView* _spinner;
}

@end
