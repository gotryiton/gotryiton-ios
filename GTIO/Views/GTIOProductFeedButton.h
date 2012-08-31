//
//  GTIOProductFeedButton.h
//  GTIO
//
//  Created by Simon Holroyd on 8/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"

@interface GTIOProductFeedButton : GTIOUIButton

+ (id)gtio_productFeedButton;
-(void) setWithImageUrl:(NSURL *)url;

@end
