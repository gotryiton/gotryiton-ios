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

- (id)initWithFrame:(CGRect)frame title:(NSString *)title icon:(UIImage *)icon
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"description-box.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 4.0, 4.0, 6.0, 4.0 }]];
        [self.backgroundView setFrame:(CGRect){ 6, 0, self.bounds.size.width- (6 * 2), self.bounds.size.height }];
        [self addSubview:self.backgroundView];
        
        self.textView = [[GTIOPostAutoCompleteView alloc] initWithFrame:(CGRect){ 16, 7, self.backgroundView.bounds.size.width - (12 * 2), self.backgroundView.bounds.size.height  } outerBox:(CGRect){0, 4, self.frame.size.width, self.frame.size.height }];

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

        [GTIOAutoCompleter loadUsersDictionaryWithUserID:[GTIOUser currentUser].userID completionHandler:^(NSArray *loadedObjects, NSError *error) {
            if (!error) {
                NSMutableArray *users = [[NSMutableArray alloc] init];
                for (GTIOAutoCompleter *completer in loadedObjects) {
                    completer.type = @"@";
                    [users addObject:completer];
                }
                [self.textView addCompleters:users];
            }
        }];

        [self addSubview:self.textView];
    }
    return self;
}

@end
