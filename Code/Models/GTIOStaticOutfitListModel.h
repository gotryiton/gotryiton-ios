//
//  GTIOStaticOutfitListModel.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/25/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOStaticOutfitListModel is a [TTModel](TTModel) that is used in [GTIOTodosTableViewController](GTIOTodosTableViewController) and [GTIOOpinionRequestSession](GTIOOpinionRequestSession)
@interface GTIOStaticOutfitListModel : TTModel {
    NSArray* _outfits;
}
/// Array of objects
@property (nonatomic, readonly) NSArray* objects;
/// Return a model initialized with an array of objects
+ (id)modelWithOutfits:(NSArray*)outfits;

@end
