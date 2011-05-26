//
//  GTIOStaticOutfitListModel.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/25/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOStaticOutfitListModel : TTModel {
    NSArray* _outfits;
}

@property (nonatomic, readonly) NSArray* objects;

+ (id)modelWithOutfits:(NSArray*)outfits;

@end
