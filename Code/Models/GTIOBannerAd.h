//
//  GTIOBannerAd.h
//  GTIO
//
//  Created by Jeremy Ellison on 6/14/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOBannerAd : NSObject {
    NSString* _bannerImageUrlLarge;
    NSString* _bannerImageUrlSmall;
    NSString* _clickUrl;
    NSString* _width;
    NSString* _height;
}

@property (nonatomic, copy) NSString* bannerImageUrlLarge;
@property (nonatomic, copy) NSString* bannerImageUrlSmall;
@property (nonatomic, copy) NSString* clickUrl;
@property (nonatomic, copy) NSString* width;
@property (nonatomic, copy) NSString* height;

@end
