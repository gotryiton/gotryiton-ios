//
//  GTIOCommentViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOCommentViewController.h"
#import "GTIOAutoCompleteView.h"
#import "GTIOUser.h"
#import "GTIOReview.h"
#import "GTIOProgressHUD.h"

@interface GTIOCommentViewController ()

@property (nonatomic, copy) NSString *postID;

@property (nonatomic, strong) UIImageView *commentInputBackgroundImage;
@property (nonatomic, strong) GTIOAutoCompleteView *commentInputView;

@end

@implementation GTIOCommentViewController

@synthesize postID = _postID, commentInputView = _commentInputView, commentInputBackgroundImage = _commentInputBackgroundImage;

@synthesize saveButton;

- (id)initWithPostID:(NSString *)postID
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _postID = postID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"comment" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD hideHUDForView:self.commentInputView.textInput animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;

    
    self.commentInputBackgroundImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"reviews.cell.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0f, 5.0f, 7.0f, 5.0f)]];
    [self.commentInputBackgroundImage setFrame:(CGRect){ 6, 6, 308, 190 }];
    self.commentInputBackgroundImage.userInteractionEnabled = YES;
    [self.view addSubview:self.commentInputBackgroundImage];
    
    self.commentInputView = [[GTIOAutoCompleteView alloc] initWithFrame:(CGRect){ 16, 7, self.commentInputBackgroundImage.bounds.size.width - (12 * 2), self.commentInputBackgroundImage.bounds.size.height  } outerBox:(CGRect){0, 10, self.view.frame.size.width, self.view.frame.size.height } placeholder:@"That looks great! @Becky E." ];
    
    [self.commentInputView displayPlaceholderText];
    
    [self.view addSubview:self.commentInputView];
    self.commentInputView.textInput.delegate = self; 

    [GTIOAutoCompleter loadBrandDictionaryWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            NSMutableArray *brands = [[NSMutableArray alloc] init];
            for (GTIOAutoCompleter *completer in loadedObjects) {
                completer.type = @"b";
                [brands addObject:completer];
            }
            [self.commentInputView addCompleters:brands];
        }
    }];

    [GTIOAutoCompleter loadUsersDictionaryWithUserID:[GTIOUser currentUser].userID postID:self.postID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            NSMutableArray *users = [[NSMutableArray alloc] init];
            for (GTIOAutoCompleter *completer in loadedObjects) {
                completer.type = @"@";
                [users addObject:completer];
            }
            [self.commentInputView addCompleters:users];
        }
    }];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.commentInputView.textInput becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.commentInputBackgroundImage = nil;
    self.commentInputView = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL response = [self.commentInputView textView:textView shouldChangeTextInRange:range replacementText:text];

    if([text isEqualToString:@"\n"]) {
        
        [self.commentInputView resignFirstResponder];
        
        [self postComment];
        return NO;
    }
    
    if (self.commentInputView.textInput.text.length>0){
        self.rightNavigationButton = self.saveButton;
    }
    else {
        self.rightNavigationButton = nil;   
    }
    
    return response; 
}

- (void)postComment
{
    if ([self.commentInputView processDescriptionString].length>0){
        [GTIOProgressHUD showHUDAddedTo:self.commentInputView.textInput animated:YES];
        [GTIOReview postReviewComment:[self.commentInputView processDescriptionString] forPostID:self.postID completionHandler:^(NSArray *loadedObjects, NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.commentInputView.textInput animated:YES];
            if (!error) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There was an error while posting your comment, please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [self.commentInputView.textInput becomeFirstResponder];
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (GTIOUIButton *)saveButton {
    if (!saveButton) {
        saveButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeSaveGreenTopMargin tapHandler:^(id sender) {
            [self postComment];
        }];
        
    }
    return saveButton;
}


@end
