//
//  GTIOTableImageControlItem.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/7/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTableImageControlItem.h"

@implementation GTIOTableImageControlItem

@synthesize shouldInsetImage = _shouldInsetImage;
@synthesize image = _image;

- (void)dealloc {
	TT_RELEASE_SAFELY(_image);

	[super dealloc];
}

+ (id)itemWithCaption:(NSString *)caption image:(UIImage*)image control:(UIControl *)control {
	GTIOTableImageControlItem* item = [[[self alloc] init] autorelease];
	item.caption = caption;
	item.image = image;
	item.control = control;
	return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	if (self = [super initWithCoder:decoder]) {
		self.caption = [decoder decodeObjectForKey:@"caption"];
		self.image = [decoder decodeObjectForKey:@"image"];
		self.control = [decoder decodeObjectForKey:@"control"];	
	}
	return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
	if (self.caption) {
		[encoder encodeObject:self.caption forKey:@"caption"];
	}
	if (self.image) {
		[encoder encodeObject:self.image forKey:@"image"];
	}
	if (self.control) {
		[encoder encodeObject:self.control forKey:@"control"];
	}
}

@end
