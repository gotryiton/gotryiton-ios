//
//  GTIOTakePhotoView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTakePhotoView.h"

#import "GTIOActionSheet.h"
#import "GTIOButton.h"

static CGFloat const kGTIOEditPhotoPadding = 6.0f;

static NSString * const kGTIOAddAFilterResource = @"add-a-filter";
static NSString * const kGTIOReplacePhotoResource = @"replace-photo";
static NSString * const kGTIOSwapWithResource = @"swap-with";

@interface GTIOTakePhotoView() <UIScrollViewDelegate>

@property (nonatomic, strong) GTIOUIButton *photoSelectButton;
@property (nonatomic, strong) GTIOUIButton *editPhotoButton;

@property (nonatomic, strong) UIView *canvas;

@property (nonatomic, strong) GTIOActionSheet *actionSheet;

@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, assign) CGFloat firstX;
@property (nonatomic, assign) CGFloat firstY;

@end

@implementation GTIOTakePhotoView

@synthesize filteredImage = _filteredImage, originalImage = _originalImage;
@synthesize filterName = _filterName;
@synthesize photoSelectButton = _photoSelectButton, canvas = _canvas, imageView = _imageView, editPhotoButton = _editPhotoButton;
@synthesize lastScale = _lastScale, firstX = _firstX, firstY = _firstY;
@synthesize editPhotoButtonPosition = _editPhotoButtonPosition;
@synthesize launchCameraHandler = _launchCameraHandler, swapPhotoHandler = _swapPhotoHandler, addFilterHandler = _addFilterHandler;
@synthesize photoSection = _photoSection, photoSet = _photoSet;
@synthesize actionSheet = _actionSheet;
@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setScrollEnabled:YES];
        [self.scrollView setBounces:YES];
        [self.scrollView setDelegate:self];
        [self.scrollView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.scrollView];
        
        self.photoSelectButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypePhotoSelectBox];
        [self.photoSelectButton setFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self.photoSelectButton addTarget:self action:@selector(getImageFromCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.photoSelectButton];
        
        // Edit Photo Button
        _editPhotoButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeEditPhoto tapHandler:^(id sender) {
            [self.actionSheet showWithConfigurationBlock:^(GTIOActionSheet *actionSheet) {
                actionSheet.didDismiss = ^(GTIOActionSheet *actionSheet) {
                    if (!actionSheet.wasCancelled) {

                    }
                };
            }];
        }];
        [_editPhotoButton setFrame:(CGRect){ { kGTIOEditPhotoPadding, kGTIOEditPhotoPadding }, _editPhotoButton.frame.size }];
    }
    return self;
}

- (void)hideEditPhotoButton:(BOOL)hidden
{
    [self.editPhotoButton setHidden:hidden];
}

- (void)reset
{
    [self.imageView setImage:nil];
    self.originalImage = nil;
    self.filteredImage = nil;
    self.filterName = nil;
}

- (void)setFilteredImage:(UIImage *)filteredImage
{
    _filteredImage = filteredImage;
    if (_filteredImage) {
        [self.photoSelectButton removeFromSuperview];
        
        // Have to create new UIImageView each time image gets set because on swap
        // the frame size was getting huge and couldn't figure out why
        [self.imageView removeFromSuperview];
        self.imageView = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, _filteredImage.size }];
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setImage:_filteredImage];
        [self.imageView setAlpha:0.0];
        [self.scrollView addSubview:self.imageView];
        
        [self zoom];
                
        [UIView animateWithDuration:0.25 animations:^{
            [self.imageView setAlpha:1.0];
        }];
        [self addSubview:self.editPhotoButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
    } else {
        [self addSubview:self.photoSelectButton];
        [UIView animateWithDuration:0.25 animations:^{
            [self.imageView setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.imageView removeFromSuperview];
            self.imageView = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
        }];
        [self.editPhotoButton removeFromSuperview];
    }
}

- (void)removePhoto:(id)sender
{
    [self setFilteredImage:nil];
}

- (void)getImageFromCamera:(id)sender
{
    if (self.launchCameraHandler) {
        self.launchCameraHandler(self.photoSection);
    }
}

