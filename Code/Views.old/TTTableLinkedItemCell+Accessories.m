//
//  TTTableLinkedItemCell_Accessories.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 9/14/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "TTTableLinkedItemCell+Accessories.h"


@implementation TTTableLinkedItemCell (Accessories)

- (void)setObject:(id)object {
	if (_item != object) {
		[_item release];
		_item = [object retain];
		
		TTTableLinkedItem* item = object;
		
		if (item.URL) {
			if (item.accessoryURL) {
				self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				
			} else {
				self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
			}
			
			self.selectionStyle = TTSTYLEVAR(tableSelectionStyle);
			
		} else {
			self.accessoryType = UITableViewCellAccessoryNone;
			self.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
}

@end
