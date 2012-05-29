//
//  GTIOAlmostDoneTableDataItem.m
//  GTIO
//
//  Created by Scott Penrose on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlmostDoneTableDataItem.h"

@implementation GTIOAlmostDoneTableDataItem

@synthesize apiKey = _apiKey, titleText = _titleText, placeHolderText = _placeHolderText, accessoryText = _accessoryText, pickerItems = _pickerItems, required = _required, usesPicker = _usesPicker, multiline = _multiline;

- (id)initWithApiKey:(NSString*)apiKey andTitleText:(NSString*)title andPlaceHolderText:(NSString*)placeholder andAccessoryText:(NSString*)accessoryText andPickerItems:(NSArray*)pickerItems isRequired:(BOOL)required usesPicker:(BOOL)usesPicker isMultiline:(BOOL)multiline
{
    self = [super init];
    if (self) {
        _apiKey = apiKey;
        _titleText = title;
        _placeHolderText = placeholder;
        _accessoryText = accessoryText;
        _pickerItems = pickerItems;
        _required = required;
        _usesPicker = usesPicker;
        _multiline = multiline;
    }
    return self;
}

@end
