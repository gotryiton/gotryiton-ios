//
//  GTIOFacebookInviteTableViewController.m
//  GTIO
//
//  Created by Duncan Lewis on 11/18/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOFacebookInviteTableViewController.h"

NSString* kGTIOFacebookInviteAPIEndpoint = @"/stylists/all-friends";

@interface GTIOFacebookInviteTableItem : TTTableImageItem
@property (nonatomic,retain) GTIOProfile* profile;
- (id)initWithProfile:(GTIOProfile*)profile;
@end

@implementation GTIOFacebookInviteTableItem
@synthesize profile = _profile;

- (id)initWithProfile:(GTIOProfile*)profile {
    self = [super init];
    if(self) {
        self.text = profile.displayName;
        self.imageURL = profile.profileIconURL;
        self.profile = profile;
    }
    return self;
}

@end

@interface GTIOFacebookInviteTableItemCell : TTTableImageItemCell {
    UIView* _imageBackground;
}
@end

@implementation GTIOFacebookInviteTableItemCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        _imageBackground = [UIView new];
        [_imageBackground setFrame:self.imageView2.frame];
        [_imageBackground setBackgroundColor:kGTIOColorE3E3E3];
        [[_imageBackground layer] setBorderColor:[kGTIOColorE3E3E3 CGColor]];
        [[_imageBackground layer] setBorderWidth:1];
        [[_imageBackground layer] setCornerRadius:2];
        [self.contentView insertSubview:_imageBackground belowSubview:_imageView2];
        [_imageBackground release];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // image is inset top and left by 4 pixels, and is square
    _imageView2.frame = CGRectMake(4, 4, self.height - 2*4, self.height - 2*4);
    [_imageBackground setFrame:TTRectInset(self.imageView2.frame, UIEdgeInsetsMake(-1, -1, -1, -1))];
    
    self.textLabel.frame = TTRectShift(self.textLabel.frame, - self.textLabel.frame.origin.x, 0);
    self.textLabel.frame = TTRectShift(self.textLabel.frame, _imageView2.width + kTableCellVPadding, 0);
}

- (void)setObject:(id)object {
    [super setObject:object];
    
    self.textLabel.font = TTSTYLEVAR(facebookInviteTableFont);
}

@end

@interface GTIOFacebookInviteTableViewDelegate : TTTableViewVarHeightDelegate
@end

@implementation GTIOFacebookInviteTableViewDelegate

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (NO == [tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
		return nil;
	}
	
	NSString* title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
	if (title.length > 0) {
		UILabel* label = [[UILabel alloc] init];
		label.text = title;
		label.font = [UIFont systemFontOfSize:12];
		label.textColor = RGBCOLOR(147,147,147);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[label sizeToFit];
		
		UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        container.backgroundColor = RGBCOLOR(227,227,227);
		[container addSubview:label];
        label.frame = CGRectOffset(label.frame, 5, 2);
		[label release];
		
		return container;
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(nil != [self tableView:tableView viewForHeaderInSection:section]) {
        return 20.0f;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

@end

@interface GTIOInviteFacebookFriendsSectionedListDataSource : TTSectionedDataSource
@end
@implementation GTIOInviteFacebookFriendsSectionedListDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOFacebookInviteTableItem class]]) {
        return [GTIOFacebookInviteTableItemCell class];
    } else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

@implementation GTIOFacebookInviteTableViewController

@synthesize facebookTitle;
@synthesize facebookInviteURL;

- (id)initWithInviteTitle:(NSString*)title inviteURL:(NSString*)inviteURL {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.variableHeightRows = YES;
        self.autoresizesForKeyboard = YES;
        
        self.facebookTitle = title;
        self.facebookInviteURL = inviteURL;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidEnd) name:kGTIOUserDidEndLoginProcess object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - TTTableView methods

- (void)loginDidEnd {
    // just logged in with facebook, reload table
    [self invalidateModel];
}

