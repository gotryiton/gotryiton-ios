//
//  GTIOTableOutfitImageCell.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOTableOutfitImageCell.h"

@implementation GTIOTableOutfitImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		
		_thumbnail = [[TTImageView alloc] initWithFrame:CGRectZero];
		_thumbnail.backgroundColor = [UIColor whiteColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		[self.contentView addSubview:_thumbnail];
		
		_thumbnailBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:_thumbnailBackground];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_thumbnailBackground);
	TT_RELEASE_SAFELY(_thumbnail);
	[super dealloc];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return 105.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectOffset(self.contentView.frame, -2, 0);
}

- (NSString*)thumbnailUrlPath {
	return nil;
}

- (BOOL)isMultipleOutfitCell {
	return NO;
}

- (int)cellIndex {
	return 0;
}

- (void)setObject:(id)obj {
	// [super setObject:obj];
	[_thumbnail setUrlPath:[self thumbnailUrlPath]];
	if ([self isMultipleOutfitCell]) {
		_thumbnail.defaultImage = [UIImage imageNamed:@"hanger-filler-multiple.png"];
		CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0.020943951);//0.0436332313
		_thumbnailBackground.image = [UIImage imageNamed:@"list-frame-multiple.png"];
		_thumbnailBackground.frame = CGRectMake(2,-2,92,107);
		_thumbnail.frame = CGRectMake(16, 7, 69, 91);//CGRectMake(16, 8, 66, 90);
		_thumbnail.transform = transform;
		_thumbnailBackground.transform = transform;
	} else {
		_thumbnail.defaultImage = [UIImage imageNamed:@"hanger-filler-single.png"];
		_thumbnailBackground.image = [UIImage imageNamed:@"list-frame-single.png"];
		_thumbnailBackground.frame = CGRectInset(CGRectMake(15,6,138/2,182/2), -7,-7);
		_thumbnail.frame = CGRectMake(15,6,69,91);
		float minRadians = 0.00698131701; // 0.4 degrees
		float maxRadians = 0.020943951; // 1.2 degrees
		float r = (rand() / (float)((unsigned)RAND_MAX + 1));
		float radiansToRotate = r * (maxRadians - minRadians) + minRadians;
		if ([self cellIndex] >= 0 && [self cellIndex] % 2 == 0) {
			radiansToRotate = -radiansToRotate;
		}
		CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, radiansToRotate);
		_thumbnail.transform = transform;
		_thumbnailBackground.transform = transform;
	}
	[self setNeedsDisplay];
}

@end
