//
//  GTIOBrowseTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOBrowseTableViewController.h"
#import "GTIOCategory.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOOutfitTableViewCell.h"
#import "GTIOGiveAnOpinionTableViewDataSource.h"
#import "GTIOPaginationTableViewDelegate.h"
#import "GTIOSortTab.h"

@interface GTIOBrowseListDataSource : TTListDataSource
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
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

- (NSString*)titleForEmpty {
	return @"Nothing Here";
}

@end

@interface GTIOBrowseSectionedDataSource: TTSectionedDataSource
@end
@implementation GTIOBrowseSectionedDataSource
@end

@interface GTIOSectionedDataSourceWithIndexSidebar : GTIOBrowseSectionedDataSource
@end

@implementation GTIOSectionedDataSourceWithIndexSidebar

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
    [super dealloc];
}

- (TTTableViewDelegate*)createDelegate {
    return [[[GTIOPaginationTableViewDelegate alloc] initWithController:self] autorelease];
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

- (void)fail {
    [self.model performSelector:@selector(didFailLoadWithError:) withObject:[NSError errorWithDomain:@"GTIO Error" code:0 userInfo:nil]];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    [self fail];
}
- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader*)objectLoader {
    [self fail];
}

- (void)didLoadMore {
    NSLog(@"DidLoadMore");
    GTIOBrowseListDataSource* ds = (GTIOBrowseListDataSource*)self.dataSource;
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    
    [self.tableView beginUpdates];
    NSMutableArray* items = [[model.objects mutableCopy] autorelease];
    for (GTIOOutfitTableViewItem* item in ds.items) {
        [items removeObject:item];
    }
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (GTIOOutfit* outfit in items) {
        GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
        [ds.items addObject:item];
        [indexPaths addObject:[NSIndexPath indexPathForRow:[ds.items indexOfObject:item] inSection:0]];
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

- (void)loadedList:(GTIOBrowseList*)list {
    // TODO: simplify/refactor this.
    if (list) {
        self.title = list.title;
        // Search
        if ([list.includeSearch boolValue]) {
            if (nil == _searchBar) {
                // create search bar
                _searchBar = [[UISearchBar alloc] init];
                [_searchBar sizeToFit];
                _searchBar.delegate = self;
            }
            _searchBar.placeholder = list.searchText;
            if ([list.includeAlphaNav boolValue]) {
                [_searchBar setContentInset:UIEdgeInsetsMake(5, 0, 5, 35)];
            } else {
                [_searchBar setContentInset:UIEdgeInsetsMake(5, 0, 5, 0)];
            }
            self.tableView.tableHeaderView = _searchBar;
        } else {
            self.tableView.tableHeaderView = nil;
        }
        
        if (list.categories) {
            // Load a category or subcategory list!
            NSMutableArray* categories = [NSMutableArray array];
            if (_searchBar.text && [_searchBar.text length] > 0) {
                for (GTIOCategory* category in list.categories) {
                    if ([[category.name uppercaseString] rangeOfString:[_searchBar.text uppercaseString]].length > 0) {
                        [categories addObject:category];
                    }
                }
            } else {
                categories = [[list.categories mutableCopy] autorelease];
            }
            
            // Setup Table View
            if ([list.includeAlphaNav boolValue]) {
                NSArray* sections = [@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,#" componentsSeparatedByString:@","];
                NSMutableDictionary* dict = [NSMutableDictionary dictionary];
                for (GTIOCategory* category in categories) {
                    NSString* upcasedFirstCharacterOfName = [[category.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                    if ([sections indexOfObject:upcasedFirstCharacterOfName] == NSNotFound) {
                        upcasedFirstCharacterOfName = @"#";
                    }
                    NSMutableArray* items = [dict objectForKey:upcasedFirstCharacterOfName];
                    if (nil == items) {
                        items = [NSMutableArray array];
                        [dict setObject:items forKey:upcasedFirstCharacterOfName];
                    }
                    NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [category.apiEndpoint stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
                    TTTableTextItem* item = [TTTableTextItem itemWithText:category.name URL:url];
                    [items addObject:item];
                }
                GTIOSectionedDataSourceWithIndexSidebar* ds;
                if ([self.dataSource isKindOfClass:[GTIOSectionedDataSourceWithIndexSidebar class]]) {
                    ds = self.dataSource;
                    [ds.items removeAllObjects];
                    [ds.sections removeAllObjects];
                } else {
                    ds = (GTIOSectionedDataSourceWithIndexSidebar*)[GTIOSectionedDataSourceWithIndexSidebar dataSourceWithItems:[NSMutableArray array] sections:[NSMutableArray array]];
                }
                for (NSString* key in sections) {
                    NSMutableArray* obj = [dict objectForKey:key];
                    NSLog(@"OBJ: %@", obj);
                    if (obj) {
                        [ds.sections addObject:key];
                        [ds.items addObject:obj];
                    }
                }
                ds.model = self.model;
                self.dataSource = ds;
            } else {
                NSMutableArray* items = [NSMutableArray array];
                for (GTIOCategory* category in categories) {
                    NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [category.apiEndpoint stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
                    NSLog(@"URL: %@", url);
                    TTTableTextItem* item = [TTTableTextItem itemWithText:category.name URL:url];
                    [items addObject:item];
                }
                
                // TODO: show search bar if used. 
                
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
        } else if (list.outfits) {
            // Load an outfit list! (possibly with sort tabs)
            if (list.sortTabs && [list.sortTabs count] > 0) {
                // throw away the old tab bar, setup a new one.
                [_sortTabBar removeFromSuperview];
                [_sortTabBar release];
                NSLog(@"Sort Tabs: %@", list.sortTabs);
                _sortTabBar = [[TTTabBar alloc] initWithFrame:CGRectMake(0,0,320,30)];
                NSMutableArray* items = [NSMutableArray array];
                id selectedTab = [list.sortTabs objectAtIndex:0];
                for (GTIOSortTab* tab in list.sortTabs) {
                    [items addObject:[[[TTTabItem alloc] initWithTitle:tab.sortText] autorelease]];
                    if ([tab.selected boolValue] == YES) {
                        selectedTab = tab;
                    }
                }
                [_sortTabBar setTabItems:items];
                _sortTabBar.selectedTabIndex = [list.sortTabs indexOfObject:selectedTab];
                _sortTabBar.delegate = self;
                [self.view addSubview:_sortTabBar];
                self.tableView.frame = CGRectMake(0,50,320,self.view.bounds.size.height - _sortTabBar.bounds.size.height);
            } else {
                self.tableView.frame = self.view.bounds;
            }
            NSMutableArray* items = [NSMutableArray array];
            for (GTIOOutfit* outfit in list.outfits) {
                GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
                [items addObject:item];
            }
            TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:items];
            ds.model = self.model;
            self.dataSource = ds;
        } else {
            TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:[NSMutableArray array]];
            ds.model = self.model;
            self.dataSource = ds;
        }
    } else {
        // no list was loaded. hrm...
        [self fail];
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

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex {
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    GTIOSortTab* tab = [model.list.sortTabs objectAtIndex:selectedIndex];
    [_apiEndpoint release];
    _apiEndpoint = [tab.sortAPI retain];
    [self invalidateModel];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    if (nil == model.list.searchAPI) {
        [model didStartLoad];
        [model didFinishLoad];
        // TODO: figure out how to perform local search
    }
}

@end
