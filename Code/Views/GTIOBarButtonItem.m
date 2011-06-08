//
//  GTIOBarButtonItem.m
//  GTIO
//
//  Created by Daniel Hammond on 5/10/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOBarButtonItem.h"

@implementation GTIOBarButtonItem

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	return [self initWithTitle:title target:target action:action backButton:NO]; // default is normal
}

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action backButton:(BOOL)backButton {
	// Calculate Size of Text
	CGSize textSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:12.0]];
	// Create Container View
	UIView* view = [[UIView new] autorelease];
	[view setFrame:CGRectMake(0, 0, textSize.width+20, 32)];		
	// Create The Background Image
	UIImage* bg = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
	// Size Changes when Back Button style
	if (backButton) {
		[view setFrame:CGRectMake(0, 0, textSize.width+27, 32)];
		bg = [[UIImage imageNamed:@"back-button.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:0];
	}
	// Create Button
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:view.frame];
	[button setBackgroundColor:[UIColor clearColor]];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundImage:bg forState:UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	// Fix title spacing for back buttons
	if (backButton) { 
		[button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
	}
	[[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
	[[button titleLabel] setShadowOffset:CGSizeMake(0, -1)];
	[[button titleLabel] setShadowColor:kGTIOColor888888];
	[view addSubview:button];
	return [super initWithCustomView:view];
}

- (id)initWithImage:(UIImage*)image target:(id)target action:(SEL)action {	
	// Create Container View
	UIView* view = [[UIView new] autorelease];
	[view setFrame:CGRectMake(0, 0, [image size].width+15, 32)];		
	// Create The Background Image
	UIImage* bg = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
	// Create Button
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:view.frame];
	[button setBackgroundColor:[UIColor clearColor]];
	[button setImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:bg forState:UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:button];
	return [super initWithCustomView:view];
}

+ (id)listBackBarButtonWithTarget:(id)target action:(SEL)action {	
	// Create Container View
	UIView* view = [[UIView new] autorelease];
	[view setFrame:CGRectMake(0, 0, 45, 32)];		
	// Create The Background Image
	UIImage* bg = [[UIImage imageNamed:@"back-button.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:0];
	// Create Button
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:view.frame];
	[button setBackgroundColor:[UIColor clearColor]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundImage:bg forState:UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:button];
	UIImageView* homeImage = [UIImageView new];
	[homeImage setImage:[UIImage imageNamed:@"back-list.png"]];
	[homeImage setFrame:CGRectMake(12, 7, 26, 17)];
	[view addSubview:homeImage];
	[homeImage release];
	return [[[self alloc] initWithCustomView:view] autorelease];
}

+ (id)homeBackBarButtonWithTarget:(id)target action:(SEL)action {	
	// Create Container View
	UIView* view = [[UIView new] autorelease];
	[view setFrame:CGRectMake(0, 0, 45, 32)];		
	// Create The Background Image
	UIImage* bg = [[UIImage imageNamed:@"back-button.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:0];
	// Create Button
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:view.frame];
	[button setBackgroundColor:[UIColor clearColor]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundImage:bg forState:UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:button];
	UIImageView* homeImage = [UIImageView new];
	[homeImage setImage:[UIImage imageNamed:@"home-back.png"]];
	[homeImage setFrame:CGRectMake(12, 7, 26, 17)];
	[view addSubview:homeImage];
	[homeImage release];
	return [[[self alloc] initWithCustomView:view] autorelease];
}

+ (id)backButton {
    UIViewController* previousViewController = [TTNavigator navigator].topViewController;
    NSLog(@"all - %@",[[[TTNavigator navigator].topViewController navigationController] viewControllers]);
    NSLog(@"previous:%@",[previousViewController class]);
    if ([[previousViewController class] isEqual:NSClassFromString(@"GTIOHomeViewController")]) {
        return [self homeBackBarButtonWithTarget:self action:@selector(backButtonAction)];
    } else if ([previousViewController title]) {
        return [[[self alloc] initWithTitle:[previousViewController title]
                                     target:self
                                     action:@selector(backButtonAction)
                                 backButton:YES] autorelease];
    } else {
        return [[[self alloc] initWithTitle:@"back"
                                     target:self
                                     action:@selector(backButtonAction)
                                 backButton:YES] autorelease]; 
    }    
}

+ (void)backButtonAction {
    [[[TTNavigator navigator].topViewController navigationController] popViewControllerAnimated:YES];
}

@end
