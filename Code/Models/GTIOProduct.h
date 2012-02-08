//
//  GTIOProduct.h
//  GTIO
//
//  Created by Jeremy Ellison on 2/3/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOProduct : NSObject

@property (nonatomic, retain) NSString* productID;
@property (nonatomic, retain) NSString* brand;
@property (nonatomic, retain) NSString* productName;
@property (nonatomic, retain) NSString* price;
@property (nonatomic, retain) NSString* buyUrl;
@property (nonatomic, retain) NSString* thumbnail;
@property (nonatomic, retain) NSString* descriptionString;

@property (nonatomic, retain) NSData* encodedWebView;

+ (RKObjectMapping*)productMapping;

+ (void)cacheWebView:(id)webView outfitId:(NSString *)outfitId;
+ (id)cachedWebViewForOutfitId:(NSString *)outfitId;

@end
