//
//  GTIOAlmostDoneTableCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlmostDoneTableCell.h"
#import "GTIOPickerViewForTextFields.h"
#import "GTIOPlaceHolderTextView.h"

@interface GTIOAlmostDoneTableCell() {
@private
    UILabel* _cellTitle;
    UITextField* _cellAccessoryText;
    GTIOPlaceHolderTextView* _cellAccessoryTextMulti;
    NSString* _placeHolderText;
    UIToolbar* _accessoryToolBar;
    UIBarButtonItem* _flexibleSpace;
    GTIOPickerViewForTextFields* _pickerView;
    BOOL _usesPicker;
    BOOL _multiLine;
}

@end

@implementation GTIOAlmostDoneTableCell

@synthesize pickerViewItems = _pickerViewItems, delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _cellTitle = [[UILabel alloc] initWithFrame:(CGRect){10,self.frame.size.height/2-8,0,0}];
        [_cellTitle setBackgroundColor:[UIColor clearColor]];
        [_cellTitle setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:14.0]];
        [_cellTitle setTextColor:UIColorFromRGB(0xA0A0A0)];
        [self.contentView addSubview:_cellTitle];
        
        _cellAccessoryText = [[UITextField alloc] initWithFrame:CGRectZero];
        [_cellAccessoryText setBackgroundColor:[UIColor clearColor]];
        [_cellAccessoryText setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0]];
        [_cellAccessoryText setTextColor:UIColorFromRGB(0xA0A0A0)];
        [_cellAccessoryText setTextAlignment:UITextAlignmentRight];
        [_cellAccessoryText setDelegate:self];
        [_cellAccessoryText setReturnKeyType:UIReturnKeyNext];
        [self.contentView addSubview:_cellAccessoryText];
        
        _accessoryToolBar = [[UIToolbar alloc] init];
        [_accessoryToolBar setBarStyle:UIBarStyleBlack];
        [_accessoryToolBar setTranslucent:YES];
        [_accessoryToolBar setTintColor:nil];
        [_accessoryToolBar sizeToFit];
        _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(keyboardDoneTapped:)];
        [_accessoryToolBar setItems:[NSArray arrayWithObjects:_flexibleSpace, doneButton, nil]];
        
        _cellAccessoryTextMulti = [[GTIOPlaceHolderTextView alloc] initWithFrame:CGRectZero];
        [_cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [_cellAccessoryTextMulti setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0]];
        [_cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [_cellAccessoryTextMulti setDelegate:self];
        [_cellAccessoryTextMulti setTextColor:UIColorFromRGB(0xA0A0A0)];
        [_cellAccessoryTextMulti setPlaceholderColor:UIColorFromRGB(0xA0A0A0)];
        [_cellAccessoryTextMulti setInputAccessoryView:_accessoryToolBar];
        
        _usesPicker = NO;
    }
    return self;
}

- (void)keyboardDoneTapped:(id)sender {
    if (_multiLine) {
        if ([_delegate respondsToSelector:@selector(resetScrollAfterEditing)]) {
            [_delegate resetScrollAfterEditing];
        }
        [_cellAccessoryTextMulti resignFirstResponder];
    }
}

- (void)pickerNextTapped:(id)sender {
    [self moveToNextCell];
}

- (BOOL)becomeFirstResponder {
    if (_multiLine) {
        return [_cellAccessoryTextMulti becomeFirstResponder];
    }
    return [_cellAccessoryText becomeFirstResponder];
}

- (void)moveToNextCell {
    if ([_delegate respondsToSelector:@selector(moveResponderToNextCellFromCell:)]) {
        [_delegate moveResponderToNextCellFromCell:[self tag]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField returnKeyType] == UIReturnKeyNext) {
        [self moveToNextCell];
        return YES;
    }
    if ([_delegate respondsToSelector:@selector(resetScrollAfterEditing)]) {
        [_delegate resetScrollAfterEditing];
    }
    return [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(scrollUpWhileEditing:)]) {
        [_delegate scrollUpWhileEditing:[self tag]];
    }
    if ([textField.text isEqualToString:_placeHolderText] && !_usesPicker) {
        [textField setText:@""];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text length] == 0 && !_usesPicker) {
        [textField setText:_placeHolderText];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(scrollUpWhileEditing:)]) {
        [_delegate scrollUpWhileEditing:[self tag]];
    }
    return YES;
}

- (void)setCellTitle:(NSString*)title
{
    [_cellTitle setText:title];
    [_cellTitle sizeToFit];
}

- (void)setRequired:(BOOL)required
{
    UIColor *textColor = (required) ? UIColorFromRGB(0xFF8285) : UIColorFromRGB(0xA0A0A0);
    [_cellTitle setTextColor:textColor];
}

- (void)setAccessoryTextUsesPicker:(BOOL)usesPicker
{
    _usesPicker = usesPicker;
    UIFont *placeHolderFont = (usesPicker) ? [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:14.0] : [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0];
    [_cellAccessoryText setFont:placeHolderFont];    
}

- (void)setPickerViewItems:(NSArray *)pickerViewItems {
    _pickerViewItems = pickerViewItems;
    _pickerView = [[GTIOPickerViewForTextFields alloc] initWithFrame:CGRectZero andPickerItems:_pickerViewItems];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerNextTapped:)];
    [_accessoryToolBar setItems:[NSArray arrayWithObjects:_flexibleSpace, nextButton, nil]];
    [_cellAccessoryText setInputAccessoryView:_accessoryToolBar];
    [_pickerView setPlaceHolderText:_placeHolderText];
    [_pickerView bindToTextField:_cellAccessoryText];
    [_cellAccessoryText setInputView:_pickerView];
}

- (void)setAccessoryTextIsMultipleLines:(BOOL)multipleLines
{
    _multiLine = multipleLines;
    if (multipleLines) {
        [_cellAccessoryText removeFromSuperview];
        [self.contentView addSubview:_cellAccessoryTextMulti];
    } else {
        [_cellAccessoryTextMulti removeFromSuperview];
        [self.contentView addSubview:_cellAccessoryText];
    }
}

- (void)setAccessoryText:(NSString*)text
{
    if (_multiLine) {
        [_cellAccessoryTextMulti setText:text];
    } else {
        [_cellAccessoryText setText:text];
    }
}

- (void)setAccessoryTextPlaceholderText:(NSString*)text
{
    _placeHolderText = text;
    if (_multiLine) {
        [_cellAccessoryTextMulti setPlaceholderText:text];
        [_cellAccessoryTextMulti setFrame:(CGRect){_cellTitle.frame.origin.x,_cellTitle.frame.origin.y+_cellTitle.frame.size.height,self.frame.size.width-40,70}];
    } else {
        [_cellAccessoryText setText:text];
        [_cellAccessoryText setFrame:(CGRect){_cellTitle.frame.origin.x+_cellTitle.frame.size.width+3,_cellTitle.frame.origin.y,self.frame.size.width-_cellTitle.frame.size.width-43,_cellTitle.frame.size.height}];
    }
}

@end