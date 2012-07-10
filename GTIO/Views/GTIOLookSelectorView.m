//
//  GTIOLookSelectorView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOLookSelectorView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kGTIOTopPadding = 9.0f;
static CGFloat const kGTIORightFrameXOrigin = 126.0f;
static CGFloat const kGTIOFrameImageWidth = 109.0f;
static CGFloat const kGTIOTopImageMaxHeight = 184.0f;
static CGFloat const kGTIOMainImageMaxHeight = 300.0f;
static CGFloat const kGTIOMainImageXOrigin = 10.0f;
static CGFloat const kGTIOSingleImageWidth = 225.0f;

@interface GTIOLookSelectorView()

@property (nonatomic, strong) UIView *photoSetView;

@end

@implementation GTIOLookSelectorView

@synthesize  photoSet = _photoSet, photoSetView = _photoSetView, singlePhotoView = _singlePhotoView, mainPhotoView = _mainPhotoView, topPhotoView = _topPhotoView, bottomPhotoView = _bottomPhotoView, photoCanvasSize = _photoCanvasSize;
@synthesize launchCameraHandler = _launchCameraHandler, addFilterHandler = _addFilterHandler;

- (id)initWithFrame:(CGRect)frame photoSet:(BOOL)photoSet launchCameraHandler:(GTIOLaunchCameraHandler)launchCameraHandler
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoSet = photoSet;
        _launchCameraHandler = launchCameraHandler;
        
        UIImageView *frameImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"photo-frame.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 14, 0, 135, 0 }]];
        [frameImageView setFrame:self.bounds];
        [self addSubview:frameImageView];
        
        // Single Image
        _singlePhotoView = [[GTIOTakePhotoView alloc] initWithFrame:(CGRect){ kGTIOMainImageXOrigin, kGTIOTopPadding, kGTIOSingleImageWidth, kGTIOMainImageMaxHeight }];
        [_singlePhotoView setPhotoSection:GTIOPostPhotoSectionMain];
        [_singlePhotoView setLaunchCameraHandler:_launchCameraHandler];
        
        _photoCanvasSize = (CGSize){ self.singlePhotoView.frame.size.width, self.singlePhotoView.frame.size.height };
        
        // Photo Set
        _photoSetView = [[UIView alloc] initWithFrame:self.bounds];
        
        // Swap Photo handler
        GTIOSwapPhotoHandler swapPhotoHandler = ^(GTIOTakePhotoView *takePhotoView, GTIOPostPhotoSection swapWithSection) {
            GTIOTakePhotoView *swapWithPhotoView;
            
            switch (swapWithSection) {
                case GTIOPostPhotoSectionTop:
                    swapWithPhotoView = self.topPhotoView;
                    break;
                case GTIOPostPhotoSectionBottom:
                    swapWithPhotoView = self.bottomPhotoView;
                    break;
                case GTIOPostPhotoSectionMain:
                    swapWithPhotoView = self.mainPhotoView;
                default:
                    break;
            }
            
            UIImage *currentOriginalImage = takePhotoView.originalImage;
            UIImage *currentFilteredImage = takePhotoView.filteredImage;
            takePhotoView.originalImage = swapWithPhotoView.originalImage;
            takePhotoView.filteredImage = swapWithPhotoView.filteredImage;
            swapWithPhotoView.originalImage = currentOriginalImage;
            swapWithPhotoView.filteredImage = currentFilteredImage;
        };
        
        // Photos
        _mainPhotoView = [[GTIOTakePhotoView alloc] initWithFrame:(CGRect){ kGTIOMainImageXOrigin, kGTIOTopPadding, kGTIOFrameImageWidth, kGTIOMainImageMaxHeight }];
        [_mainPhotoView setPhotoSection:GTIOPostPhotoSectionMain];
        [_mainPhotoView setLaunchCameraHandler:_launchCameraHandler];
        [_mainPhotoView setSwapPhotoHandler:swapPhotoHandler];
        [_photoSetView addSubview:self.mainPhotoView];
        
        _topPhotoView = [[GTIOTakePhotoView alloc] initWithFrame:(CGRect){ kGTIORightFrameXOrigin, kGTIOTopPadding, kGTIOFrameImageWidth, kGTIOTopImageMaxHeight }];
        [_topPhotoView setPhotoSection:GTIOPostPhotoSectionTop];
        [_topPhotoView setLaunchCameraHandler:_launchCameraHandler];
        [_topPhotoView setSwapPhotoHandler:swapPhotoHandler];
        [_topPhotoView setEditPhotoButtonPosition:GTIOEditPhotoButtonPositionRight];
        [_photoSetView addSubview:self.topPhotoView];
        
        _bottomPhotoView = [[GTIOTakePhotoView alloc] initWithFrame:(CGRect){ kGTIORightFrameXOrigin, 200, kGTIOFrameImageWidth, kGTIOFrameImageWidth }];
        [_bottomPhotoView setPhotoSection:GTIOPostPhotoSectionBottom];
        [_bottomPhotoView setLaunchCameraHandler:_launchCameraHandler];
        [_bottomPhotoView setSwapPhotoHandler:swapPhotoHandler];
        [_bottomPhotoView setEditPhotoButtonPosition:GTIOEditPhotoButtonPositionRight];
        [_photoSetView addSubview:self.bottomPhotoView];
        
        [self refreshView];
    }
    return self;
}

