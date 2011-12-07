//
//  GTIOProfileCreatedAddStylistsViewController.h
//  GTIO
//
//  Created by Duncan Lewis on 11/10/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "TTTAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import <AddressBook/AddressBook.h>
#import "GTIOViewController.h"
#import "NSObject_Additions.h"
#import "GTIOBrowseList.h"
#import "GTIOProfile.h"
#import "GTIOLoadingOverlayManager.h"
#import "GTIOAnalyticsTracker.h"
#import "GTIOBarButtonItem.h"
#import "GTIOAddStylistButton.h"

@interface GTIOProfileCreatedAddStylistsViewController : GTIOViewController<RKObjectLoaderDelegate, TTTAttributedLabelDelegate> {

    GTIOBrowseList* _stylists;
    
    NSMutableArray* _stylistsToAdd;
    
    UIScrollView* _scrollView;
    UIImageView* _addStylistContainer;
    UILabel* _addStylistsLabel;
    UILabel* _connectWithStylistsLabel;
    UIButton* _doneButton;
    
    TTActivityLabel* _loadingStylistsLabel;
    
    TTImageView* _profileThumbnailView;
    UILabel* _userNameLabel;
    UILabel* _userLocationLabel;
}

@end
