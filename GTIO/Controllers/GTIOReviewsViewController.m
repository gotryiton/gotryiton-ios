//
//  GTIOReviewsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReviewsViewController.h"
#import "GTIOReviewsTableViewHeader.h"
#import "GTIOPost.h"
#import "GTIOReviewsTableViewCell.h"
#import "GTIOReview.h"
#import "GTIOProgressHUD.h"
#import "GTIOPostMasonryEmptyStateView.h"
#import "GTIOCommentViewController.h"
#import "GTIOFullScreenImageViewer.h"

static CGFloat const kGITOReviewsEmptyViewPadding = -8.0f;
static CGFloat const kGITOReviewsTableHeaderHeight = 87.0f;

@interface GTIOReviewsViewController ()

@property (nonatomic, copy) NSString *postID;
@property (nonatomic, strong) GTIOPost *post;
@property (nonatomic, strong) NSMutableArray *reviews;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GTIOReviewsTableViewHeader *tableViewHeader;
@property (nonatomic, strong) GTIOPostMasonryEmptyStateView *emptyStateView;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, strong) GTIOFullScreenImageViewer *reviewPostPictureViewer;

@end

@implementation GTIOReviewsViewController

@synthesize postID = _postID, post = _post, tableView = _tableView, tableViewHeader = _tableViewHeader, reviews = _reviews, emptyStateView = _emptyStateView, tableFooterView = _tableFooterView, reviewPostPictureViewer = _reviewPostPictureViewer;

- (id)initWithPostID:(NSString *)postID
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _postID = postID;
        _reviews = [NSMutableArray array];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"comments" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;
    
    self.tableViewHeader = [[GTIOReviewsTableViewHeader alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, kGITOReviewsTableHeaderHeight }];
    __block typeof(self) blockSelf = self;
    self.tableViewHeader.commentButtonTapHandler = ^(id sender) {
        [blockSelf addComment];
    };
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.tableViewHeader;
    [self.view addSubview:self.tableView];
    
    self.tableFooterView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height - self.tableViewHeader.bounds.size.height  }];
    self.emptyStateView = [[GTIOPostMasonryEmptyStateView alloc] initWithFrame:CGRectZero title:@"be the first to\nsay something!" userName:nil locked:NO];
    [self.tableFooterView addSubview:self.emptyStateView];
    [self.emptyStateView setCenter:(CGPoint){ self.tableFooterView.bounds.size.width / 2, self.tableFooterView.frame.size.height / 2 + kGITOReviewsEmptyViewPadding }];

    UITapGestureRecognizer *emptyStateTapRecocgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addComment)];
    [self.emptyStateView addGestureRecognizer:emptyStateTapRecocgnizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.tableViewHeader = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadReviews];
}

- (void)loadReviews
{    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/reviews/on/%@", self.postID] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.reviews removeAllObjects];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOReview class]]) {
                    [self.reviews addObject:object];
                }
                if ([object isMemberOfClass:[GTIOPost class]]) {
                    self.post = (GTIOPost *)object;
                    [self.tableViewHeader setPost:self.post];
                    self.reviewPostPictureViewer = [[GTIOFullScreenImageViewer alloc] initWithPhotoURL:self.post.photo.mainImageURL];
                    self.tableViewHeader.postImageTapHandler = ^(id sender) {
                        [self.reviewPostPictureViewer show];
                    };
                }
            }
            if (self.reviews.count == 0) {
                self.tableView.tableFooterView = self.tableFooterView;
            }
            else {
                [self.emptyStateView removeFromSuperview];
            }
            [self.tableView reloadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)addComment{
    GTIOCommentViewController *commentViewController = [[GTIOCommentViewController alloc] initWithPostID:self.postID];
    [self.navigationController pushViewController:commentViewController animated:YES];
}

#pragma mark - GTIOReviewTableViewCellDelegate Methods

- (void)removeReview:(GTIOReview *)review
{
    NSUInteger indexOfReview = [self.reviews indexOfObject:review];
    [self.reviews removeObjectAtIndex:indexOfReview];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexOfReview inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UIView *)viewForSpinner
{
    return self.view;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOReview *review = (GTIOReview *)[self.reviews objectAtIndex:indexPath.row];
    return [GTIOReviewsTableViewCell heightWithReview:review];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"com.gtio.reviews.cell";
    
    GTIOReviewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GTIOReviewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOReviewsTableViewCell *theCell = (GTIOReviewsTableViewCell *)cell;
    [theCell setReview:[self.reviews objectAtIndex:indexPath.row]];
    [theCell setDelegate:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reviews.count;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
