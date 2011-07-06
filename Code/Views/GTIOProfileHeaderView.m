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
#import <TWTAlertViewDelegate.h>
#import "GTIOBadge.h"
#import "GTIOAnalyticsTracker.h"

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
	[_profilePictureImageView setFrame:CGRectMake(8,8,55,55)];
	[self addSubview:_profilePictureImageView];
	
	UIButton* profilePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[profilePictureButton setBackgroundColor:[UIColor clearColor]];
	[profilePictureButton setFrame:_profilePictureImageView.frame];
	[profilePictureButton addTarget:self action:@selector(profilePictureButtonAction) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:profilePictureButton];
		
	_profilePictureFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-icon-overlay-110.png"]];
	[_profilePictureFrame setFrame:CGRectMake(3,3,65,65)];
	[self addSubview:_profilePictureFrame];
    
	_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 9, 250, 40)];
	_nameLabel.backgroundColor = [UIColor clearColor];
	_nameLabel.font = kGTIOFetteFontOfSize(36);
    _nameLabel.minimumFontSize = 24;
	_nameLabel.textColor = [UIColor whiteColor];
	[self addSubview:_nameLabel];
	
	_locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(72.5, 42, 250, 20)];
	_locationLabel.backgroundColor = [UIColor clearColor];
	_locationLabel.font = [UIFont systemFontOfSize:15];
	_locationLabel.textColor = kGTIOColorB2B2B2;
	[self addSubview:_locationLabel];
	
	_editProfileButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[_editProfileButton addTarget:self action:@selector(editButtonHighlight) forControlEvents:UIControlEventTouchDown];
	[_editProfileButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_editProfileButton];
    
    _connectionImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(280+3,10,24,23)] autorelease];
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
    [_badgeImageViews release];
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
        [_editProfileButton setFrame:CGRectMake(320-45+3,45,35,20)];
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
            [_editProfileButton setFrame:CGRectMake(320-45+3,45,35,20)];
        } else if (relationship.isMyStylist && !relationship.isMyStylistIgnored) {
            // Remove
            [_editProfileButton setImage:[UIImage imageNamed:@"remove-OFF.png"] forState:UIControlStateNormal];
            [_editProfileButton setImage:[UIImage imageNamed:@"remove-ON.png"] forState:UIControlStateHighlighted];
            [_editProfileButton setFrame:CGRectMake(320-65+3,45,55,20)];
        } else {
            // add
            [_editProfileButton setImage:[UIImage imageNamed:@"add-OFF.png"] forState:UIControlStateNormal];
            [_editProfileButton setImage:[UIImage imageNamed:@"add-ON.png"] forState:UIControlStateHighlighted];
            [_editProfileButton setFrame:CGRectMake(320-45+3,45,35,20)];
        }
        
    }
    
    // Make the tap target for this button larger
    _editProfileButton.frame = CGRectInset(_editProfileButton.frame, -20, -100);
    _editProfileButton.contentEdgeInsets = UIEdgeInsetsMake(50,10,50,10);
    
    if ([profile profileIconURL]) {
        [_profilePictureImageView setUrlPath:[profile profileIconURL]];
    }
    NSLog(@"profile icon url = %@",[profile profileIconURL]);
	_nameLabel.text = [profile.displayName uppercaseString];
	_locationLabel.text = profile.location;
	[_locationLabel setNeedsDisplay];
    
    for (UIView* view in _badgeImageViews) {
        [view removeFromSuperview];
    }
    [_badgeImageViews release];
    _badgeImageViews = [NSMutableArray new];
    
    int numberOfBadges = [profile.badges count];
    float badgeWidthIncludingPadding = 34;
    float maxNameLabelWidth = 210 - (badgeWidthIncludingPadding*numberOfBadges);
    float width = [_nameLabel.text sizeWithFont:_nameLabel.font].width;
    _nameLabel.frame = CGRectMake(72, 9, MIN(width, maxNameLabelWidth), 40);
    [_nameLabel setNeedsDisplay];
    float x = CGRectGetMaxX(_nameLabel.frame) - 4;
    float y = 2;
    for (GTIOBadge* badge in profile.badges) {
        TTImageView* imageView = [[[TTImageView alloc] initWithFrame:CGRectMake(x,y,48,48)] autorelease];
        x += badgeWidthIncludingPadding;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.urlPath = badge.imgURL;
        [self addSubview:imageView];
        [_badgeImageViews addObject:imageView];
    }

    
    if ([[profile isBranded] boolValue]) {
        self.frame = CGRectMake(0,self.frame.origin.y,self.bounds.size.width,88);
        _profilePictureFrame.image = [UIImage imageNamed:@"profile-icon-overlay-verified-110.png"];
        [_profilePictureFrame setFrame:CGRectMake(4,4,63,80)];
        [self addSubview:_backgroundOverlay];
        _backgroundOverlay.image = [UIImage imageNamed:@"dark-top-verified-overlay"];
        _editProfileButton.frame = CGRectOffset(_editProfileButton.frame, 0, 15);
    } else {
        self.frame = CGRectMake(0,self.frame.origin.y,self.bounds.size.width,70);
        _profilePictureFrame.image = [UIImage imageNamed:@"profile-icon-overlay-110.png"];
        [_profilePictureFrame setFrame:CGRectMake(4,4,63,63)];
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

    TWTAlertViewDelegate* delegate = [[[TWTAlertViewDelegate alloc] init] autorelease];
	[delegate setTarget:self selector:@selector(removeAsMyStylistConfirmed) object:nil forButtonIndex:1];
    NSString* message = [NSString stringWithFormat:
                         @"your outfits will no longer show in %@'s To-Do list, and %@ will not be notified when you upload.",
                         _profile.firstName, ([_profile.gender isEqualToString:@"male"] ? @"he" : @"she")];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"remove personal stylist?" message:message delegate:delegate cancelButtonTitle:@"cancel" otherButtonTitles:@"remove", nil];
	[alert show];
	[alert release];
}
- (void)removeAsMyStylistConfirmed {
    GTIOAnalyticsEvent(kUserDeletedStylistEventName);    
    _profile.stylistRelationship.isMyStylist = NO;
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/remove") delegate:self];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[[NSArray arrayWithObject:_profile.uid] jsonEncode], @"stylistUids", nil];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)addAsMyStylist {
    [[GTIOAnalyticsTracker sharedTracker] trackUserDidAddStylists:[NSNumber numberWithInt:1]];
    TWTAlertViewDelegate* delegate = [[[TWTAlertViewDelegate alloc] init] autorelease];
	[delegate setTarget:self selector:@selector(addAsMyStylistConfirmed) object:nil forButtonIndex:1];
    NSString* message = [NSString stringWithFormat:
                         @"your outfits will show up in %@'s To-Do list, and %@ may be notified every time you upload.",
                         _profile.firstName, ([_profile.gender isEqualToString:@"male"] ? @"he" : @"she")];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"add as personal stylist?" message:message delegate:delegate cancelButtonTitle:@"cancel" otherButtonTitles:@"add", nil];
	[alert show];
	[alert release];
}

- (void)addAsMyStylistConfirmed {
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
    GTIOAnalyticsEvent(kUserIgnoredStylistEventName);
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
    if (![GTIOUser currentUser].loggedIn) {
        TTOpenURL(@"gtio://login");
        return;
    }
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
