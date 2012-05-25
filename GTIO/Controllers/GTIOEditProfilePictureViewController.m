//
//  GTIOEditProfilePictureViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOEditProfilePictureViewController.h"
#import "GTIORoundedView.h"
#import "GTIOSelectableProfilePicture.h"
#import "GTIOUser.h"
#import "GTIOProfileDataSource.h"
#import "GTIOIcon.h"
#import "GTIOFacebookIcon.h"
#import "GTIOProgressHUD.h"
#import "GTIOAlmostDoneViewController.h"

@interface GTIOEditProfilePictureViewController ()
{
    @private
    GTIOSelectableProfilePicture *previewIcon;
    GTIOSelectableProfilePicture *facebookPicture;
    UILabel *previewNameLabel;
    UILabel *previewUserLocationLabel;
    NSMutableArray *profileIconViews;
    NSMutableArray *profileIconURLs;
    NSString *currentlySelectedProfileIconURL;
}

@end

@implementation GTIOEditProfilePictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        profileIconViews = [NSMutableArray array];
        profileIconURLs = [NSMutableArray array];
        currentlySelectedProfileIconURL = [NSString string];
    }
    return self;
}

- (void)loadView
{
    [self refreshContent];
}

- (void)refreshContent {
    GTIOUser *currentUser = [GTIOUser currentUser];
    currentlySelectedProfileIconURL = [currentUser.icon absoluteString];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"green-pattern-nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    GTIOButton *saveButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeSaveGrayTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *fieldsToUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                            currentlySelectedProfileIconURL, @"icon",
                                        nil];
        NSDictionary *trackingInformation = [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"edit_profile", @"id",
                                                @"edit_profile_icon", @"screen",
                                             nil];
        [currentUser updateCurrentUserWithFields:fieldsToUpdate withTrackingInformation:trackingInformation andLoginHandler:^(GTIOUser *user, NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                [[GTIOUser currentUser] setIcon:[NSURL URLWithString:currentlySelectedProfileIconURL]];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"We were not able to update your profile picture." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }];
    
    GTIOButton *doneButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeDoneGrayTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES]; 
    }];
    
    [self.navigationItem setHidesBackButton:YES];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleView setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:18.0]];
    [titleView setText:@"edit profile picture"];
    [titleView sizeToFit];
    [titleView setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:titleView];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:saveButton]];
    
    UIView *topShadow = [[UIView alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width,3}];
    [topShadow setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top-shadow.png"]]];
    [self.view addSubview:topShadow];
    
    GTIORoundedView *chooseFromBox = [[GTIORoundedView alloc] initWithFrame:(CGRect){10,10,300,185}];
    [chooseFromBox setTitle:@"choose from"];
    [self.view addSubview:chooseFromBox];
    
    UIImageView *facebookLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook-logo.png"]];
    [facebookLogo setFrame:(CGRect){21,52.5,facebookLogo.bounds.size}];
    [chooseFromBox addSubview:facebookLogo];
    
    UILabel *myLooksLabel = [[UILabel alloc] initWithFrame:(CGRect){90,53,100,11}];
    [myLooksLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:11.0]];
    [myLooksLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
    [myLooksLabel setText:@"my looks"];
    [chooseFromBox addSubview:myLooksLabel];
    
    UIScrollView *myLooksIcons = [[UIScrollView alloc] initWithFrame:(CGRect){90,72,195,70}];
    [myLooksIcons setShowsVerticalScrollIndicator:NO];
    [chooseFromBox addSubview:myLooksIcons];
    
    UILabel *loadingIconsLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,50,10}];
    [loadingIconsLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:10.0]];
    [loadingIconsLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
    [loadingIconsLabel setText:@"Loading..."];
    [myLooksIcons addSubview:loadingIconsLabel];
    [[GTIOProfileDataSource sharedDataSource] loadUserIconsWithUserID:currentUser.userID andCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
        [loadingIconsLabel removeFromSuperview];
        if (!error) {
            BOOL userHasFacebookPicture = NO;
            
            // find the facebook icon first
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOFacebookIcon class]]) {
                    GTIOIcon *facebookIcon = (GTIOIcon*)object;
                    [profileIconURLs addObject:facebookIcon.url];
                    userHasFacebookPicture = YES;
                }
            }
            // grab the rest of the icons
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOIcon class]] && ![object isMemberOfClass:[GTIOFacebookIcon class]]) {
                    GTIOIcon *icon = (GTIOIcon*)object;
                    [profileIconURLs addObject:icon.url];
                }
            }
            
            facebookPicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){16,72,55,55} andImageURL:nil];
            if (userHasFacebookPicture) {
                NSString* facebookPictureURL = [profileIconURLs objectAtIndex:0];
                [facebookPicture setImageWithURL:facebookPictureURL];
                [profileIconViews addObject:facebookPicture];
                [profileIconURLs removeObject:facebookPictureURL];
                [facebookPicture setDelegate:self];
            } else {
                [facebookPicture setImage:[UIImage imageNamed:@"default-facebook-profile-picture.png"]];
                [facebookPicture setIsSelectable:NO];
                
                UIButton *facebookConnectButton = [[UIButton alloc] initWithFrame:(CGRect){16,137,55,21}];
                [facebookConnectButton setImage:[UIImage imageNamed:@"facebook-connect-button"] forState:UIControlStateNormal];
                [facebookConnectButton addTarget:self action:@selector(connectToFacebook:) forControlEvents:UIControlEventTouchUpInside];
                [chooseFromBox addSubview:facebookConnectButton];
            }
            [chooseFromBox addSubview:facebookPicture];
            
            double iconXPos = 0.0;
            double iconSpacing = 3.0;
            int numberOfIcons = [profileIconURLs count];
            for (int i = 0; i < numberOfIcons; i++) {
                GTIOSelectableProfilePicture *icon = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){iconXPos,0,55,55} andImageURL:[profileIconURLs objectAtIndex:i]];
                [icon setDelegate:self];
                [profileIconViews addObject:icon];
                [myLooksIcons addSubview:icon];
                iconXPos += 55 + ((i == (numberOfIcons - 1)) ? 0 : iconSpacing);
            }
            [myLooksIcons setContentSize:(CGSize){numberOfIcons * (55 + iconSpacing),70}];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"We were not able to load your looks." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    GTIORoundedView *previewBox = [[GTIORoundedView alloc] initWithFrame:(CGRect){10,205,300,202}];
    [previewBox setTitle:@"preview"];
    [self.view addSubview:previewBox];
    
    UIImageView *previewBoxBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview-box-bg.png"]];
    [previewBoxBackground setFrame:(CGRect){17,55,previewBoxBackground.bounds.size}];
    [previewBox addSubview:previewBoxBackground];
    
    previewIcon = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){12,13,55,55} andImageURL:nil];
    if ([[currentUser.icon absoluteString] length] > 0) {
        [previewIcon setImageWithURL:[currentUser.icon absoluteString]];
    } else {
        [previewIcon setImage:[UIImage imageNamed:@"no-profile-picture.png"]];
    }
    [previewBoxBackground addSubview:previewIcon];
    
    previewNameLabel = [[UILabel alloc] initWithFrame:(CGRect){80,24,174,21}];
    [previewNameLabel setBackgroundColor:[UIColor clearColor]];
    [previewNameLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMedium size:18.0]];
    [previewNameLabel setTextColor:[UIColor gtio_pinkTextColor]];
    [previewNameLabel setText:currentUser.name];
    [previewBoxBackground addSubview:previewNameLabel];
    
    previewUserLocationLabel = [[UILabel alloc] initWithFrame:(CGRect){80,45,174,14}];
    [previewUserLocationLabel setBackgroundColor:[UIColor clearColor]];
    [previewUserLocationLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [previewUserLocationLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
    [previewUserLocationLabel setText:[NSString stringWithFormat:@"%@%@%@",currentUser.city,([currentUser.state length] > 0)?@", ":@"",currentUser.state]];
    [previewBoxBackground addSubview:previewUserLocationLabel];
    
    UIButton *clearProfilePictureButton = [[UIButton alloc] initWithFrame:(CGRect){17,151,118,24}];
    [clearProfilePictureButton setImage:[UIImage imageNamed:@"clear-profile-picture-button.png"] forState:UIControlStateNormal];
    [clearProfilePictureButton addTarget:self action:@selector(clearProfilePicture:) forControlEvents:UIControlEventTouchUpInside];
    [previewBox addSubview:clearProfilePictureButton];
}

- (void)connectToFacebook:(id)sender
{
    [[GTIOUser currentUser] connectToFacebookWithLoginHandler:^(GTIOUser *user, NSError *error) {
        if (!error) {
            [self refreshContent];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"We were not able to connect your account to facebook." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)clearProfilePicture:(id)sender
{
    [previewIcon setImage:[UIImage imageNamed:@"no-profile-picture.png"]];
    currentlySelectedProfileIconURL = @"";
    [self clearSelectedProfilePictures];
}

- (void)pictureWasTapped:(id)picture
{
    // clear all selectable profile pictures before selecting this one
    [self clearSelectedProfilePictures];
    GTIOSelectableProfilePicture *tappedPicture = (GTIOSelectableProfilePicture*)picture;
    [previewIcon setImageWithURL:tappedPicture.imageURL];
    currentlySelectedProfileIconURL = tappedPicture.imageURL;
}

- (void)clearSelectedProfilePictures
{
    for (GTIOSelectableProfilePicture *picture in profileIconViews) {
        [picture setIsSelected:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
