//
//  GTIOAlmostDoneTableDataItem.m
//  GTIO
//
//  Created by Scott Penrose on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlmostDoneTableDataItem.h"

@implementation GTIOAlmostDoneTableDataItem


- (id)initWithApiKey:(NSString*)apiKey andTitleText:(NSString*)title andPlaceHolderText:(NSString*)placeholder andAccessoryText:(NSString*)accessoryText andPickerItems:(NSArray*)pickerItems isRequired:(BOOL)required usesPicker:(BOOL)usesPicker isMultiline:(BOOL)multiline characterLimit:(NSUInteger)characterLimit
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
        _characterLimit = characterLimit;
    }
    return self;
}

@end
