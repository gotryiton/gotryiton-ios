//
//  GTIOTagsViewController.m
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTagsViewController.h"

#import "GTIOTag.h"
#import "GTIORecentTag.h"
#import "GTIOTrendingTag.h"

#import "GTIONavigationTitleView.h"
#import "GTIOTagsSearchBoxView.h"
#import "GTIOProgressHUD.h"
#import "GTIOTagsSectionHeader.h"
#import "GTIOTagCell.h"
#import "GTIOTableView.h"

#import "GTIORouter.h"

#import <RestKit/RestKit.h>

static CGFloat const kGTIOTableSectionHeaderHeight = 21.0f;

@interface GTIOTagsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) GTIOTableView *tableView;
@property (nonatomic, strong) GTIOTagsSearchBoxView *searchBoxView;

@property (nonatomic, strong) NSMutableArray *recentTags;
@property (nonatomic, strong) NSMutableArray *trendingTags;
@property (nonatomic, strong) NSMutableArray *searchTags;

@end

@implementation GTIOTagsViewController

@synthesize tableView = _tableView, searchBoxView = _searchBoxView;
@synthesize recentTags = _recentTags, trendingTags = _trendingTags, searchTags = _searchTags;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setHidesBottomBarWhenPushed:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recentTags = [NSMutableArray array];
    self.trendingTags = [NSMutableArray array];
    self.searchTags = [NSMutableArray array];
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"search tags" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    // Search bar
    self.searchBoxView = [[GTIOTagsSearchBoxView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 45 } }];
    [self.searchBoxView.searchBar setDelegate:self];
    [self.view addSubview:self.searchBoxView];
    
    // Table View
    self.tableView = [[GTIOTableView alloc] initWithFrame:(CGRect){ { 0, self.searchBoxView.frame.size.height }, { self.view.frame.size.width, self.view.frame.size.height - self.searchBoxView.frame.size.height - self.navigationController.navigationBar.frame.size.height } } style:UITableViewStylePlain];
    [self.tableView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setRowHeight:49.0f];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor gtio_grayBorderColorD9D7CE]];
    [self.view addSubview:self.tableView];
    
    UIImageView *tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-shadow.png"]];
    [tableFooterView setFrame:(CGRect){ 0, 0, self.tableView.frame.size.width, 5 }];
    [self.tableView setTableFooterView:tableFooterView];
    
    [self loadDefaultSearchTags];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.searchBoxView = nil;
    self.recentTags = nil;
    self.trendingTags = nil;
    self.searchTags = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Data

- (void)loadDefaultSearchTags
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/tags/search" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.recentTags removeAllObjects];
            [self.trendingTags removeAllObjects];
            
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[GTIORecentTag class]]) {
                    [self.recentTags addObject:obj];
                } else if ([obj isKindOfClass:[GTIOTrendingTag class]]) {
                    [self.trendingTags addObject:obj];
                }
            }];
            
            [self.tableView reloadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:nil];
            NSLog(@"Error loading default search tags: %@", [error localizedDescription]);
        };
    }];
}

- (void)loadTagsFromSearch:(NSString *)searchTerm
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/tags/search/%@", searchTerm] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.searchTags removeAllObjects];
            
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[GTIOTag class]]) {
                    [self.searchTags addObject:obj];
                }
            }];
            
            [self.tableView reloadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:nil];
            NSLog(@"Error loading default search tags: %@", [error localizedDescription]);
        };
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchBoxView.searchBar.text length] == 0) {
        if (0 == section) {
            return [self.recentTags count];
        } else {
            return [self.trendingTags count];
        } 
    } else {
        return [self.searchTags count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GTIOTagCellIdentifier";
    GTIOTagCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GTIOTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.searchBoxView.searchBar.text length] == 0) {
        return 2;
    } else {
        return 1;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOTag *tag = nil;
    
    if ([self.searchBoxView.searchBar.text length] == 0) {
        if (0 == indexPath.section) {
            tag = [self.recentTags objectAtIndex:indexPath.row];
        } else if (1 == indexPath.section) {
            tag = [self.trendingTags objectAtIndex:indexPath.row];
        }
    } else {
        tag = [self.searchTags objectAtIndex:indexPath.row];
    }

    [((GTIOTagCell *)cell)setGtioTag:tag];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.searchBoxView.searchBar.text length] == 0) {
        return kGTIOTableSectionHeaderHeight;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.searchBoxView.searchBar.text length] == 0) {
        GTIOTagsSectionHeader *sectionHeader = [[GTIOTagsSectionHeader alloc] initWithFrame:(CGRect){ CGPointZero, { self.tableView.frame.size.width, self.tableView.sectionHeaderHeight } }];
        if (0 == section) {
            [sectionHeader setTitle:@"RECENT"];
        } else if (1 == section) {
            [sectionHeader setTitle:@"TRENDING"];
        }
        return sectionHeader;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOTag *tag = nil;
    
    if ([self.searchBoxView.searchBar.text length] == 0) {
        if (0 == indexPath.section) {
            tag = [self.recentTags objectAtIndex:indexPath.row];
        } else if (1 == indexPath.section) {
            tag = [self.trendingTags objectAtIndex:indexPath.row];
        }
    } else {
        tag = [self.searchTags objectAtIndex:indexPath.row];
    }
    
    id viewController = [[GTIORouter sharedRouter] viewControllerForURLString:tag.action.destination];
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        [self loadDefaultSearchTags];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self loadTagsFromSearch:searchBar.text];
    [searchBar resignFirstResponder];
}

@end
