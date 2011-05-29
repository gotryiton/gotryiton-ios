//
//  GTIOTableOutfitImageCell.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOTableOutfitImageCell is a subclass of [TTTableLinkedItemCell](TTTableLinkedItemCell) that displays either an outfit or a thumbnail of one

#import <Foundation/Foundation.h>


@interface GTIOTableOutfitImageCell : TTTableLinkedItemCell {
	TTImageView* _thumbnail;
	UIImageView* _thumbnailBackground;
	UIImageView* _thumbnailOverlay;
    UIImageView* _connectionImageView;
}

@end
