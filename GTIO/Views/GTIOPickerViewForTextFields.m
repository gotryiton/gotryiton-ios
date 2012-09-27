//
//  GTIOPickerViewForTextFields.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPickerViewForTextFields.h"

@interface GTIOPickerViewForTextFields()

@property (nonatomic, strong) UITextField *bindingTextField;

@end

@implementation GTIOPickerViewForTextFields


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

- (void)selectRowWithLabel:(NSString *)rowLabel
{
   for (int i=0; i<self.pickerItems.count; i++){
        if ([rowLabel isEqualToString:[self.pickerItems objectAtIndex:i]]){
            self.selectedRowLabel = rowLabel;
           [self selectRow:i inComponent:0 animated:NO];
           
           [self.bindingTextField setText:self.selectedRowLabel];
           [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.bindingTextField];
        }
    }
}

- (void)updateSelectedRow
{
    [self selectRowWithLabel:[self.pickerItems objectAtIndex:[self selectedRowInComponent:0]]];
}

- (void)bindToTextField:(UITextField *)textField
{
    self.bindingTextField = textField;
    [self.bindingTextField setInputView:self];
    
    if (!self.selectedRowLabel){
        [self.bindingTextField setText:self.placeHolderText];
        self.selectedRowLabel = [self.pickerItems objectAtIndex:[self selectedRowInComponent:0]];
    }    
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0: return [self.pickerItems count];
        default: return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerItems objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.bindingTextField setText:[self selectedRowLabel]];

    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.bindingTextField];
}

@end
