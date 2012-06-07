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
#import "GTIOIcon.h"
#import "GTIOFacebookIcon.h"
#import "GTIODefaultIcon.h"
#import "GTIOProgressHUD.h"
#import "GTIOAlmostDoneViewController.h"

@interface GTIOEditProfilePictureViewController ()

@property (nonatomic, strong) GTIOSelectableProfilePicture *previewIcon;
@property (nonatomic, strong) GTIOSelectableProfilePicture *facebookPicture;
@property (nonatomic, strong) UILabel *previewNameLabel;
@property (nonatomic, strong) UILabel *previewUserLocationLabel;
@property (nonatomic, strong) NSMutableArray *profileIconViews;
@property (nonatomic, strong) NSMutableArray *profileIconURLs;
@property (nonatomic, strong) NSURL *currentlySelectedProfileIconURL;
@property (nonatomic, strong) UILabel *loadingIconsLabel;
@property (nonatomic, strong) GTIORoundedView *chooseFromBox;
@property (nonatomic, strong) UILabel *myLooksLabel;
@property (nonatomic, strong) UIScrollView *myLooksIcons;
@property (nonatomic, strong) GTIORoundedView *previewBox;
@property (nonatomic, strong) UIImageView *previewBoxBackground;
@property (nonatomic, strong) UIButton *clearProfilePictureButton;
@property (nonatomic, strong) UIImageView *facebookLogo;
@property (nonatomic, strong) NSURL *defaultIconURL;

@end

@implementation GTIOEditProfilePictureViewController