- (void)setEditPhotoButtonPosition:(GTIOEditPhotoButtonPosition)position
{
    if (position == GTIOEditPhotoButtonPositionLeft) {
        [self.editPhotoButton setFrame:(CGRect){ { kGTIOEditPhotoPadding, kGTIOEditPhotoPadding }, self.editPhotoButton.bounds.size }];
    } else if (position == GTIOEditPhotoButtonPositionRight) {
        [self.editPhotoButton setFrame:(CGRect){ { self.bounds.size.width - self.editPhotoButton.bounds.size.width - kGTIOEditPhotoPadding, kGTIOEditPhotoPadding }, self.editPhotoButton.bounds.size }];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
}

#pragma mark - ActionSheet

- (void)setupActionSheet
{
    NSMutableArray *buttonModels = [NSMutableArray array];
    
    GTIOButton *addFilter = [[GTIOButton alloc] init];
    [addFilter setText:@"add a filter"];
    [addFilter setState:[NSNumber numberWithInt:1]];
    [addFilter setAction:[GTIOButtonAction buttonActionWithDestination:[NSString stringWithFormat:@"gtio://%@", kGTIOAddAFilterResource]]];
    [buttonModels addObject:addFilter];
    
    GTIOButton *replacePhoto = [[GTIOButton alloc] init];
    [replacePhoto setText:@"replace photo"];
    [replacePhoto setState:[NSNumber numberWithInt:1]];
    [replacePhoto setAction:[GTIOButtonAction buttonActionWithDestination:[NSString stringWithFormat:@"gtio://%@", kGTIOReplacePhotoResource]]];
    [buttonModels addObject:replacePhoto];
    
    if (self.isPhotoSet) {
        GTIOPostPhotoSection swapBSection;
        GTIOPostPhotoSection swapASection;
        
        switch (self.photoSection) {
            case GTIOPostPhotoSectionTop:
                swapBSection = GTIOPostPhotoSectionMain;
                swapASection = GTIOPostPhotoSectionBottom;
                break;
            case GTIOPostPhotoSectionBottom:
                swapBSection = GTIOPostPhotoSectionMain;
                swapASection = GTIOPostPhotoSectionTop;
                break;
            case GTIOPostPhotoSectionMain:
            default:
                swapBSection = GTIOPostPhotoSectionTop;
                swapASection = GTIOPostPhotoSectionBottom;
                break;
        }
        
        GTIOButton *swapB = [[GTIOButton alloc] init];
        [swapB setText:@"swap with"];
        [swapB setState:[NSNumber numberWithInt:1]];
        [swapB setSuffixImage:[UIImage imageNamed:[NSString stringWithFormat:@"swap-map-%i.png", swapBSection]]];
        [swapB setAction:[GTIOButtonAction buttonActionWithDestination:[NSString stringWithFormat:@"gtio://%@/%i", kGTIOSwapWithResource, swapBSection]]];
        [buttonModels insertObject:swapB atIndex:0];
        
        GTIOButton *swapA = [[GTIOButton alloc] init];
        [swapA setText:@"swap with"];
        [swapA setState:[NSNumber numberWithInt:1]];
        [swapA setSuffixImage:[UIImage imageNamed:[NSString stringWithFormat:@"swap-map-%i.png", swapASection]]];
        [swapA setAction:[GTIOButtonAction buttonActionWithDestination:[NSString stringWithFormat:@"gtio://%@/%i", kGTIOSwapWithResource, swapASection]]];
        [buttonModels insertObject:swapA atIndex:0];
    }
    
    // ActionSheet
    _actionSheet = [[GTIOActionSheet alloc] initWithButtons:buttonModels buttonTapHandler:^(GTIOButton *buttonModel) {
        NSURL *URL = [NSURL URLWithString:buttonModel.action.destination];
        
        NSString *urlHost = [URL host];
        NSArray *pathComponents = [URL pathComponents];
        
        [self.actionSheet dismiss];
        
        if ([urlHost isEqualToString:kGTIOSwapWithResource]) {
            if ([pathComponents count] >= 2) {
                GTIOPostPhotoSection sectionToSwapWith = [[pathComponents objectAtIndex:1] integerValue];

                if (self.swapPhotoHandler) {
                    self.swapPhotoHandler(self, sectionToSwapWith);
                }
            }
        } else if ([urlHost isEqualToString:kGTIOReplacePhotoResource]) {
            if (self.launchCameraHandler) {
                self.launchCameraHandler(self.photoSection);
            }
        } else if ([urlHost isEqualToString:kGTIOAddAFilterResource]) {
            if (self.addFilterHandler) {
                self.addFilterHandler(self.photoSection, self.originalImage);
            }
        }
    }];
}

#pragma mark - Properties

- (void)setPhotoSection:(GTIOPostPhotoSection)photoSection
{
    _photoSection = photoSection;
    [self setupActionSheet];
}

- (void)setPhotoSet:(BOOL)photoSet
{
    _photoSet = photoSet;
    [self setupActionSheet];
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    [self setupActionSheet];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    CGFloat scaledImageHeight = self.filteredImage.size.height * self.scrollView.zoomScale;

    if (self.filteredImage.size.height <= frame.size.height) {
        // This zooms the imageView as it moves
        [self.imageView setFrame:(CGRect){ CGPointZero, { self.imageView.frame.size.width, self.bounds.size.height } }];
        
        // Have to resize these frames first or zoom won't work
        [self.scrollView setFrame:self.bounds];
        [self.photoSelectButton setFrame:self.bounds];
        
        if (self.filteredImage) {
            [self zoom];
        }
        return;
    } else if (scaledImageHeight < frame.size.height) {
        
        CGRect frame = self.imageView.frame;
        frame.size = frame.size;
        
        if (self.filteredImage) {
            [self zoom];
        }
    } else {
        // This doesn't move or change the image while it is resizing
        CGRect bounds = self.imageView.bounds;
        bounds.size = frame.size;
    }

    [self.scrollView setFrame:self.bounds];
    [self.photoSelectButton setFrame:self.bounds];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
}

#pragma mark - 

- (void)zoom
{
    CGFloat minZoomScale = 1.0f;
    if (_filteredImage.size.width < _filteredImage.size.height) {
        minZoomScale = self.scrollView.bounds.size.width / _filteredImage.size.width;
        if (_filteredImage.size.height * minZoomScale < self.scrollView.bounds.size.height) {
            minZoomScale = self.scrollView.bounds.size.height / _filteredImage.size.height;
        }
    } else {
        minZoomScale = self.scrollView.bounds.size.height / _filteredImage.size.height;
        if (_filteredImage.size.width * minZoomScale < self.scrollView.bounds.size.width) {
            minZoomScale = self.scrollView.bounds.size.width / _filteredImage.size.width;
        }
    }
    
    [self.scrollView setMinimumZoomScale:minZoomScale];
    [self.scrollView setMaximumZoomScale:minZoomScale * 2];
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
}

@end
