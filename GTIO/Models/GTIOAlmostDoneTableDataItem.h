//
//  GTIOAlmostDoneTableDataItem.h
//  GTIO
//
//  Created by Scott Penrose on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOAlmostDoneTableDataItem : NSObject

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *placeHolderText;
@property (nonatomic, copy) NSString *accessoryText;
@property (nonatomic, retain) NSArray *pickerItems;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, assign) BOOL usesPicker;
@property (nonatomic, assign) BOOL multiline;

- (id)initWithApiKey:(NSString *)apiKey andTitleText:(NSString *)title andPlaceHolderText:(NSString *)placeholder andAccessoryText:(NSString *)accessoryText andPickerItems:(NSArray *)pickerItems isRequired:(BOOL)required usesPicker:(BOOL)usesPicker isMultiline:(BOOL)multiline;

@end
