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
#import "GTIOOutfitVerdictTableItem.h"
#import "GTIOOutfitVerdictTableItemCell.h"
#import "GTIOGiveAnOpinionTableViewDataSource.h"
#import "GTIODropShadowSectionTableViewDelegate.h"
#import "GTIOSortTab.h"
#import "GTIOOutfitViewController.h"
#import <RestKit/RestKit.h>
#import "GTIOReview.h"
#import "GTIOUserReviewTableItem.h"
#import "GTIOUserReviewTableItemCell.h"
#import "GTIOBrowseListPresenter.h"
#import "GTIOListSection.h"
#import "GTIOStaticOutfitListModel.h"
#import "GTIOHeaderView.h"

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
    if ([object isKindOfClass:[GTIOOutfitVerdictTableItem class]]) {
        return [GTIOOutfitVerdictTableItemCell class];
    } else if ([object isKindOfClass:[GTIOOutfitTableViewItem class]]) {
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullToRefreshActivated:) name:@"DragRefreshTableReload" object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_presenter release];
    [_searchBar release];
    [_bannerAd release];
    [_apiEndpoint release];
    [_queryText release];
    [_sortTabs release];
    [super dealloc];
}

- (void)pullToRefreshActivated:(NSNotification*)note {
    GTIOAnalyticsEvent(kGTIOListRefreshEventName);
    _flags.isModelDidLoadFirstTimeInvalid = 1;
}

- (void)reloadButtonWasPressed:(id)sender {
    GTIOAnalyticsEvent(kGTIOListRefreshEventName);    
    _flags.isModelDidLoadFirstTimeInvalid = 1;
    [self invalidateModel];
}

- (void)showEmpty:(BOOL)show {
    if (show) {
        
        NSString* title = _presenter.titleForEmptyList;
        UILabel* titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,170,320,20)] autorelease];
        titleLabel.font = kGTIOFontHelveticaNeueOfSize(15);
        titleLabel.textColor = RGBCOLOR(130,130,130);
        titleLabel.text = title;
        titleLabel.textAlignment = UITextAlignmentCenter;
        
        UIImage* image = [UIImage imageNamed:@"empty-list.png"];
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(floor(320 - imageView.frame.size.width) / 2,75,imageView.frame.size.width, imageView.frame.size.height);
        
        UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* off = [UIImage imageNamed:@"list-refresh-OFF.png"];
        UIImage* on = [UIImage imageNamed:@"list-refresh-ON.png"];
        [reloadButton setImage:off forState:UIControlStateNormal];
        [reloadButton setImage:on forState:UIControlStateHighlighted];
        reloadButton.frame = CGRectMake((320-120)/2,248,120,58);
        [reloadButton addTarget:self action:@selector(reloadButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* emptyView = [[[UIView alloc] initWithFrame:self.tableView.frame] autorelease];
        emptyView.backgroundColor = [UIColor clearColor];
        
        [emptyView addSubview:titleLabel];
        [emptyView addSubview:imageView];
        [emptyView addSubview:reloadButton];
        
        self.emptyView = emptyView;
        
        _tableView.dataSource = nil;
        [_tableView reloadData];
        
    } else {
        self.emptyView = nil;
    }
}

- (TTTableViewDelegate*)createDelegate {
    GTIODropShadowSectionTableViewDelegate* delegate = [[[GTIODropShadowSectionTableViewDelegate alloc] initWithController:self] autorelease];
    return delegate;
}

- (RKObjectLoader*)objectLoader {
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:_apiEndpoint delegate:nil];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_queryText, @"query", nil]; // note, query text is usually nil. only used if we are searching.
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.cacheTimeoutInterval = 60*5; // 5 minutes
    return objectLoader;
}

