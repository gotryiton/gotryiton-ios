//
//  GTIOTableImageControlItem.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/7/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Three20UI/TTTableControlItem.h>

@interface GTIOTableImageControlItem : TTTableControlItem {
	UIImage* _image;
	BOOL _shouldInsetImage;
}

@property (nonatomic, assign) BOOL shouldInsetImage;
@property (nonatomic, retain) UIImage* image;

+ (id)itemWithCaption:(NSString *)caption image:(UIImage*)image control:(UIControl *)control;

@end
