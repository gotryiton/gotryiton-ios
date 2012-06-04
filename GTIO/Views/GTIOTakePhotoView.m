//
//  GTIOTakePhotoView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTakePhotoView.h"

@interface GTIOTakePhotoView()

@property (nonatomic, strong) GTIOButton *photoSelectButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *canvas;

@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, assign) CGFloat firstX;
@property (nonatomic, assign) CGFloat firstY;

@end

@implementation GTIOTakePhotoView

@synthesize photoSelectButton = _photoSelectButton, deleteButton = _deleteButton, canvas = _canvas, imageView = _imageView, lastScale = _lastScale, firstX = _firstX, firstY = _firstY, image = _image, deleteButtonPosition = _deleteButtonPosition;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canvas = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self.canvas setClipsToBounds:YES];
        [self addSubview:self.canvas];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView setClipsToBounds:YES];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self setClipsToBounds:NO];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [self.canvas addGestureRecognizer:panRecognizer];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        [pinchRecognizer setDelegate:self];
        [self.canvas addGestureRecognizer:pinchRecognizer];
        
        self.photoSelectButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePhotoSelectBox];
        [self.photoSelectButton setFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self.photoSelectButton addTarget:self action:@selector(getImageFromCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.photoSelectButton];
        
        self.deleteButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePhotoDelete];
        [self.deleteButton setFrame:(CGRect){ -10, -10, self.deleteButton.frame.size }];
        [self.deleteButton addTarget:self action:@selector(removePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)hideDeleteButton:(BOOL)hidden
{
    [self.deleteButton setHidden:hidden];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.x > -10 && point.y > -10) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    if (image) {
        [self.imageView setImage:image];
        [self resetImageViewSizeAndPosition];
        [self.photoSelectButton removeFromSuperview];
        [self.imageView setAlpha:0.0];
        [self.canvas addSubview:self.imageView];
        [UIView animateWithDuration:0.25 animations:^{
            [self.imageView setAlpha:1.0];
        }];
        [self addSubview:self.deleteButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
    } else {
        [self addSubview:self.photoSelectButton];
        [UIView animateWithDuration:0.25 animations:^{
            [self.imageView setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.imageView removeFromSuperview];
            [self.imageView setImage:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
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
    CGPoint adjustedTranslatedPoint = [self adjustPointToFitCanvas:translatedPoint];
    if (!CGPointEqualToPoint(self.imageView.center, adjustedTranslatedPoint)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
    }
    [self.imageView setCenter:adjustedTranslatedPoint];
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
    if (self.imageView.frame.size.width <= self.canvas.frame.size.width ||
        self.imageView.frame.size.height <= self.canvas.frame.size.height) {
        [self resetImageViewSizeAndPosition];
    }
    [self.imageView setCenter:[self adjustPointToFitCanvas:self.imageView.center]];
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
    if (!CGAffineTransformEqualToTransform(currentTransform, newTransform)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
    }
}

- (CGPoint)adjustPointToFitCanvas:(CGPoint)point
{
    if ((point.x - (self.imageView.frame.size.width / 2)) >= 0) {
        point.x = (self.imageView.frame.size.width / 2);
    } else if ((point.x + (self.imageView.frame.size.width / 2)) <= self.canvas.frame.size.width) {
        point.x = self.canvas.frame.size.width - (self.imageView.frame.size.width / 2);
    }
    if ((point.y - (self.imageView.frame.size.height / 2)) >= 0) {
        point.y = (self.imageView.frame.size.height / 2);
    } else if ((point.y + (self.imageView.frame.size.height / 2)) <= self.canvas.frame.size.height) {
        point.y = self.canvas.frame.size.height - (self.imageView.frame.size.height / 2);
    }
    return point;
}

- (void)resetImageViewSizeAndPosition
{
    CGSize imageSize = self.imageView.image.size;
    float imageAspectRatio = imageSize.height / imageSize.width;
    CGSize canvasSize = self.canvas.frame.size;
    if ((canvasSize.width * imageAspectRatio) < canvasSize.height) {
        [self.imageView setFrame:(CGRect){ 0, 0, canvasSize.height / imageAspectRatio, canvasSize.height }];
    } else {
        [self.imageView setFrame:(CGRect){ 0, 0, canvasSize.width, canvasSize.width * imageAspectRatio }];
    }
    [self.imageView setCenter:(CGPoint){ self.canvas.bounds.size.width / 2, self.canvas.bounds.size.height / 2 }];
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
