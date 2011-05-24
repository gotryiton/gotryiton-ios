//
//  GTIOWelcomeViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GTIOWelcomeViewController : TTModelViewController {
    IBOutlet UIButton* _welcomeButton;
    IBOutlet UIView* _outfitImagesView;
    IBOutlet UIActivityIndicatorView* _spinner;
}

@end
