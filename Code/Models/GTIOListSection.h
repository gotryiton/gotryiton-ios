//
//  GTIOListSection.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOListSection : NSObject {
    NSString* _title;
    NSArray* _stylists;
    NSArray* _outfits;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSArray* stylists;
@property (nonatomic, retain) NSArray* outfits;

@end
