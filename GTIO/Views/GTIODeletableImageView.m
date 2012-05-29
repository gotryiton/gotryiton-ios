//
//  GTIODeletableImageView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIODeletableImageView.h"
#import "GTIOPhotoSelectBoxButton.h"

@interface GTIODeletableImageView()

@property (nonatomic, strong) GTIOPhotoSelectBoxButton *photoSelectButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation GTIODeletableImageView

@synthesize deleteButton = _deleteButton, photoSelectButton = _photoSelectButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setClipsToBounds:NO];
        
        self.photoSelectButton = [[GTIOPhotoSelectBoxButton alloc] initWithFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self addSubview:self.photoSelectButton];
    }
    return self;
}

@end
