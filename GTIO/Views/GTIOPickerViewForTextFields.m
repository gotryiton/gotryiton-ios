//
//  GTIOPickerViewForTextFields.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPickerViewForTextFields.h"

@interface GTIOPickerViewForTextFields() {
@private
    UITextField* _bindingTextField;
}
@end

@implementation GTIOPickerViewForTextFields

@synthesize pickerItems = _pickerItems, placeHolderText = _placeHolderText;

- (id)initWithFrame:(CGRect)frame andPickerItems:(NSArray*)pickerItems
{
    self = [super initWithFrame:frame];
    if (self) {
        _pickerItems = pickerItems;
        [self setDataSource:self];
        [self setDelegate:self];
        [self setShowsSelectionIndicator:YES];
    }
    return self;
}

- (NSString*)selectedRowLabel
{
    if ([_placeHolderText length] > 0) {
        return _placeHolderText;
    } else {
        return [_pickerItems objectAtIndex:[self selectedRowInComponent:0]];
    }
}

- (void)updateLabel
{
    [_bindingTextField setText:[self selectedRowLabel]];
}

- (void)bindToTextField:(UITextField *)textField
{
    _bindingTextField = textField;
    [_bindingTextField setInputView:self];
    [_bindingTextField setText:[self selectedRowLabel]];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0: return [_pickerItems count];
        default: return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerItems objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _placeHolderText = @"";
    [self updateLabel];
}

@end