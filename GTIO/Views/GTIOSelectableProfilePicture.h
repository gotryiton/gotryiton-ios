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

@property (nonatomic, unsafe_unretained) BOOL isSelectable;
@property (nonatomic, unsafe_unretained) BOOL isSelected;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, unsafe_unretained) id<GTIOSelectableProfilePictureDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andImageURL:(NSString*)url;
- (void)setImageWithURL:(NSString*)url;
- (void)setImage:(UIImage*)image;

@end