- (void)createModel {
    RKObjectLoader* objectLoader = [self objectLoader];
    GTIOBrowseListTTModel* model = [GTIOBrowseListTTModel modelWithObjectLoader:objectLoader];
    
    TTListDataSource* temporaryDataSource = [TTListDataSource dataSourceWithObjects:nil];
    temporaryDataSource.model = model;
    self.dataSource = temporaryDataSource;
    
    // Recreate the delegate, since we updated the model because the delegate assigns itself as a delegate of the model.
    TTTableViewDragRefreshDelegate* del = (TTTableViewDragRefreshDelegate*)self.tableView.delegate;
    [del.headerView removeFromSuperview];
    self.tableView.delegate = nil;
    [self performSelector:@selector(updateTableDelegate) withObject:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    GTIOAnalyticsEvent(kSearch);
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    if (model.list.searchAPI) {
        NSString* url = [NSString stringWithFormat:@"gtio://browse/%@/%@",
                         [model.list.searchAPI stringByReplacingOccurrencesOfString:@"/" withString:@"."],
                         [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        TTOpenURL(url);
        
    }
}

- (void)rightBarButtonItemPressed:(id)sender {
    if (_presenter.list.topRightButton.url) {
        TTOpenURL(_presenter.list.topRightButton.url);
    }
}

- (void)setupRightBarButtonItem {
    if (_presenter.list.topRightButton.text) {
        self.navigationItem.rightBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:_presenter.list.topRightButton.text target:self action:@selector(rightBarButtonItemPressed:)] autorelease];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setupTabsAndBannerAd {
    [_sortTabs release];
    _sortTabs = [_presenter.tabs retain];
    
    [_bannerAd release];
    _bannerAd = [_presenter.bannerAd retain];
    [self.view addSubview:_bannerAd];
    float adHeight = (_bannerAd ? _bannerAd.bounds.size.height : 0);
    
    if (_sortTabs && [_sortTabs count] > 0) {
        [_sortTabBar removeFromSuperview];
        [_sortTabBar release];
        _sortTabBar = [[GTIOTabBar alloc] initWithFrame:CGRectMake(0,adHeight,320,37)];
        [_sortTabBar setTabNames:_presenter.tabNames];
        for (GTIOSortTab* tab in _sortTabs) {
            int index = [_sortTabs indexOfObject:tab];
            if ([tab.selected boolValue] == YES) {
                [_sortTabBar setSelectedTabIndex:index];
                _sortTabBar.subtitle = tab.subtitle;
            }
            GTIOTab* sortTab = [_sortTabBar.tabs objectAtIndex:index];
            if ([tab respondsToSelector:@selector(badgeNumber)]) {
                sortTab.badge = [tab badgeNumber];
            }
        }
        _sortTabBar.delegate = self;
        [self.view addSubview:_sortTabBar];
        float yOffset = CGRectGetMaxY(_sortTabBar.frame);
        self.tableView.frame = CGRectMake(0,yOffset,320,self.view.bounds.size.height - yOffset);
        _topShadowImageView.frame = CGRectMake(0,_sortTabBar.bounds.size.height,320, 10);
    } else {
        self.tableView.frame = CGRectMake(0,adHeight,self.view.bounds.size.width, self.view.bounds.size.height - adHeight);
        _topShadowImageView.frame = CGRectMake(0,0,320, 10);
    }
}

- (void)setupDataSourceForAlphabeticalCategoriesWithList:(GTIOBrowseList*)list andSearchText:(NSString*)text {
    GTIOSectionedDataSourceWithIndexSidebar* ds = (GTIOSectionedDataSourceWithIndexSidebar*)[GTIOSectionedDataSourceWithIndexSidebar dataSourceWithItems:[NSMutableArray array] sections:[NSMutableArray array]];
    NSArray* sections = _presenter.alphabeticalListKeys;
    NSDictionary* dict = [_presenter tableItemsGroupedAlphabeticallyWithFilterText:text];
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

- (void)setupDataSourceWithItems:(NSMutableArray*)items {
    BOOL requiresSectionedDataSource = [items count] > 0 && [[items objectAtIndex:0] isKindOfClass:[NSArray class]];
    if (requiresSectionedDataSource) {
        int count = 0;
        for (NSArray* a in items) {
            count += [a count];
        }
        if (count > 0) {
            TTSectionedDataSource* ds = [GTIOBrowseSectionedDataSource dataSourceWithItems:items sections:_presenter.sectionNames];
            ds.model = self.model;
            self.dataSource = ds;
        } else {
            TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:[NSArray array]];
            ds.model = self.model;
            self.dataSource = ds;
        }
    } else if (_presenter.subtitle) {
        TTSectionedDataSource* ds = [GTIOBrowseSectionedDataSource dataSourceWithArrays:_presenter.subtitle, items, nil];
        ds.model = self.model;
        self.dataSource = ds;
    } else {
        TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:items];
        ds.model = self.model;
        self.dataSource = ds;
    }
    if (_presenter.list.categories) {
        UIView* superView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)] autorelease];
        UIView* view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow-wallpaper.png"]] autorelease];
        view.backgroundColor = [UIColor clearColor];
        [superView addSubview:view];
        self.tableView.tableFooterView = superView;
    } else {
        self.tableView.tableFooterView = nil;
    }
}

