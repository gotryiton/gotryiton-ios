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

@interface GTIOTakePhotoView()

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canvas = [[UIView alloc] initWithFrame:self.bounds];
        [self.canvas setClipsToBounds:YES];
        [self addSubview:self.canvas];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView setClipsToBounds:YES];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [self.canvas addGestureRecognizer:panRecognizer];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        [pinchRecognizer setDelegate:self];
        [self.canvas addGestureRecognizer:pinchRecognizer];
        
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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.x > -10 && point.y > -10) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

- (void)setFilteredImage:(UIImage *)filteredImage
{
    _filteredImage = filteredImage;
    if (_filteredImage) {
        [self.imageView setImage:_filteredImage];
        [self resetImageViewSizeAndPosition];
        [self.photoSelectButton removeFromSuperview];
        [self.imageView setAlpha:0.0];
        [self.canvas addSubview:self.imageView];
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
            [self.imageView setImage:nil];
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

- (void)setEditPhotoButtonPosition:(GTIOEditPhotoButtonPosition)position
{
    if (position == GTIOEditPhotoButtonPositionLeft) {
        [self.editPhotoButton setFrame:(CGRect){ { kGTIOEditPhotoPadding, kGTIOEditPhotoPadding }, self.editPhotoButton.bounds.size }];
    } else if (position == GTIOEditPhotoButtonPositionRight) {
        [self.editPhotoButton setFrame:(CGRect){ { self.canvas.bounds.size.width - self.editPhotoButton.bounds.size.width - kGTIOEditPhotoPadding, kGTIOEditPhotoPadding }, self.editPhotoButton.bounds.size }];
    }
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

@end
