//
//  TTTableViewDelegate+GTIOAdditions.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/7/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "TTTableViewDelegate+GTIOAdditions.h"

@implementation TTTableViewDelegate (GTIOAdditions)

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(nil != [self tableView:tableView viewForHeaderInSection:section]) {
        return 35;
    } else {
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (NO == [tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
		return nil;
	}
	
	NSString* title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
	if (title.length > 0) {
		UILabel* label = [[UILabel alloc] init];
		label.text = title;
		label.font = [UIFont boldSystemFontOfSize:14];
		label.textColor = [UIColor blackColor];
		label.backgroundColor = [UIColor clearColor];
		[label sizeToFit];
		label.frame = CGRectOffset(label.frame, 20, 3);
		
		UIView* container = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
		[container addSubview:label];
		[label release];
		
		return container;
	}
	
	return nil;
}

@end
