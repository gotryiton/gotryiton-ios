//
//  GTIOTodosTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/23/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOTodosTableViewController.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOSortTab.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOListSection.h"
#import "GTIOStaticOutfitListModel.h"
#import "GTIOOutfitViewController.h"
#import "GTIOHeaderView.h"

@implementation GTIOTodosTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.apiEndpoint = GTIORestResourcePath(@"/todos");
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"TO-DOs"];
    
    if ([GTIOUser currentUser].loggedIn) {
        GTIOBarButtonItem* whoIStyleItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"who i style" target:self action:@selector(whoIStyleButtonPressed:)] autorelease];
        self.navigationItem.rightBarButtonItem = whoIStyleItem;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)whoIStyleButtonPressed:(id)sender {
    TTOpenURL(@"gtio://whoIStyle");
}

- (void)createModel {
    _queryText = nil;
    [super createModel];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self invalidateModel];
}

// Use tabs instead of sortTabs.
- (void)tabBar:(GTIOTabBar*)tabBar selectedTabAtIndex:(NSUInteger)index {
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    GTIOSortTab* tab = [model.list.tabs objectAtIndex:index];
    if (tab) {
        [_apiEndpoint release];
        _apiEndpoint = [tab.sortAPI retain];
        [self invalidateModel];
    }
}

- (void)loadedList:(GTIOBrowseList*)list {
    NSLog(@"List: %@", list);
    NSLog(@"Tabs: %@", list.tabs);
    
    if (list.tabs && [list.tabs count] > 0) {
        // throw away the old tab bar, setup a new one.
        [_sortTabBar removeFromSuperview];
        [_sortTabBar release];
        
        _sortTabBar = [[GTIOTabBar alloc] initWithFrame:CGRectMake(0,0,320,37)];
        [_sortTabBar setTabNames:[list.tabs valueForKey:@"title"]];
        for (GTIOSortTab* tab in list.tabs) {
            int index = [list.tabs indexOfObject:tab];
            if ([tab.selected boolValue] == YES) {
                [_sortTabBar setSelectedTabIndex:index];
            }
            GTIOTab* sortTab = [_sortTabBar.tabs objectAtIndex:index];
            sortTab.badge = tab.badgeNumber;
        }
        _sortTabBar.delegate = self;
        [self.view addSubview:_sortTabBar];
        
        GTIOSortTab* tab = [list.tabs objectAtIndex:_sortTabBar.selectedTabIndex];
        _sortTabBar.subtitle = tab.subtitle;
        
        self.tableView.frame = CGRectMake(0,_sortTabBar.bounds.size.height,320,self.view.bounds.size.height - _sortTabBar.bounds.size.height);
        _topShadowImageView.frame = CGRectMake(0,_sortTabBar.bounds.size.height,320, 10);
    } else {
        self.tableView.frame = self.view.bounds;
        _topShadowImageView.frame = CGRectMake(0,0,320, 10);
    }
    
    if (list.outfits) {
        [self.tableView setContentInset:UIEdgeInsetsMake(8, 0, 0, 0)];
        
        NSMutableArray* items = [NSMutableArray array];
        for (GTIOOutfit* outfit in list.outfits) {
            GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
            [items addObject:item];
        }
        
        TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:items];
        ds.model = self.model;
        self.dataSource = ds;
    } else {
        // sections.
        _topShadowImageView.frame = CGRectZero;
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        NSMutableArray* sectionNames = [NSMutableArray array];
        NSMutableArray* sections = [NSMutableArray array];
        for (GTIOListSection* section in list.sections) {
            [sectionNames addObject:section.title];
            NSMutableArray* items  = [NSMutableArray array];
            for (GTIOOutfit* outfit in section.outfits) {
                GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
                [items addObject:item];
            }
            [sections addObject:items];
        }
        
        // TODO: we need to style these sections, add the drop shadow and some padding to the top.
        TTSectionedDataSource* ds = [GTIOBrowseSectionedDataSource dataSourceWithItems:sections sections:sectionNames];
        ds.model = self.model;
        self.dataSource = ds;
    }
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    GTIOBrowseList* list = [(GTIOBrowseListTTModel*)self.model list];
    if (list.sections) {
        GTIOListSection* section = [list.sections objectAtIndex:indexPath.section];
        GTIOStaticOutfitListModel* staticModel = [GTIOStaticOutfitListModel modelWithOutfits:section.outfits];
        // manage showing outfits from a sectioned list.
        GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:staticModel outfitIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else {
        [super didSelectObject:object atIndexPath:indexPath];
    }
}

@end
