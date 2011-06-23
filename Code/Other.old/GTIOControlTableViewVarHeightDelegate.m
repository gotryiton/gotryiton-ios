//
//  GTIOControlTableViewVarHeightDelegate.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/21/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOControlTableViewVarHeightDelegate.h"

@implementation GTIOControlTableViewVarHeightDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TTTableControlItem* item = [self.controller.dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
	if ([item isKindOfClass:[TTTableControlItem class]]) {
		[item.control becomeFirstResponder];
	} else {
        return indexPath;
    }
	
	return nil;
}

@end
