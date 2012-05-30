//
//  GTIOTakePhotoView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTakePhotoView.h"
#import "GTIOPhotoSelectBoxButton.h"

@interface GTIOTakePhotoView()

@property (nonatomic, strong) GTIOPhotoSelectBoxButton *photoSelectButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *canvas;

@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, assign) CGFloat firstX;
@property (nonatomic, assign) CGFloat firstY;

@end

@implementation GTIOTakePhotoView

@synthesize photoSelectButton = _photoSelectButton, deleteButton = _deleteButton, canvas = _canvas, imageView = _imageView, lastScale = _lastScale, firstX = _firstX, firstY = _firstY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canvas = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self.canvas setClipsToBounds:YES];
        [self addSubview:self.canvas];
        
        self.imageView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView setClipsToBounds:YES];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [self setClipsToBounds:NO];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [self.canvas addGestureRecognizer:panRecognizer];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        [pinchRecognizer setDelegate:self];
        [self.canvas addGestureRecognizer:pinchRecognizer];
        
        self.photoSelectButton = [[GTIOPhotoSelectBoxButton alloc] initWithFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self.photoSelectButton addTarget:self action:@selector(getImageFromCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.photoSelectButton];
        
        UIImage *deleteButtonImageNormal = [UIImage imageNamed:@"remove-frame-OFF.png"];
        UIImage *deleteButtonImageHighlighted = [UIImage imageNamed:@"remove-frame-ON.png"];
        self.deleteButton = [[UIButton alloc] initWithFrame:(CGRect){ -10, -10, deleteButtonImageNormal.size }];
        [self.deleteButton setImage:deleteButtonImageNormal forState:UIControlStateNormal];
        [self.deleteButton setImage:deleteButtonImageHighlighted forState:UIControlStateHighlighted];
        [self.deleteButton addTarget:self action:@selector(removePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (image) {
        [self resetImageView];
        [self.imageView setImage:image];
        [self.photoSelectButton removeFromSuperview];
        [self.imageView setAlpha:0.0];
        [self.canvas addSubview:self.imageView];
        [UIView animateWithDuration:0.25 animations:^{
            [self.imageView setAlpha:1.0];
        }];
        [self addSubview:self.deleteButton];
    } else {
        [self addSubview:self.photoSelectButton];
        [UIView animateWithDuration:0.25 animations:^{
            [self.imageView setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.imageView removeFromSuperview];
            [self.imageView setImage:nil];
            [self resetImageView];
        }];
        [self.deleteButton removeFromSuperview];
    }
}

- (void)removePhoto:(id)sender
{
    [self setImage:nil];
}

- (void)getImageFromCamera:(id)sender
{
    if (self.imageView.image) {
        [self setImage:nil];
    } else {
        [self setImage:[UIImage imageNamed:@"test-photo.png"]];
    }
}

-(void)move:(id)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.canvas];
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.firstX = [self.imageView center].x;
        self.firstY = [self.imageView center].y;
    }
    translatedPoint = CGPointMake(self.firstX+translatedPoint.x, self.firstY+translatedPoint.y);
    [self.imageView setCenter:translatedPoint];
}

-(void)scale:(id)sender
{
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.imageView setTransform:newTransform];
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

- (void)resetImageView
{
    [self.imageView setCenter:(CGPoint){ self.canvas.bounds.size.width / 2, self.canvas.bounds.size.height / 2 }];
    [self.imageView setFrame:(CGRect){ self.imageView.frame.origin, self.canvas.bounds.size }];
}

- (void)setDeleteButtonPosition:(GTIODeleteButtonPosition)position
{
    if (position == GTIODeleteButtonPositionLeft) {
        [self.deleteButton setFrame:(CGRect){ -10, -10, self.deleteButton.bounds.size }];
    } else if (position == GTIODeleteButtonPositionRight) {
        [self.deleteButton setFrame:(CGRect){ self.canvas.bounds.size.width - (self.deleteButton.bounds.size.width / 2), -10, self.deleteButton.bounds.size }];
    }
}

@end
