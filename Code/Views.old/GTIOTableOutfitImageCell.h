//
//  GTIOTableOutfitImageCell.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOTableOutfitImageCell : TTTableLinkedItemCell {
	TTImageView* _thumbnail;
	UIImageView* _thumbnailBackground;
	UIImageView* _thumbnailOverlay;
    UIImageView* _connectionImageView;
}

@end
