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
#import "GTIOOutfitViewController.h"
#import "GTIOHeaderView.h"

@implementation GTIOTodosTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.apiEndpoint = GTIORestResourcePath(@"/todos");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userVotedNotification:) name:kGTIOOutfitVoteNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"TO-DO'S"];
    
    GTIOUser* user = [GTIOUser currentUser];
    if (user.loggedIn && [user.istyleCount intValue] > 0) {
        GTIOBarButtonItem* whoIStyleItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"who i style" target:self action:@selector(whoIStyleButtonPressed:)] autorelease];
        self.navigationItem.rightBarButtonItem = whoIStyleItem;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupRightBarButtonItem {
    ; // Override. always show "who i style" or nothing.
}

- (void)whoIStyleButtonPressed:(id)sender {
    TTOpenURL(@"gtio://whoIStyle");
}

- (RKObjectLoader*)objectLoader {
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:_apiEndpoint delegate:nil];
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    objectLoader.method = RKRequestMethodPOST;
//    objectLoader.cacheTimeoutInterval = 60*5; // 5 minutes
    return objectLoader;
}

- (void)createModel {
    [super createModel];
}

- (void)userVotedNotification:(NSNotification*)note {
    if ([self.dataSource isKindOfClass:[GTIOBrowseListDataSource class]]) {
        GTIOBrowseListDataSource* ds = (GTIOBrowseListDataSource*)self.dataSource;
        NSString* outfitID = (NSString*)note.object;
        GTIOOutfitTableViewItem* itemToDelete = nil;
        for (GTIOOutfitTableViewItem* item in ds.items) {
            if([item.outfit.outfitID isEqualToString:outfitID]) {
                itemToDelete = item;
                break;
            }
        }
        if (itemToDelete) {
            [self.tableView beginUpdates];
            
            NSIndexPath* ip = [NSIndexPath indexPathForRow:[ds.items indexOfObject:itemToDelete] inSection:0];
            [ds.items removeObject:itemToDelete];
            
            NSMutableArray* outfits = [[[[(GTIOBrowseListTTModel*)ds.model list] outfits] mutableCopy] autorelease];
            [outfits removeObjectAtIndex:ip.row];
            [[(GTIOBrowseListTTModel*)ds.model list] setOutfits:outfits];
            
            [ds.model setObjects:outfits];
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView endUpdates];
        }
    }
}

- (void)showEmpty:(BOOL)show {
    if ([[(GTIOTab*)_sortTabBar.selectedTab titleLabel].text isEqualToString:@"COMPLETED"]) {
        [super showEmpty:show];
        return;
    }
    if (show) {
        NSLog(@"Show empty:%d iStyleCount: %@", show, [GTIOUser currentUser].istyleCount);
        
        UIImage* image = [UIImage imageNamed:@"todos-empty-no-looks.png"];
        if ([[GTIOUser currentUser].istyleCount intValue] == 0 ) {
            image = [UIImage imageNamed:@"todos-empty-no-stylists.png"];
        }
        if ([[(GTIOTab*)_sortTabBar.selectedTab titleLabel].text isEqualToString:@"COMMUNITY"]) {
            image = [UIImage imageNamed:@"todos-community-empty-no-stylists"];
        }
        
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(floor(320 - imageView.frame.size.width) / 2,43,imageView.frame.size.width, imageView.frame.size.height);
        
        UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* off = [UIImage imageNamed:@"list-refresh-OFF.png"];
        UIImage* on = [UIImage imageNamed:@"list-refresh-ON.png"];
        [reloadButton setImage:off forState:UIControlStateNormal];
        [reloadButton setImage:on forState:UIControlStateHighlighted];
        reloadButton.frame = CGRectMake((320-120)/2,248,120,58);
        [reloadButton addTarget:self action:@selector(reloadButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* emptyView = [[[UIView alloc] initWithFrame:self.tableView.frame] autorelease];
        emptyView.backgroundColor = [UIColor clearColor];
        
        [emptyView addSubview:imageView];
        [emptyView addSubview:reloadButton];
        
        self.emptyView = emptyView;
        
    } else {
        self.emptyView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    GTIOAnalyticsEvent(kTodosPageEventName);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
