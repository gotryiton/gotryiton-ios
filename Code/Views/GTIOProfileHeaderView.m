//
//  GTIOProfileHeaderView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/12/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOProfileHeaderView.h"
#import "GTIOUser.h"
#import "NSObject_Additions.h"
#import "TWTActionSheetDelegate.h"

@implementation GTIOProfileHeaderView

@synthesize nameLabel = _nameLabel;
@synthesize locationLabel = _locationLabel;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    _shouldAllowEditing = NO;
    
	UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dark-top.png"]];
	[self addSubview:background];
	[background release];
	
    _profilePictureImageView = [TTImageView new];
    [(UIImageView*)_profilePictureImageView setImage:[UIImage imageNamed:@"empty-profile-pic.png"]];
	_profilePictureImageView.layer.cornerRadius = 5.0;
	[_profilePictureImageView setFrame:CGRectMake(10,8,54,54)];
	[self addSubview:_profilePictureImageView];
	
	UIButton* profilePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[profilePictureButton setBackgroundColor:[UIColor clearColor]];
	[profilePictureButton setFrame:_profilePictureImageView.frame];
	[profilePictureButton addTarget:self action:@selector(profilePictureButtonAction) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:profilePictureButton];
		
	UIImageView* profilePictureFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-icon-overlay-110.png"]];
	[profilePictureFrame setFrame:CGRectMake(5,3,64,64)];
	[self addSubview:profilePictureFrame];
	
	_fashionProfileBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fash-badge-profile.png"]];
	[_fashionProfileBadge setFrame:CGRectMake(0,2.5,48,48)];
	[self addSubview:_fashionProfileBadge];
	[_fashionProfileBadge setHidden:YES];

	_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 250, 40)];
	_nameLabel.backgroundColor = [UIColor clearColor];
	_nameLabel.font = kGTIOFetteFontOfSize(36);
	_nameLabel.textColor = [UIColor whiteColor];
	[self addSubview:_nameLabel];
	
	_locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 43, 250, 20)];
	_locationLabel.backgroundColor = [UIColor clearColor];
	_locationLabel.font = [UIFont systemFontOfSize:15];
	_locationLabel.textColor = kGTIOColorB2B2B2;
	[self addSubview:_locationLabel];
	
	_editProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_editProfileButton addTarget:self action:@selector(editButtonHighlight) forControlEvents:UIControlEventTouchDown];
	[_editProfileButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_editProfileButton];
    
    _connectionImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(280,10,24,23)] autorelease];
    [self addSubview:_connectionImageView];
    
	// Accessibility Label
    [_nameLabel setAccessibilityLabel:@"name label"];
    [_locationLabel setAccessibilityLabel:@"location label"];
    [_editProfileButton setAccessibilityLabel:@"edit profile button"];
    [_profilePictureImageView setAccessibilityLabel:@"profile picture view"];
    [profilePictureButton setAccessibilityLabel:@"edit profile picture"];
	return self;
}

- (void)dealloc {
    [_profile release];
	[super dealloc];
}

- (void)displayProfile:(GTIOProfile*)profile {
    [profile retain];
    [_profile release];
    _profile = profile;
    
    if ([profile.uid isEqualToString:[GTIOUser currentUser].UID] && [[GTIOUser currentUser] isLoggedIn]) {
        [_connectionImageView setHidden:YES];
        _shouldAllowEditing = YES;
        [_editProfileButton setImage:[UIImage imageNamed:@"edit-OFF.png"] forState:UIControlStateNormal];
        [_editProfileButton setImage:[UIImage imageNamed:@"edit-ON.png"] forState:UIControlStateHighlighted];
        [_editProfileButton setFrame:CGRectMake(320-35-7.5,70-20-5,35,20)];
    } else {
        _shouldAllowEditing = NO;
        [_connectionImageView setHidden:NO];
        GTIOStylistRelationship* relationship = profile.stylistRelationship;
        UIImage* image = [relationship imageForProfileConnection];
        _connectionImageView.image = image;
        if (relationship.iStyle) {
            // edit
            [_editProfileButton setImage:[UIImage imageNamed:@"edit-OFF.png"] forState:UIControlStateNormal];
            [_editProfileButton setImage:[UIImage imageNamed:@"edit-ON.png"] forState:UIControlStateHighlighted];
            [_editProfileButton setFrame:CGRectMake(320-35-7.5,70-20-5,34,20)];
        } else if (relationship.isMyStylist && !relationship.isMyStylistIgnored) {
            // Remove
            [_editProfileButton setImage:[UIImage imageNamed:@"remove-OFF.png"] forState:UIControlStateNormal];
            [_editProfileButton setImage:[UIImage imageNamed:@"remove-ON.png"] forState:UIControlStateHighlighted];
            [_editProfileButton setFrame:CGRectMake(320-35-7.5,70-20-5-10,55,30)];
        } else {
            // add
            [_editProfileButton setImage:[UIImage imageNamed:@"add-OFF.png"] forState:UIControlStateNormal];
            [_editProfileButton setImage:[UIImage imageNamed:@"add-ON.png"] forState:UIControlStateHighlighted];
            [_editProfileButton setFrame:CGRectMake(320-35-7.5,70-20-5,34,20)];
        }
        
    }
    if ([profile profileIconURL]) {
        [_profilePictureImageView setUrlPath:[profile profileIconURL]];
    }
    NSLog(@"profile icon url = %@",[profile profileIconURL]);
	_nameLabel.text = [profile.displayName uppercaseString];
	[_nameLabel setNeedsDisplay];
	_locationLabel.text = profile.location;
	[_locationLabel setNeedsDisplay];
	CGRect badgeFrame = _fashionProfileBadge.frame;
	CGFloat offsetX = [_nameLabel.text sizeWithFont:_nameLabel.font].width + _nameLabel.frame.origin.x;
	[_fashionProfileBadge setFrame:CGRectMake(offsetX,badgeFrame.origin.y,badgeFrame.size.width,badgeFrame.size.height)];
	[_fashionProfileBadge setHidden:NO];
}

