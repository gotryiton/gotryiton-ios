//
//  GTIOTableImageControlItem.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/7/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOTableImageControlItem is a [TTTableControlItem](TTTableControlItem) that displays an image and a control
#import <Three20UI/TTTableControlItem.h>

@interface GTIOTableImageControlItem : TTTableControlItem {
	UIImage* _image;
	BOOL _shouldInsetImage;
}
/// true if the item should inset the image when its drawn in a cell
@property (nonatomic, assign) BOOL shouldInsetImage;
/// the item image
@property (nonatomic, retain) UIImage* image;
/// returns a GTIOTableImageControlItem with the given caption image and control
+ (id)itemWithCaption:(NSString *)caption image:(UIImage*)image control:(UIControl *)control;

@end