- (void)createModel {
    
    NSString* apiEndpoint = GTIORestResourcePath(kGTIOFacebookInviteAPIEndpoint);
    NSDictionary* params = [NSDictionary dictionary];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:apiEndpoint delegate:nil];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    objectLoader.cacheTimeoutInterval = 5*60;
    GTIOBrowseListTTModel* model = [GTIOBrowseListTTModel modelWithObjectLoader:objectLoader];
    
    GTIOInviteFacebookFriendsSectionedListDataSource* ds = (GTIOInviteFacebookFriendsSectionedListDataSource*)[GTIOInviteFacebookFriendsSectionedListDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [_searchBar resignFirstResponder];
    
    GTIOFacebookInviteTableItem* item = (GTIOFacebookInviteTableItem*)object;
    
    if([GTIOUser currentUser].facebook == nil) {
        [[GTIOUser currentUser] loginWithFacebook];
    }
    
    NSLog(@"facebook id: %@", item.profile.facebookId);
    
    NSLog(@"stuff: %@, %@", self.facebookTitle, self.facebookInviteURL);
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kGTIOFacebookAppID, @"app_id",
                                   self.facebookInviteURL, @"link",
                                   item.profile.facebookId, @"to",
                                   nil];
    
    [[GTIOUser currentUser].facebook dialog:@"feed" andParams:params andDelegate:nil];
}

- (id)createDelegate {
    return [[[GTIOFacebookInviteTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)didLoadModel:(BOOL)firstTime {
    if (firstTime) {
        NSLog(@"Loaded First Time!");
        GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
        [self loadedList:model.list];
    } else {
        [self.model didLoadMore];
    }
}

- (void)loadedList:(GTIOBrowseList*)list {
    if (list) {
        
        NSString* title = [list.title uppercaseString];
        
        // Analytics ?
        
        self.title = list.title;
        self.navigationItem.titleView = [GTIOHeaderView viewWithText:title];
        
        if (nil == _searchBar) {
            _searchBar = [self searchBarForList:list];
            _searchBar.delegate = self;
            self.tableView.tableHeaderView = _searchBar;
        }
            
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
            NSMutableArray* items = [self tableItemsFromList:list withSearchText:_searchBar.text];
            
            TTSectionedDataSource* ds = (GTIOInviteFacebookFriendsSectionedListDataSource*)[GTIOInviteFacebookFriendsSectionedListDataSource dataSourceWithArrays:list.subtitle, items, nil];
            ds.model = self.model;
            self.dataSource = ds;
        }
    
    } else {
        // no list was loaded. hrm...
        [self.model performSelector:@selector(didFailLoadWithError:) withObject:[NSError errorWithDomain:@"GTIO Error" code:0 userInfo:nil]];
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"FACEBOOK INVITE"];
}

#pragma mark - Search Bar stuff

- (UISearchBar*)searchBarForList:(GTIOBrowseList *)list {
    UISearchBar* searchBar = [[UISearchBar alloc] init];
    searchBar.tintColor = RGBCOLOR(212,212,212);
    [searchBar sizeToFit];

    searchBar.placeholder = @"search names";

    if ([list.includeAlphaNav boolValue]) {
        [(UIScrollView*)searchBar setContentInset:UIEdgeInsetsMake(5, 0, 5, 35)];
    } else {
        [(UIScrollView*)searchBar setContentInset:UIEdgeInsetsMake(5, 0, 5, 0)];
    }
    return searchBar;
}

- (NSMutableArray*)tableItemsForStylists:(NSArray*)stylists {
    NSMutableArray* items = [NSMutableArray array];
    for (GTIOProfile* profile in stylists) {
        GTIOFacebookInviteTableItem* item = [[[GTIOFacebookInviteTableItem alloc] initWithProfile:profile] autorelease];
        [items addObject:item];
    }
    return items;
}

- (NSMutableArray*)tableItemsFromList:(GTIOBrowseList*)list withSearchText:(NSString*)searchText {
    NSLog(@"Searching For Text: %@", searchText);
    if (list.stylists) {
        NSMutableArray* matchingItems = [list stylistsFilteredWithText:searchText];
        return [self tableItemsForStylists:matchingItems];
    }
    return [NSMutableArray array];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Recreates the data source. Search bar is not recreated, and the data source is filtered.
    // calling didStartLoad first ensures that 'firstTime' is true.
    [self.model didStartLoad];
    [self.model didFinishLoad];
} 

@end
