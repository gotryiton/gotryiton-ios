//
//  GTIOOutfitReviewsController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOOutfit.h"

@interface GTIOOutfitReviewsController : TTTableViewController <TTTextEditorDelegate, RKObjectLoaderDelegate> {
	GTIOOutfit* _outfit;
	TTTextEditor* _editor;
	UILabel* _placeholder;
    NSMutableArray* _imageViews;
    NSMutableArray* _buttons;
    BOOL _loading;
}

@property (nonatomic, retain) GTIOOutfit* outfit;

@end