- (void)editButtonHighlight {
	[_editProfileButton setHighlighted:YES];
}

- (void)profilePictureButtonAction {
    if (_shouldAllowEditing) {
        NSString* name = [_nameLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* location = [_locationLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        TTOpenURL([NSString stringWithFormat:@"gtio://profile/edit/picture/%@/%@",name,location]);
    }
}

- (void)removeAsMyStylist {
    _profile.stylistRelationship.isMyStylist = NO;
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/remove") delegate:self];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[[NSArray arrayWithObject:_profile.uid] jsonEncode], @"stylistUids", nil];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)addAsMyStylist {
    _profile.stylistRelationship.isMyStylist = YES;
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/add") delegate:self];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSArray arrayWithObject:_profile.uid] jsonEncode], @"stylistUids", nil];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)presentActionSheetForRelationship:(GTIOStylistRelationship*)relationship {
    NSString* title = [NSString stringWithFormat:@"edit connection with %@:", _profile.firstName];
    TWTActionSheetDelegate* delegate = [TWTActionSheetDelegate actionSheetDelegate];
    
    NSString* button1Title;
    NSString* button2Title;
    NSString* button3Title;
    
    if (_profile.stylistRequestAlertsEnabled) {
        button1Title = @"turn off alerts from them";
//        [delegate setTarget:self selector:@selector(turnOffStylistAlerts) object:nil forButtonIndex:0];
    } else {
        button1Title = @"turn on alerts from them";
//        [delegate setTarget:self selector:@selector(turnOnStylistAlerts) object:nil forButtonIndex:0];
    }
    
    if (relationship.iStyleIgnored) {
        button2Title = @"acknowledge their outfits";
        // todo: action
    } else {
        button2Title = @"ignore their outfits";
        // todo: action
    }
    
    if (relationship.isMyStylist) {
        button3Title = @"remove as my stylist";
        // todo: action
    } else {
        button3Title = @"add as my stylist";
        // todo: action
    }
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:delegate cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:button1Title, button2Title, button3Title, nil];
    [actionSheet showInView:[TTNavigator navigator].window];
    
    // _profile.stylistRequestAlertsEnabled // determines if push alerts are on or off
    
    // Possible States:
    // I Style Them, They do not style me
    // I Style Them, They Style Me
    // I Ignore them, they do not style me
    // I Ignore them, they style me
    
    // alerts on/off toggles as well.
    
    // button 0:
    // Toggle alerts
    // button 1:
    // toggle ignored
    // button 2:
    // make/remove as my stylist.
    // button 3:
    // cancel
    
    
    // present action sheet that is dependant about our relationship. allow user to edit our relationship accordingly.
}

- (void)editButtonAction {
    if (_shouldAllowEditing) {
        [_editProfileButton setHighlighted:YES];
        TTOpenURL(@"gtio://profile/edit");
    } else {
        GTIOStylistRelationship* relationship = _profile.stylistRelationship;
        if (relationship.iStyle && !relationship.iStyleIgnored) {
            [self presentActionSheetForRelationship:relationship];
        } else if (relationship.isMyStylist && !relationship.isMyStylistIgnored) {
            [self removeAsMyStylist];
        } else {
            [self addAsMyStylist];
        }
    }
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NSLog(@"Error: %@", error);
    [[[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
    [self displayProfile:_profile];
}

@end
