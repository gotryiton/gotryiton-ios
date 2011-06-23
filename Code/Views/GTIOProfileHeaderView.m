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
    background.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	[self addSubview:background];
	[background release];
    
    _backgroundOverlay = [[UIImageView alloc] initWithImage:nil];
	[self addSubview:_backgroundOverlay];
	
    _profilePictureImageView = [TTImageView new];
    _profilePictureImageView.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];
    [(UIImageView*)_profilePictureImageView setImage:[UIImage imageNamed:@"empty-profile-pic.png"]];
	_profilePictureImageView.layer.cornerRadius = 5.0;
	[_profilePictureImageView setFrame:CGRectMake(10,8,54,54)];
	[self addSubview:_profilePictureImageView];
	
	UIButton* profilePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[profilePictureButton setBackgroundColor:[UIColor clearColor]];
	[profilePictureButton setFrame:_profilePictureImageView.frame];
	[profilePictureButton addTarget:self action:@selector(profilePictureButtonAction) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:profilePictureButton];
		
	_profilePictureFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-icon-overlay-110.png"]];
	[_profilePictureFrame setFrame:CGRectMake(5,3,64,64)];
	[self addSubview:_profilePictureFrame];
	
//	_fashionProfileBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fash-badge-profile.png"]];
//	[_fashionProfileBadge setFrame:CGRectMake(0,2.5,48,48)];
//	[self addSubview:_fashionProfileBadge];
//	[_fashionProfileBadge setHidden:YES];

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
	
	_editProfileButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
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
    [_editProfileButton release];
    [_profile release];
    [_profilePictureFrame release];
    [_backgroundOverlay release];
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
        [_editProfileButton setFrame:CGRectMake(320-45,45,35,20)];
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
            [_editProfileButton setFrame:CGRectMake(320-45,45,35,20)];
        } else if (relationship.isMyStylist && !relationship.isMyStylistIgnored) {
            // Remove
            [_editProfileButton setImage:[UIImage imageNamed:@"remove-OFF.png"] forState:UIControlStateNormal];
            [_editProfileButton setImage:[UIImage imageNamed:@"remove-ON.png"] forState:UIControlStateHighlighted];
            [_editProfileButton setFrame:CGRectMake(320-65,45,55,20)];
        } else {
            // add
            [_editProfileButton setImage:[UIImage imageNamed:@"add-OFF.png"] forState:UIControlStateNormal];
            [_editProfileButton setImage:[UIImage imageNamed:@"add-ON.png"] forState:UIControlStateHighlighted];
            [_editProfileButton setFrame:CGRectMake(320-45,45,35,20)];
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

    
    //	CGRect badgeFrame = _fashionProfileBadge.frame;
    
    // TODO: real badges here.
//	CGFloat offsetX = [_nameLabel.text sizeWithFont:_nameLabel.font].width + _nameLabel.frame.origin.x;
//	[_fashionProfileBadge setFrame:CGRectMake(offsetX,badgeFrame.origin.y,badgeFrame.size.width,badgeFrame.size.height)];
//	[_fashionProfileBadge setHidden:NO];
    
    if ([[profile isBranded] boolValue]) {
        self.frame = CGRectMake(0,self.frame.origin.y,self.bounds.size.width,85);
        _profilePictureFrame.image = [UIImage imageNamed:@"profile-icon-overlay-verified-110.png"];
        [_profilePictureFrame setFrame:CGRectMake(5,3,64,80)];
        [self addSubview:_backgroundOverlay];
        _backgroundOverlay.image = [UIImage imageNamed:@"dark-top-verified-overlay"];
        _editProfileButton.frame = CGRectOffset(_editProfileButton.frame, 0, 15);
    } else {
        self.frame = CGRectMake(0,self.frame.origin.y,self.bounds.size.width,70);
        _profilePictureFrame.image = [UIImage imageNamed:@"profile-icon-overlay-110.png"];
        [_profilePictureFrame setFrame:CGRectMake(5,3,64,64)];
        [_backgroundOverlay removeFromSuperview];
    }
}

- (void)editButtonHighlight {
	[_editProfileButton setHighlighted:YES];
}

- (void)profilePictureButtonAction {
    if (_shouldAllowEditing) {
        NSString* name = [_nameLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* location = [_locationLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([location length] == 0) {
            location = @" ";
        }
        TTOpenURL([NSString stringWithFormat:@"gtio://profile/edit/picture/%@/%@",name,location]);
    }
}

// TODO: these should probably be model methods on GTIOUser. removeAsMyStylist:(GTIOProfile*) with a delegate pattern.

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

- (void)acknowledgeStylist {
    _profile.stylistRelationship.iStyleIgnored = NO;
    NSString* path = [NSString stringWithFormat:@"/i-style/activate/%@", _profile.uid];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)ignoreStylist {
    _profile.stylistRelationship.iStyleIgnored = YES;
    NSString* path = [NSString stringWithFormat:@"/i-style/ignore/%@", _profile.uid];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)turnOffStylistAlerts {
    _profile.stylistRequestAlertsEnabled = [NSNumber numberWithBool:NO];
    NSString* path = [NSString stringWithFormat:@"/i-style/quiet/%@", _profile.uid];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)turnOnStylistAlerts {
    _profile.stylistRequestAlertsEnabled = [NSNumber numberWithBool:YES];
    NSString* path = [NSString stringWithFormat:@"/i-style/loud/%@", _profile.uid];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:self];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)presentActionSheetForRelationship:(GTIOStylistRelationship*)relationship {
    NSString* title = [NSString stringWithFormat:@"edit connection with %@:", _profile.firstName];
    TWTActionSheetDelegate* delegate = [TWTActionSheetDelegate actionSheetDelegate];
    
    NSString* button1Title;
    NSString* button2Title;
    NSString* button3Title;
    
    if ([_profile.stylistRequestAlertsEnabled boolValue]) {
        button1Title = @"turn off alerts from them";
        [delegate setTarget:self selector:@selector(turnOffStylistAlerts) object:nil forButtonIndex:0];
    } else {
        button1Title = @"turn on alerts from them";
        [delegate setTarget:self selector:@selector(turnOnStylistAlerts) object:nil forButtonIndex:0];
    }
    
    if (relationship.iStyleIgnored) {
        button2Title = @"acknowledge their outfits";
        [delegate setTarget:self selector:@selector(acknowledgeStylist) object:nil forButtonIndex:1];
    } else {
        button2Title = @"ignore their outfits";
        [delegate setTarget:self selector:@selector(ignoreStylist) object:nil forButtonIndex:1];
    }
    
    if (relationship.isMyStylist) {
        button3Title = @"remove as my stylist";
        [delegate setTarget:self selector:@selector(removeAsMyStylist) object:nil forButtonIndex:2];
    } else {
        button3Title = @"add as my stylist";
        [delegate setTarget:self selector:@selector(addAsMyStylist) object:nil forButtonIndex:2];
    }
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:delegate cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:button1Title, button2Title, button3Title, nil];
    [actionSheet showInView:[TTNavigator navigator].window];
}

- (void)editButtonAction {
    if (_shouldAllowEditing) {
        [_editProfileButton setHighlighted:YES];
        TTOpenURL(@"gtio://profile/edit");
    } else {
        GTIOStylistRelationship* relationship = _profile.stylistRelationship;
        if (relationship.iStyle) {
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
