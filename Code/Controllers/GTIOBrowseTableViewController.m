//
//  GTIOBrowseTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOBrowseTableViewController.h"
#import "GTIOCategory.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOOutfitTableViewCell.h"
#import "GTIOGiveAnOpinionTableViewDataSource.h"
#import "GTIODropShadowSectionTableViewDelegate.h"
#import "GTIOSortTab.h"
#import "GTIOOutfitViewController.h"
#import <RestKit/RestKit.h>
#import "GTIOReview.h"
#import "GTIOUserReviewTableItem.h"
#import "GTIOUserReviewTableItemCell.h"

@interface GTIOTableImageItemCell : TTTableImageItemCell
@end

@implementation GTIOTableImageItemCell

- (void)setObject:(id)obj {
    [super setObject:obj];
    self.textLabel.font = [UIFont systemFontOfSize:24];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_imageView2.bounds.size.width > 0) {
        self.textLabel.frame = CGRectMake(60, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    }
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 50;
}

@end

@interface GTIOTableImageNoDisclosureItemCell : GTIOTableImageItemCell
@end
@implementation GTIOTableImageNoDisclosureItemCell

- (void)setObject:(id)obj {
    [super setObject:obj];
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end

@implementation GTIOBrowseListDataSource

- (TTTableItem*)tableItemForObject:(id)object {
	if ([object isKindOfClass:[GTIOOutfit class]]) {
		return [GTIOOutfitTableViewItem itemWithOutfit:object];
	} else {
		return [TTTableTextItem itemWithText:[object description]];
	}
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOOutfitTableViewItem class]]) {
		return [GTIOOutfitTableViewCell class];	
    } else if ([object isKindOfClass:[TTTableImageItem class]]) {
        return [GTIOTableImageItemCell class];
	} else if ([GTIOUserReviewTableItem class])  {
        return [GTIOUserReviewTableItemCell class];
    } else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

- (NSString*)titleForEmpty {
	return @"Nothing Here";
}

@end

@implementation GTIOBrowseSectionedDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOOutfitTableViewItem class]]) {
		return [GTIOOutfitTableViewCell class];	
    } else if ([object isKindOfClass:[TTTableImageItem class]]) {
        return [GTIOTableImageItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

@interface GTIOSectionedDataSourceWithIndexSidebar : GTIOBrowseSectionedDataSource
@end

@implementation GTIOSectionedDataSourceWithIndexSidebar

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
    if ([object isKindOfClass:[TTTableImageItem class]]) {
        return [GTIOTableImageNoDisclosureItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* sectionsCopy = [[self.sections mutableCopy] autorelease];
    [sectionsCopy insertObject:@"{search}" atIndex:0];
    return sectionsCopy;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index == 0) {
        [tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        return -1;
    }
    return index-1;
}

@end

@implementation GTIOBrowseTableViewController

@synthesize apiEndpoint = _apiEndpoint;
@synthesize queryText = _queryText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.apiEndpoint = GTIORestResourcePath(@"/categories");
        self.variableHeightRows = YES;
        self.autoresizesForKeyboard = YES;
        self.view.accessibilityLabel = @"Browse Screen";
    }
    return self;
}

- (id)initWithAPIEndpoint:(NSString*)endpoint {
    if ((self = [self initWithNibName:nil bundle:nil])) {
        endpoint = [endpoint stringByReplacingOccurrencesOfString:@"." withString:@"/"];
        self.apiEndpoint = endpoint;
        NSLog(@"Endpoint: %@", endpoint);
    }
    return self;
}

- (id)initWithAPIEndpoint:(NSString*)endpoint searchText:(NSString*)text {
    if ((self = [self initWithAPIEndpoint:endpoint])) {
        _queryText = [text retain];
    }
    return self;
}

- (void)dealloc {
    [_searchBar release];
    [_apiEndpoint release];
    [_queryText release];
    [_sortTabs release];
    [super dealloc];
}

- (TTTableViewDelegate*)createDelegate {
    return [[[GTIODropShadowSectionTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_queryText, @"query", nil]; // note, query text is usually nil. only used if we are searching.
	
    GTIOBrowseListTTModel* model = [[[GTIOBrowseListTTModel alloc] initWithResourcePath:_apiEndpoint
                                                                                 params:[GTIOUser paramsByAddingCurrentUserIdentifier:params]
                                                                                 method:RKRequestMethodPOST] autorelease];
    
    TTListDataSource* temporaryDataSource = [TTListDataSource dataSourceWithObjects:nil];
    temporaryDataSource.model = model;
    self.dataSource = temporaryDataSource;
}

- (void)didLoadMore {
    NSLog(@"DidLoadMore");
    GTIOBrowseListDataSource* ds = (GTIOBrowseListDataSource*)self.dataSource;
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    
    NSAssert(model.list.outfits || model.list.myLooks, @"Only know how to paginate lists of outfits currently.");
    
    [self.tableView beginUpdates];
    NSMutableArray* items = [[model.objects mutableCopy] autorelease];
    for (GTIOOutfitTableViewItem* item in ds.items) {
        [items removeObject:item.outfit];
    }
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (id object in items) {
        if ([object isKindOfClass:[GTIOOutfit class]]) {
            GTIOOutfit* outfit = (GTIOOutfit*)object;
            GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
            [ds.items addObject:item];
            [indexPaths addObject:[NSIndexPath indexPathForRow:[ds.items indexOfObject:item] inSection:0]];
        }
        // TODO: handle GTIOReview
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    if (model.list.searchAPI) {
        NSString* url = [NSString stringWithFormat:@"gtio://browse/%@/%@",
                         [model.list.searchAPI stringByReplacingOccurrencesOfString:@"/" withString:@"."],
                         [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        TTOpenURL(url);
        
    }
}

- (void)setupTabs:(NSArray*)tabs {
    [_sortTabs release];
    _sortTabs = [tabs retain];
    if (tabs && [tabs count] > 0) {
        // throw away the old tab bar, setup a new one.
        [_sortTabBar removeFromSuperview];
        [_sortTabBar release];
        NSLog(@"Sort Tabs: %@", tabs);
        _sortTabBar = [[GTIOTabBar alloc] initWithFrame:CGRectMake(0,0,320,37)];
        [_sortTabBar setTabNames:[tabs valueForKey:@"sortText"]];
        for (GTIOSortTab* tab in tabs) {
            if ([tab.selected boolValue] == YES) {
                [_sortTabBar setSelectedTabIndex:[tabs indexOfObject:tab]];
            }
        }
        _sortTabBar.delegate = self;
        [self.view addSubview:_sortTabBar];
        self.tableView.frame = CGRectMake(0,_sortTabBar.bounds.size.height,320,self.view.bounds.size.height - _sortTabBar.bounds.size.height);
        _topShadowImageView.frame = CGRectMake(0,_sortTabBar.bounds.size.height,320, 10);
    } else {
        self.tableView.frame = self.view.bounds;
        _topShadowImageView.frame = CGRectMake(0,0,320, 10);
    }
}

- (void)setupDataSourceForAlphabeticalCategoriesWithList:(GTIOBrowseList*)list andSearchText:(NSString*)text {
    GTIOSectionedDataSourceWithIndexSidebar* ds = (GTIOSectionedDataSourceWithIndexSidebar*)[GTIOSectionedDataSourceWithIndexSidebar dataSourceWithItems:[NSMutableArray array] sections:[NSMutableArray array]];
    NSArray* sections = list.alphabeticalListKeys;
    NSDictionary* dict = [list tableItemsGroupedAlphabeticallyWithFilterText:text];
    for (NSString* key in sections) {
        NSMutableArray* obj = [dict objectForKey:key];
        if (obj) {
            [ds.sections addObject:key];
            [ds.items addObject:obj];
        }
    }
    ds.model = self.model;
    self.dataSource = ds;
}

- (void)setupDataSourceWithList:(GTIOBrowseList*)list items:(NSMutableArray*)items {
    if (list.subtitle) {
        TTSectionedDataSource* ds = [GTIOBrowseSectionedDataSource dataSourceWithArrays:list.subtitle, items, nil];
        ds.model = self.model;
        self.dataSource = ds;
    } else {
        TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:items];
        ds.model = self.model;
        self.dataSource = ds;
    }
}

- (void)loadedList:(GTIOBrowseList*)list {
    if (list) {
        self.title = list.title;
        
        if (nil == _searchBar) {
            _searchBar = [list.searchBar retain];
            _searchBar.delegate = self;
            self.tableView.tableHeaderView = _searchBar;
        }
        
        [self.tableView setContentInset:UIEdgeInsetsMake(8, 0, 0, 0)];
        
        // TODO: this should be refactored into the list model.
        [self setupTabs:list.sortTabs];
        
        if (list.categories) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            if ([list.includeAlphaNav boolValue]) {
                _topShadowImageView.frame = CGRectZero;
                // Uses alphabetical indexes along the sidebar
                [self setupDataSourceForAlphabeticalCategoriesWithList:list andSearchText:_searchBar.text];
                return;
            }
        }
        NSMutableArray* items = [[list.tableItems mutableCopy] autorelease];
        [self setupDataSourceWithList:list items:items];
    } else {
        // no list was loaded. hrm...
        [self.model performSelector:@selector(didFailLoadWithError:) withObject:[NSError errorWithDomain:@"GTIO Error" code:0 userInfo:nil]];
    }
}

- (void)loadView {
    [super loadView];
    UIImage* topShadow = [UIImage imageNamed:@"list-top-shadow.png"];
    _topShadowImageView = [[[UIImageView alloc] initWithImage:topShadow] autorelease];\
    [self.view addSubview:_topShadowImageView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // When we reappear, we are called back with didLoadModel:YES instead of NO
    // since we didn't really load more. This causes us to think this is the 'firstTime', and call didLoadModel:YES
    _flags.isModelDidLoadFirstTimeInvalid = 1;
}

- (void)didLoadModel:(BOOL)firstTime {
    if (firstTime) {
        NSLog(@"Loaded First Time!");
        GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
        [self loadedList:model.list];
    } else {
        [self didLoadMore];
    }
}

- (void)tabBar:(GTIOTabBar*)tabBar selectedTabAtIndex:(NSUInteger)index {
    GTIOSortTab* tab = [_sortTabs objectAtIndex:index];
    if (tab) {
        [_apiEndpoint release];
        _apiEndpoint = [tab.sortAPI retain];
        [self invalidateModel];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    if (nil == model.list.searchAPI) {
        // Recreates the data source. Search bar is not recreated, and the data source is filtered.
        // calling didStartLoad first ensures that 'firstTime' is true.
        [model didStartLoad];
        [model didFinishLoad];
    }
} 

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if ([object isKindOfClass:[GTIOUserReviewTableItem class]] ||
        [object isKindOfClass:[GTIOOutfitTableViewItem class]]) {
        GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:self.model outfitIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else {
        [super didSelectObject:object atIndexPath:indexPath];
    }
}

@end
