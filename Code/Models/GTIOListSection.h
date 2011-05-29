//
//  GTIOListSection.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOListSection represents a section of a list of stylists or outfits
#import <Foundation/Foundation.h>


@interface GTIOListSection : NSObject {
    NSString* _title;
    NSArray* _stylists;
    NSArray* _outfits;
}
/// Title of Section
@property (nonatomic, retain) NSString* title;
/// Stylists contained
@property (nonatomic, retain) NSArray* stylists;
/// Outfits contained
@property (nonatomic, retain) NSArray* outfits;

@end
