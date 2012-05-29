//
//  GTIOSelectableProfilePicture.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTIOSelectableProfilePictureDelegate <NSObject>

@optional
- (void)pictureWasTapped:(id)picture;

@end

@interface GTIOSelectableProfilePicture : UIView

@property (nonatomic, assign) BOOL isSelectable;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<GTIOSelectableProfilePictureDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andImageURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL*)url;
- (void)setImage:(UIImage*)image;

@end
