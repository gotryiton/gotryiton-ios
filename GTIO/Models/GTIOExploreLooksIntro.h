//
//  GTIOExploreLooksIntro.h
//  GTIO
//
//  Created by Simon Holroyd on 10/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOButton.h"

@interface GTIOExploreLooksIntro : NSObject <NSCoding>

@property (nonatomic, strong) NSString *postInteractionType;
@property (nonatomic, strong) NSURL *signUpButtonImageURL;
@property (nonatomic, strong) NSString *signUpButtonType;
@property (nonatomic, strong) NSURL *introOverlayImageURL;
@property (nonatomic, strong) NSString *introOverlayType;

@end
