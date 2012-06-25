//
//  GTIOPostALookDescriptionBox.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostALookDescriptionBox.h"
#import "GTIODoneToolBar.h"
#import "GTIOUser.h"

@interface GTIOPostALookDescriptionBox()

@property (nonatomic, strong) UIView *placeHolderView;
@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation GTIOPostALookDescriptionBox

@synthesize textView = _textView, placeHolderView = _placeHolderView, backgroundView = _backgroundView;
@synthesize textViewDidEndHandler = _textViewDidEndHandler, textViewWillBecomeActiveHandler = _textViewWillBecomeActiveHandler, textViewDidBecomeActiveHandler = _textViewDidBecomeActiveHandler;
@synthesize forceBecomeFirstResponder = _forceBecomeFirstResponder;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title icon:(UIImage *)icon
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"description-box.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 4.0, 4.0, 6.0, 4.0 }]];
        [self.backgroundView setFrame:(CGRect){ 6, 0, self.bounds.size.width- (6 * 2), self.bounds.size.height }];
        [self addSubview:self.backgroundView];
        
     
        self.textView = [[GTIOAutoCompleteView alloc] initWithFrame:(CGRect){ 16, 4, self.backgroundView.bounds.size.width - (16*2), self.backgroundView.bounds.size.height - 10 } withOuterBox:(CGRect){0, 4, self.frame.size.width, self.frame.size.height }];


        [GTIOAutoCompleter loadBrandDictionaryWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
            if (!error) {
                NSMutableArray *brands = [[NSMutableArray alloc] init];
                for (GTIOAutoCompleter *completer in loadedObjects) {
                    completer.type = @"b";
                    [brands addObject:completer];
                }
                [self.textView addCompleters:brands];
            }
        }];

        [GTIOAutoCompleter loadUsersDictionaryWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
            if (!error) {
                NSMutableArray *users = [[NSMutableArray alloc] init];
                for (GTIOAutoCompleter *completer in loadedObjects) {
                    completer.type = @"@";
                    [users addObject:completer];
                }
                [self.textView addCompleters:users];
            }
        } withUserId:[GTIOUser currentUser].userID ];

        [self addSubview:self.textView];
    }
    return self;
}

#pragma mark - UITextViewDelegate

// - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
// {
//     if([text isEqualToString:@"\n"]) {
//         if (self.textViewDidEndHandler) {
//             self.textViewDidEndHandler(self, YES);
//         } else {
//             [self.textView resignFirstResponder];
//         }
//         return NO;
//     }
//     return YES;
// }

// - (BOOL)textViewShouldBeginEditing:(UITextView *)textView
// {
//     if (self.textViewWillBecomeActiveHandler && !self.forceBecomeFirstResponder) {
//         [self setForceBecomeFirstResponder:YES];
//         self.textViewWillBecomeActiveHandler(self);
//         return NO;
//     } else {
//         [self setForceBecomeFirstResponder:NO];
//         return YES;
//     }
// }

// - (void)textViewDidBeginEditing:(UITextView *)textView
// {
//     if (self.textViewDidBecomeActiveHandler) {
//         self.textViewDidBecomeActiveHandler(self);
//     }
//     [self.textView setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
// }

// - (void)textViewDidEndEditing:(UITextView *)textView
// {
//     [self.textView setTextColor:[UIColor gtio_darkGrayTextColor]];
// }

// - (void)textViewDidChange:(UITextView *)textView
// {
//     if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
//         [self.placeHolderView removeFromSuperview];
//     } else {
//         [self addSubview:self.placeHolderView];
//     }
// }

@end
