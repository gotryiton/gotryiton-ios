//
//  TTTableStatsItem.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/14/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOTableStatsItem.h"


@implementation GTIOTableStatsItem

@end

@implementation GTIOTableStatsCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return 30;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self.textLabel sizeToFit];
	self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 0, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setObject:(id)obj {
	[super setObject:obj];
	self.textLabel.font = kGTIOFontHelveticaNeueOfSize(20);
}

@end

@implementation GTIOIndividualStatItem

@end

@implementation GTIOIndividualStatCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return 24;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.captionLabel.frame = CGRectMake(10, 0, 200, 18);
	self.captionLabel.textAlignment = UITextAlignmentLeft;
	
	self.detailTextLabel.frame = CGRectMake(210, 0, 100, 18);
	self.detailTextLabel.textAlignment = UITextAlignmentRight;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setObject:(id)obj {
	[super setObject:obj];
	
	self.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
	self.detailTextLabel.textColor = kGTIOColorBrightPink;
	self.captionLabel.font = [UIFont boldSystemFontOfSize:12];
	self.captionLabel.textColor = kGTIOColorB8B8B8;
	
	self.captionLabel.text = [self.captionLabel.text uppercaseString];
}

@end