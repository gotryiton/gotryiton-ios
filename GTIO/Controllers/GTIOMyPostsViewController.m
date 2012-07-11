//
//  GTIOMyPostsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMyPostsViewController.h"
#import "GTIOProgressHUD.h"
#import <RestKit/RestKit.h>
#import "GTIOUser.h"
#import "GTIOPostMasonryView.h"
#import "GTIOProgressHUD.h"

@interface GTIOMyPostsViewController ()

@property (nonatomic, strong) GTIOPostMasonryView *postMasonGrid;
@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, assign) GTIOPostType postsType;
@property (nonatomic, copy) NSString *userID;

@end

@implementation GTIOMyPostsViewController

@synthesize postMasonGrid = _postMasonGrid, posts = _posts, postsType = _postsType, userID = _userID;

- (id)initWithGTIOPostType:(GTIOPostType)postsType forUserID:(NSString *)userID
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _postsType = postsType;
        _userID = (userID.length > 0) ? userID : [GTIOUser currentUser].userID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title;
    if (self.postsType == GTIOPostTypeNone) {
        title = [NSString stringWithFormat:@"%@posts", ([self.userID isEqualToString:[GTIOUser currentUser].userID]) ? @"my " : @""];
    } else if (self.postsType == GTIOPostTypeStar) {
        title = [NSString stringWithFormat:@"%@stars", ([self.userID isEqualToString:[GTIOUser currentUser].userID]) ? @"my " : @""];
    }
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:title italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        [self.postMasonGrid.masonGridView cancelAllItemDownloads];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    self.postMasonGrid = [[GTIOPostMasonryView alloc] initWithGTIOPostType:self.postsType];
    [self.postMasonGrid setFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height }];
    [self.view addSubview:self.postMasonGrid];
    
    self.posts = [NSMutableArray array];
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *resourcePath = [NSString stringWithFormat:@"posts/by-user/%@", self.userID];
    if (self.postsType == GTIOPostTypeStar) {
        resourcePath = [NSString stringWithFormat:@"posts/stars-by-user/%@", self.userID];
    }
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOPost class]]) {
                    [self.posts addObject:object];
                }
            }
            [self.postMasonGrid setPosts:self.posts user:[GTIOUser currentUser]];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.postMasonGrid = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
