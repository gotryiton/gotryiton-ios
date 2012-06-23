//
//  GTIOPostALookDescriptionBox.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostALookDescriptionBox.h"
#import "GTIODoneToolBar.h"

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
        
        

//        self.placeHolderView = [[UIView alloc] initWithFrame:(CGRect){ 5, 5, self.backgroundView.bounds.size.width - 10, 30 }];
//        [self addSubview:self.placeHolderView];
//        
//        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
//        [iconView setFrame:(CGRect){ self.backgroundView.bounds.size.width - iconView.bounds.size.width - 15, 5, iconView.bounds.size }];
//        [self.placeHolderView addSubview:iconView];
//        
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 7, 9, self.placeHolderView.bounds.size.width - iconView.bounds.size.width - 17, 15 }];
//        [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:12.0]];
//        [titleLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
//        [titleLabel setAlpha:0.5];
//        [titleLabel setText:title];
//        [titleLabel setBackgroundColor:[UIColor clearColor]];
//        [self.placeHolderView addSubview:titleLabel];
//                

        /**********************
        * FOR TESTING ONLY
        *********************/
        NSMutableArray *initoptions = [[NSMutableArray alloc] init];
        NSArray *names = [[NSArray alloc] initWithObjects: @"Matt V.", @"Rachit", @"Scott B", @"Scott P", @"simonholroyd", @"Marissa E", @"marissa", @"Amanda H", @"Caroline S", @"Jessie G", @"Abbey H", @"Amber M", @"Amberie J", @"American Blogger", nil];
        int i = 0;
        for (NSString *name in names){
            GTIOAutoCompleter *obj = [[GTIOAutoCompleter alloc] init];
            obj.name = name;
            obj.type = @"@";
            obj.icon = [[NSURL alloc] initWithString:@"http://stage.assets.gotryiton.s3.amazonaws.com/outfits/6cddd37ef45dc3c73d87dfb7b96de0c3_110_110.jpg"];
            obj.completer_id = [NSString stringWithFormat:@"id%i", i];
            [initoptions addObject: obj];
            i++;
        }
        
        NSArray *brands = [[NSArray alloc] initWithObjects:@"American Apparel", @"American Eagle", @"ASOS", @"Abercrombie & Fitch", @"Banana Republic", @"GAP", @"H&M", @"Sephora", @"Saks", @"Barneys", nil];
        
         for (NSString *name in brands){

            GTIOAutoCompleter *obj = [[GTIOAutoCompleter alloc] init];
            obj.name = name;
            obj.type = @"b";
            obj.completer_id = [NSString stringWithFormat:@"id%i", i];
            [initoptions addObject: obj];
            i++;
        }

        GTIOAutoCompleter *obj = [[GTIOAutoCompleter alloc] init];
            obj.name = @"Same Name";
            obj.type = @"@";
            obj.icon = [[NSURL alloc] initWithString:@"http://assets.gotryiton.com/img/profile-default.png"];
            obj.completer_id = @"ABC123";
        [initoptions addObject: obj];

         GTIOAutoCompleter *obj2 = [[GTIOAutoCompleter alloc] init];
            obj2.name = @"Same Name";
            obj2.icon = [[NSURL alloc] initWithString:@"http://profile.ak.fbcdn.net/hprofile-ak-ash2/41710_18605102_1732504808_q.jpg"];
            obj2.type = @"@";
            obj2.completer_id = @"XYZ456";
        [initoptions addObject: obj2];


        self.textView = [[GTIOAutoCompleteView alloc] initWithFrame:(CGRect){ 12, 4, self.backgroundView.bounds.size.width - 12, self.backgroundView.bounds.size.height - 10 } withOuterBox:(CGRect){0, 4, self.frame.size.width, self.frame.size.height } withData:initoptions];

        // [self.textView setBackgroundColor:[UIColor clearColor]];
//        [self.textView setContentInset:(UIEdgeInsets){ 5, 10, 5, 10 }];
        // [self.textView setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:12.0]];
        // [self.textView setTextColor:[UIColor gtio_darkGrayTextColor]];
        // [self.textView setScrollsToTop:NO];
        // [self.textView.textInput setDelegate:self];
        // [self.textView setReturnKeyType:UIReturnKeyDone];
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
