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
#import "GTIOTextFieldForPickerViews.h"
#import "GTIODoneToolBar.h"

@interface GTIOAlmostDoneTableCell()

@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) GTIOPlaceHolderTextView *cellAccessoryTextMulti;
@property (nonatomic, strong) NSString *placeHolderText;
@property (nonatomic, strong) GTIODoneToolBar *accessoryToolBar;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;
@property (nonatomic, strong) GTIOPickerViewForTextFields *pickerView;
@property (nonatomic, assign) BOOL usesPicker;
@property (nonatomic, assign, getter = isMultiLine) BOOL multiLine;

@end

@implementation GTIOAlmostDoneTableCell

@synthesize apiKey = _apiKey, pickerViewItems = _pickerViewItems, delegate = _delegate, cellAccessoryText = _cellAccessoryText;
@synthesize cellTitleLabel = _cellTitleLabel, cellAccessoryTextMulti = _cellAccessoryTextMulti, placeHolderText = _placeHolderText, accessoryToolBar = _accessoryToolBar, flexibleSpace = _flexibleSpace, pickerView = _pickerView, usesPicker = _usesPicker, multiLine = _multiLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _cellTitleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 10, self.frame.size.height / 2 - 8, 0, 0 }];
        [_cellTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_cellTitleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:14.0]];
        [_cellTitleLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
        [self.contentView addSubview:_cellTitleLabel];
        
        _cellAccessoryText = [[GTIOTextFieldForPickerViews alloc] initWithFrame:CGRectZero];
        [_cellAccessoryText setBackgroundColor:[UIColor clearColor]];
        [_cellAccessoryText setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLightItal size:14.0]];
        [_cellAccessoryText setTextColor:[UIColor gtio_darkGrayTextColor]];
        [_cellAccessoryText setTextAlignment:UITextAlignmentRight];
        [_cellAccessoryText setDelegate:self];
        [_cellAccessoryText setReturnKeyType:UIReturnKeyNext];
        [_cellAccessoryText addTarget:self action:@selector(updateSaveData:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_cellAccessoryText];
        
        _accessoryToolBar = [[GTIODoneToolBar alloc] initWithTarget:self andAction:@selector(keyboardDoneTapped:)];
        
        _cellAccessoryTextMulti = [[GTIOPlaceHolderTextView alloc] initWithFrame:CGRectZero];
        [_cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [_cellAccessoryTextMulti setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0]];
        [_cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [_cellAccessoryTextMulti setDelegate:self];
        [_cellAccessoryTextMulti setTextColor:[UIColor gtio_darkGrayTextColor]];
        [_cellAccessoryTextMulti setPlaceholderColor:[UIColor gtio_darkGrayTextColor]];
        [_cellAccessoryTextMulti setInputAccessoryView:_accessoryToolBar];
        [_cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSaveDataMulti:) name:UITextViewTextDidChangeNotification object:_cellAccessoryTextMulti];
        
        _usesPicker = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDoneTapped:(id)sender
{
    if (self.multiLine) {
        if ([self.delegate respondsToSelector:@selector(resetScrollAfterEditing)]) {
            [self.delegate resetScrollAfterEditing];
        }
        [self.cellAccessoryTextMulti resignFirstResponder];
    }
}

- (void)pickerNextTapped:(id)sender
{
    [self moveToNextCell];
}

- (BOOL)becomeFirstResponder
{
    if (self.multiLine) {
        return [self.cellAccessoryTextMulti becomeFirstResponder];
    }
    return [self.cellAccessoryText becomeFirstResponder];
}

- (void)moveToNextCell
{
    if ([self.delegate respondsToSelector:@selector(moveResponderToNextCellFromCell:)]) {
        [self.delegate moveResponderToNextCellFromCell:[self tag]];
    }
}

- (void)updateSaveData:(id)sender
{
    UITextField *textField = (UITextField*)sender;
    if ([self.delegate respondsToSelector:@selector(updateDataSourceWithValue:ForKey:)]) {
        [self.delegate updateDataSourceWithValue:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] ForKey:self.apiKey];
    }
}

- (void)updateSaveDataMulti:(NSNotification*)notification
{
    [self updateSaveData:notification.object];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType] == UIReturnKeyNext) {
        [self moveToNextCell];
        return YES;
    }
    if ([self.delegate respondsToSelector:@selector(resetScrollAfterEditing)]) {
        [self.delegate resetScrollAfterEditing];
    }
    return [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(scrollUpWhileEditing:)]) {
        [self.delegate scrollUpWhileEditing:[self tag]];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.usesPicker) {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(scrollUpWhileEditing:)]) {
        [self.delegate scrollUpWhileEditing:[self tag]];
    }
    return YES;
}

- (void)setCellTitle:(NSString*)title
{
    [self.cellTitleLabel setText:title];
    [self.cellTitleLabel sizeToFit];
}

- (void)setRequired:(BOOL)required
{
    UIColor *textColor = (required) ? [UIColor gtio_pinkTextColor] : [UIColor gtio_darkGrayTextColor];
    [self.cellTitleLabel setTextColor:textColor];
}

- (void)setAccessoryTextUsesPicker:(BOOL)usesPicker
{
    _usesPicker = usesPicker;
    UIFont *placeHolderFont = (usesPicker) ? [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:14.0] : [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0];
    [_cellAccessoryText setUsesPicker:usesPicker];
    [_cellAccessoryText setFont:placeHolderFont];
}

- (void)setPickerViewItems:(NSArray *)pickerViewItems
{
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
        [_cellAccessoryTextMulti setFrame:(CGRect){ _cellTitleLabel.frame.origin.x, _cellTitleLabel.frame.origin.y + _cellTitleLabel.frame.size.height, self.frame.size.width - 40, 70 }];
    } else {
        [_cellAccessoryText setPlaceholder:text];
        [_cellAccessoryText setFrame:(CGRect){ _cellTitleLabel.frame.origin.x + _cellTitleLabel.frame.size.width + 3, _cellTitleLabel.frame.origin.y, self.frame.size.width - _cellTitleLabel.frame.size.width - 43, _cellTitleLabel.frame.size.height }];
    }
}

@end
