//
//  GTIODropShadowSectionTableViewDelegate.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/26/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIODropShadowSectionTableViewDelegate.h"


@implementation GTIODropShadowSectionTableViewDelegate

@synthesize footerHeight = _footerHeight;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return _footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,_footerHeight)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return nil;
    }
    NSString* title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    UIView* header = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
    header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"todo-tab-bg.png"]];
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(5,0,300,20)] autorelease];
    [header addSubview:label];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    
    UIImage* topShadow = [UIImage imageNamed:@"list-top-shadow.png"];
    UIImageView* topShadowImageView = [[[UIImageView alloc] initWithImage:topShadow] autorelease];
    [header addSubview:topShadowImageView];
    topShadowImageView.backgroundColor = [UIColor clearColor];
    topShadowImageView.frame = CGRectMake(0, header.bounds.size.height, 320, 20);
    return header;
}

@end