//
//  GTIOCommentViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOCommentViewController.h"
#import "GTIOUser.h"

@interface GTIOCommentViewController ()

@property (nonatomic, strong) UIImageView *commentInputBackgroundImage;
@property (nonatomic, strong) UITextView *commentInputView;

@end

@implementation GTIOCommentViewController

@synthesize commentInputView = _commentInputView, commentInputBackgroundImage = _commentInputBackgroundImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"comment" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;
    
    GTIOUIButton *saveButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeSaveGreenTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.rightNavigationButton = saveButton;
    
    self.commentInputBackgroundImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"reviews.cell.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0f, 5.0f, 7.0f, 5.0f)]];
    [self.commentInputBackgroundImage setFrame:(CGRect){ 6, 6, 308, 190 }];
    self.commentInputBackgroundImage.userInteractionEnabled = YES;
    [self.view addSubview:self.commentInputBackgroundImage];
    
    self.commentInputView = [[UITextView alloc] initWithFrame:(CGRect){ 3, 5, self.commentInputBackgroundImage.bounds.size.width - 6, self.commentInputBackgroundImage.bounds.size.height - 11 }];
    self.commentInputView.backgroundColor = [UIColor clearColor];
    [self.commentInputBackgroundImage addSubview:self.commentInputView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.commentInputView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