@synthesize previewIcon = _previewIcon, facebookPicture = _facebookPicture, previewNameLabel = _previewNameLabel, previewUserLocationLabel = _previewUserLocationLabel, profileIconURLs = _profileIconURLs, profileIconViews = _profileIconViews, currentlySelectedProfileIconURL = _currentlySelectedProfileIconURL, loadingIconsLabel = _loadingIconsLabel, chooseFromBox = _chooseFromBox, myLooksLabel = _myLooksLabel, myLooksIcons = _myLooksIcons, previewBox = _previewBox, previewBoxBackground = _previewBoxBackground, clearProfilePictureButton = _clearProfilePictureButton, facebookLogo = _facebookLogo, defaultIconURL = _defaultIconURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    GTIOButton *saveButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeSaveGrayTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *fieldsToUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                        (self.currentlySelectedProfileIconURL) ? [self.currentlySelectedProfileIconURL absoluteString] : @"", @"icon",
                                        nil];
        NSDictionary *trackingInformation = [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"edit_profile", @"id",
                                             @"edit_profile_icon", @"screen",
                                             nil];
        [[GTIOUser currentUser] updateCurrentUserWithFields:fieldsToUpdate withTrackingInformation:trackingInformation andLoginHandler:^(GTIOUser *user, NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                [[GTIOUser currentUser] setIcon:[NSURL URLWithString:[user.icon absoluteString]]];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"We were not able to update your profile picture." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }];
    
    GTIOButton *doneButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeCancelGrayTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES]; 
    }];
    
    self = [super initWithTitle:@"edit profile picture" italic:YES leftNavBarButton:doneButton rightNavBarButton:saveButton];
    if (self) {        
        _profileIconViews = [NSMutableArray array];
        _profileIconURLs = [NSMutableArray array];
        _currentlySelectedProfileIconURL = [NSString string];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GTIOUser *currentUser = [GTIOUser currentUser];
    self.currentlySelectedProfileIconURL = currentUser.icon;
    
    self.chooseFromBox = [[GTIORoundedView alloc] initWithFrame:(CGRect){ 10, 10, 300, 185 }];
    [self.chooseFromBox setTitle:@"choose from"];
    [self.view addSubview:self.chooseFromBox];
    
    self.facebookLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook-logo.png"]];
    [self.facebookLogo setFrame:(CGRect){ { 21, 52.5 }, self.facebookLogo.bounds.size }];
    [self.chooseFromBox addSubview:self.facebookLogo];
    
    self.myLooksLabel = [[UILabel alloc] initWithFrame:(CGRect){ 90, 53, 100, 11}];
    [self.myLooksLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:11.0]];
    [self.myLooksLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
    [self.myLooksLabel setText:@"my looks"];
    [self.chooseFromBox addSubview:self.myLooksLabel];
    
    self.myLooksIcons = [[UIScrollView alloc] initWithFrame:(CGRect){ 88, 70, 199, 74 }];
    [self.myLooksIcons setShowsVerticalScrollIndicator:NO];
    [self.chooseFromBox addSubview:self.myLooksIcons];
    
    self.loadingIconsLabel = [[UILabel alloc] initWithFrame:(CGRect){ 0, 0, 50, 10 }];
    [self.loadingIconsLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:10.0]];
    [self.loadingIconsLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
    [self.loadingIconsLabel setText:@"Loading..."];
    [self.myLooksIcons addSubview:self.loadingIconsLabel];
    
    self.previewBox = [[GTIORoundedView alloc] initWithFrame:(CGRect){ 10, 205, 300, 202 }];
    [self.previewBox setTitle:@"preview"];
    [self.view addSubview:self.previewBox];
    
    self.previewBoxBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview-box-bg.png"]];
    [self.previewBoxBackground setFrame:(CGRect){ { 17, 55 }, self.previewBoxBackground.bounds.size }];
    [self.previewBox addSubview:self.previewBoxBackground];
    
    self.previewIcon = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 12, 13, 55, 55 } andImageURL:nil];
    [self.previewBoxBackground addSubview:self.previewIcon];
    
    self.previewNameLabel = [[UILabel alloc] initWithFrame:(CGRect){ 80, 24, 174, 21 }];
    [self.previewNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.previewNameLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:18.0]];
    [self.previewNameLabel setTextColor:[UIColor gtio_pinkTextColor]];
    [self.previewBoxBackground addSubview:self.previewNameLabel];
    
    self.previewUserLocationLabel = [[UILabel alloc] initWithFrame:(CGRect){ 80, 45, 174, 14 }];
    [self.previewUserLocationLabel setBackgroundColor:[UIColor clearColor]];
    [self.previewUserLocationLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [self.previewUserLocationLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
    [self.previewBoxBackground addSubview:self.previewUserLocationLabel];
    
    self.clearProfilePictureButton = [[UIButton alloc] initWithFrame:(CGRect){ 17, 151, 118, 24 }];
    [self.clearProfilePictureButton setImage:[UIImage imageNamed:@"clear-profile-picture-button.png"] forState:UIControlStateNormal];
    [self.clearProfilePictureButton addTarget:self action:@selector(clearProfilePicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.previewBox addSubview:self.clearProfilePictureButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.facebookLogo = nil;
    self.myLooksIcons = nil;
    self.myLooksLabel = nil;
    self.loadingIconsLabel = nil;
    self.previewBox = nil;
    self.previewBoxBackground = nil;
    self.previewIcon = nil;
    self.previewNameLabel = nil;
    self.previewUserLocationLabel = nil;
    self.clearProfilePictureButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshContent];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

- (void)refreshContent
{        
    GTIOUser *currentUser = [GTIOUser currentUser];
    self.currentlySelectedProfileIconURL = currentUser.icon;
    
    [[GTIOUser currentUser] loadUserIconsWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
        [self.loadingIconsLabel removeFromSuperview];
        if (!error) {
            BOOL userHasFacebookPicture = NO;
            
            // find the default icon
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIODefaultIcon class]]) {
                    GTIOIcon *defaultIcon = (GTIOIcon*)object;
                    self.defaultIconURL = defaultIcon.url;
                }
            }
            
            // find the facebook icon
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOFacebookIcon class]]) {
                    GTIOIcon *facebookIcon = (GTIOIcon*)object;
                    [self.profileIconURLs addObject:facebookIcon.url];
                    userHasFacebookPicture = YES;
                }
            }
            
            // grab the rest of the icons
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOIcon class]] && ![object isMemberOfClass:[GTIOFacebookIcon class]]) {
                    GTIOIcon *icon = (GTIOIcon*)object;
                    [self.profileIconURLs addObject:icon.url];
                }
            }
            
            // default icon
            self.defaultIconURL = [NSURL URLWithString:[loadedObjects objectAtIndex:([loadedObjects count]-1)]];
            
            self.facebookPicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 16, 72, 55, 55 } andImageURL:nil];
            if (userHasFacebookPicture) {
                NSURL* facebookPictureURL = (NSURL*)[self.profileIconURLs objectAtIndex:0];
                [self.facebookPicture setImageWithURL:facebookPictureURL];
                [self.profileIconViews addObject:self.facebookPicture];
                [self.profileIconURLs removeObject:facebookPictureURL];
                [self.facebookPicture setDelegate:self];
            } else {
                [self.facebookPicture setImage:[UIImage imageNamed:@"default-facebook-profile-picture.png"]];
                [self.facebookPicture setIsSelectable:NO];
                
                UIButton *facebookConnectButton = [[UIButton alloc] initWithFrame:(CGRect){ 16, 137, 55, 21 }];
                [facebookConnectButton setImage:[UIImage imageNamed:@"facebook-connect-button"] forState:UIControlStateNormal];
                [facebookConnectButton addTarget:self action:@selector(connectToFacebook:) forControlEvents:UIControlEventTouchUpInside];
                [self.chooseFromBox addSubview:facebookConnectButton];
            }
            [self.chooseFromBox addSubview:self.facebookPicture];
            
            double iconXPos = 2.0;
            double iconSpacing = 5.0;
            int numberOfIcons = [self.profileIconURLs count];
            for (int i = 0; i < numberOfIcons; i++) {
                GTIOSelectableProfilePicture *icon = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){iconXPos,2,55,55} andImageURL:(NSURL*)[self.profileIconURLs objectAtIndex:i]];
                [icon setDelegate:self];
                [self.profileIconViews addObject:icon];
                [self.myLooksIcons addSubview:icon];
                iconXPos += 55 + ((i == (numberOfIcons - 1)) ? 2.0 : iconSpacing);
            }
            [self.myLooksIcons setContentSize:(CGSize){ numberOfIcons * (55 + iconSpacing), 70 }];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"We were not able to load your looks." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
    

    if ([[currentUser.icon absoluteString] length] > 0) {
        [self.previewIcon setImageWithURL:currentUser.icon];
    } else {
        [self.previewIcon setImage:[UIImage imageNamed:@"no-profile-picture.png"]];
    }
    
    [self.previewNameLabel setText:currentUser.name];
    [self.previewUserLocationLabel setText:[NSString stringWithFormat:@"%@%@%@", currentUser.city, ([currentUser.state length] > 0) ? @", " : @"", currentUser.state]];
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
    [self.previewIcon setImageWithURL:self.defaultIconURL];
    self.currentlySelectedProfileIconURL = nil;
    [self clearSelectedProfilePictures];
}

- (void)pictureWasTapped:(id)picture
{
    // clear all selectable profile pictures before selecting this one
    [self clearSelectedProfilePictures];
    GTIOSelectableProfilePicture *tappedPicture = (GTIOSelectableProfilePicture*)picture;
    [self.previewIcon setImageWithURL:tappedPicture.imageURL];
    self.currentlySelectedProfileIconURL = tappedPicture.imageURL;
}

- (void)clearSelectedProfilePictures
{
    for (GTIOSelectableProfilePicture *picture in self.profileIconViews) {
        [picture setIsSelected:NO];
    }
}

@end