- (void)didLoadMore {
    NSLog(@"DidLoadMore");
    GTIOBrowseListDataSource* ds = (GTIOBrowseListDataSource*)self.dataSource;
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    
    NSAssert(model.list.outfits || model.list.myLooks || model.list.reviews, @"Only know how to paginate lists of outfits currently.");
    
    [self.tableView beginUpdates];
    NSMutableArray* indexPaths = [NSMutableArray array];
    NSArray* tableItems;
    if (model.list.reviews) {
        NSMutableArray* reviews = [[model.objects mutableCopy] autorelease];
        
        for (GTIOOutfitTableViewItem* item in ds.items) {
            [reviews removeObject:item.userInfo];
        }
        
        tableItems = [_presenter tableItemsForReviews:reviews];
        
    } else {
        NSMutableArray* outfits = [[model.objects mutableCopy] autorelease];
        for (GTIOOutfitTableViewItem* item in ds.items) {
            [outfits removeObject:item.outfit];
        }
        if (model.list.myLooks) {
            tableItems = [_presenter tableItemsForMyLooks:outfits];
        } else {
            tableItems = [_presenter tableItemsForOutfits:outfits];
        }
    }
    for (id tableItem in tableItems) {
        [ds.items addObject:tableItem];
        [indexPaths addObject:[NSIndexPath indexPathForRow:[ds.items indexOfObject:tableItem] inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (void)loadedList:(GTIOBrowseList*)list {
    if (list) {
        [_presenter release];
        _presenter = [[GTIOBrowseListPresenter presenterWithList:list] retain];
        
        NSString* title = [list.title uppercaseString];

        // Analytics
        if (title) {
            if ([title isEqualToString:@"BROWSE"]) {
                GTIOAnalyticsEvent(kBrowseEventName);
            } else if ([title isEqualToString:@"TO-DO'S"] || [title isEqualToString:@"COMPLETED"]) {
                ; //special cases to avoid duplicate events
            } else if (list.categories) {
                GTIOAnalyticsEvent([kCategoryPageEventNamePrefix stringByAppendingString:title]);
            } else {
                GTIOAnalyticsEvent([kOutfitListPageEventNamePrefix stringByAppendingString:title]);
            }
        }

        self.title = list.title;
        self.navigationItem.titleView = [GTIOHeaderView viewWithText:title];
        
        if (nil == _searchBar) {
            _searchBar = [_presenter.searchBar retain];
            _searchBar.delegate = self;
            self.tableView.tableHeaderView = _searchBar;
        }
        
        [self setupTabsAndBannerAd];
        [self setupRightBarButtonItem];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (list.categories) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            if ([list.includeAlphaNav boolValue]) {
                _topShadowImageView.frame = CGRectZero;
                // Uses alphabetical indexes along the sidebar
                [self setupDataSourceForAlphabeticalCategoriesWithList:list andSearchText:_searchBar.text];
                return;
            }
        }
        if (list.sections) {
            _topShadowImageView.frame = CGRectZero;
        }
        NSMutableArray* items = [[_presenter.tableItems mutableCopy] autorelease];
        [self setupDataSourceWithItems:items];
    } else {
        // no list was loaded. hrm...
        [self.model performSelector:@selector(didFailLoadWithError:) withObject:[NSError errorWithDomain:@"GTIO Error" code:0 userInfo:nil]];
    }
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

- (void)tabBar:(GTIOTabBar*)tabBar selectedTabAtIndex:(NSUInteger)index {
    GTIOSortTab* tab = [_sortTabs objectAtIndex:index];
    if (tab) {
        // Analytics
        if ([tab.title isEqualToString:@"community"]) {
            GTIOAnalyticsEvent(kCommunityTodosEventName);
        } else if ([tab.title isEqualToString:@"completed"]) {
            GTIOAnalyticsEvent(kCompletedTodosEventName);
        }
        // Switch Endpoint
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
    GTIOBrowseList* list = [(GTIOBrowseListTTModel*)self.model list];
    if (list.sections) {
        // manage showing outfits from a sectioned list.
        GTIOListSection* section = [list.sections objectAtIndex:indexPath.section];
        GTIOStaticOutfitListModel* staticModel = [GTIOStaticOutfitListModel modelWithOutfits:section.outfits];
        GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:staticModel outfitIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else if ([object isKindOfClass:[GTIOUserReviewTableItem class]] ||
        [object isKindOfClass:[GTIOOutfitTableViewItem class]]) {
        GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:self.model outfitIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else {
        [super didSelectObject:object atIndexPath:indexPath];
    }
}

@end
