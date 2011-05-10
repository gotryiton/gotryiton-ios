//
//  GTIOSectionedDataSource.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/7/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOSectionedDataSource.h"
#import "GTIOTableImageControlItem.h"
#import "GTIOTableImageControlCell.h"

@implementation GTIOSectionedDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[GTIOTableImageControlItem class]]) {
		return [GTIOTableImageControlCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end