- (void)reset
{
    [self.singlePhotoView reset];
    [self.mainPhotoView reset];
    [self.topPhotoView reset];
    [self.bottomPhotoView reset];
}

- (void)hideEditPhotoButtons:(BOOL)hidden
{
    [self.singlePhotoView hideEditPhotoButton:hidden];
    [self.mainPhotoView hideEditPhotoButton:hidden];
    [self.topPhotoView hideEditPhotoButton:hidden];
    [self.bottomPhotoView hideEditPhotoButton:hidden];
}

- (UIView *)compositeCanvas
{
    if (self.photoSet) {
        return self.photoSetView;
    } else {
        return self.singlePhotoView;
    }
}

- (void)lookSelectorControl:(GTIOLookSelectorControl *)lookSelectorControl photoSet:(BOOL)photoSet
{
    self.photoSet = photoSet;
    [self refreshView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
}

- (BOOL)selectionsComplete
{
    if (self.photoSet) {
        return (self.mainPhotoView.imageView.image && self.topPhotoView.imageView.image && self.bottomPhotoView.imageView.image);
    } else {
        return (self.singlePhotoView.imageView.image != nil);
    }
}

- (void)refreshView
{
    [self.singlePhotoView removeFromSuperview];
    [self.photoSetView removeFromSuperview];
    
    if (self.photoSet) {
        if (self.singlePhotoView.imageView.image && !self.mainPhotoView.imageView.image) {
            [self.mainPhotoView setFilteredImage:self.singlePhotoView.imageView.image];
        }
        [self addSubview:self.photoSetView];
        [self bringSubviewToFront:self.photoSetView];
    } else {
        if (!self.singlePhotoView.imageView.image && self.mainPhotoView.imageView.image) {
            [self.singlePhotoView setFilteredImage:self.mainPhotoView.imageView.image];
        }
        [self addSubview:self.singlePhotoView];
        [self bringSubviewToFront:self.singlePhotoView];
    }
}

#pragma mark - Properties

- (void)setPhotoSet:(BOOL)photoSet
{
    _photoSet = photoSet;
    
    [self.singlePhotoView setPhotoSet:_photoSet];
    [self.mainPhotoView setPhotoSet:_photoSet];
    [self.topPhotoView setPhotoSet:_photoSet];
    [self.bottomPhotoView setPhotoSet:_photoSet];
}

- (void)setAddFilterHandler:(GTIOAddFilterHandler)addFilterHandler
{
    _addFilterHandler = [addFilterHandler copy];
    
    [self.singlePhotoView setAddFilterHandler:_addFilterHandler];
    [self.mainPhotoView setAddFilterHandler:_addFilterHandler];
    [self.topPhotoView setAddFilterHandler:_addFilterHandler];
    [self.bottomPhotoView setAddFilterHandler:_addFilterHandler];
}

@end
