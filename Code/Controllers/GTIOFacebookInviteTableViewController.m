//
//  GTIOFacebookInviteTableViewController.m
//  GTIO
//
//  Created by Duncan Lewis on 11/18/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOFacebookInviteTableViewController.h"

const NSString* kGTIOFacebookInviteAPIEndpoint = @"/stylists/all-friends";

@interface GTIOFacebookInviteTableItem : TTTableImageItem
@property (nonatomic,retain) GTIOProfile* profile;
- (id)initWithProfile:(GTIOProfile*)profile;
@end

@implementation GTIOFacebookInviteTableItem
@synthesize profile = _profile;

- (id)initWithProfile:(GTIOProfile *)profile {
    self = [super init];
    if(self) {
        self.text = profile.displayName;
        self.imageURL = profile.profileIconURL;
    }
    return self;
}

@end


@interface GTIOInviteFacebookFriendsSectionedListDataSource : TTListDataSource
@end
@implementation GTIOInviteFacebookFriendsSectionedListDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOFacebookInviteTableItem class]]) {
        return [TTTableImageItemCell class];
    } else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@implementation GTIOFacebookInviteTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.variableHeightRows = YES;
        self.autoresizesForKeyboard = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - TTTableView methods

- (void)createModel {
    NSString* apiEndpoint = GTIORestResourcePath(kGTIOFacebookInviteAPIEndpoint);
    NSDictionary* params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:apiEndpoint delegate:nil];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    objectLoader.cacheTimeoutInterval = 5*60;
    GTIOBrowseListTTModel* model = [GTIOBrowseListTTModel modelWithObjectLoader:objectLoader];
    
    GTIOInviteFacebookFriendsSectionedListDataSource* ds = [GTIOInviteFacebookFriendsSectionedListDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
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

- (void)loadedList:(GTIOBrowseList*)list {
    if (list) {
        
        NSString* title = [list.title uppercaseString];
        
        // Analytics ?
        
        self.title = list.title;
        self.navigationItem.titleView = [GTIOHeaderView viewWithText:title];
        
        if (nil == _searchBar) {
            _searchBar = [self searchBar];
            _searchBar.delegate = self;
            self.tableView.tableHeaderView = _searchBar;
        }
        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        // The alpha nav stuff. Waiting response from simon
//        if (list.categories) {
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//            if ([list.includeAlphaNav boolValue]) {
//                _topShadowImageView.frame = CGRectZero;
//                // Uses alphabetical indexes along the sidebar
//                [self setupDataSourceForAlphabeticalCategoriesWithList:list andSearchText:_searchBar.text];
//                return;
//            }
//        }

        if(nil != list.stylists) {
            NSMutableArray* items = [[list.stylists.tableItems mutableCopy] autorelease];
            
            TTSectionedDataSource* ds = [GTIOInviteFacebookFriendsSectionedListDataSource dataSourceWithArrays:list.subtitle, items, nil];
            ds.model = self.model;
            self.dataSource = ds;
        }
        
        // General solution in GTIOBrowseTableViewController
//        [self setupDataSourceWithItems:items];
    
    } else {
        // no list was loaded. hrm...
        [self.model performSelector:@selector(didFailLoadWithError:) withObject:[NSError errorWithDomain:@"GTIO Error" code:0 userInfo:nil]];
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"FACEBOOK INVITE"];
    
    
}

#pragma mark - Search Bar stuff

- (UISearchBar*)searchBar {
    UISearchBar* searchBar = [[UISearchBar alloc] init];
    searchBar.tintColor = RGBCOLOR(212,212,212);
    [searchBar sizeToFit];

    searchBar.placeholder = @"search names";

    if ([_list.includeAlphaNav boolValue]) {
        [(UIScrollView*)searchBar setContentInset:UIEdgeInsetsMake(5, 0, 5, 35)];
    } else {
        [(UIScrollView*)searchBar setContentInset:UIEdgeInsetsMake(5, 0, 5, 0)];
    }
    return searchBar;
}

- (NSMutableArray*)tableItemsWithSearchText:(NSString*)searchText {
    NSLog(@"Searching For Text: %@", searchText);
    if (_list.stylists) {
        NSMutableArray* matchingItems = [_list stylistsFilteredWithText:searchText];
        return [self tableItemsForCategories:matchingItems];
    }
    return [NSMutableArray array];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Recreates the data source. Search bar is not recreated, and the data source is filtered.
    // calling didStartLoad first ensures that 'firstTime' is true.
    [model didStartLoad];
    [model didFinishLoad];
} 

@end
