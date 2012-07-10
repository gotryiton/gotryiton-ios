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
@synthesize cellTitleLabel = _cellTitleLabel, cellAccessoryTextMulti = _cellAccessoryTextMulti, placeHolderText = _placeHolderText, accessoryToolBar = _accessoryToolBar, flexibleSpace = _flexibleSpace, pickerView = _pickerView, usesPicker = _usesPicker, multiLine = _multiLine, indexPath = _indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _cellTitleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 10, self.frame.size.height / 2 - 8, 0, 0 }];
        [self.cellTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.cellTitleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:14.0]];
        [self.cellTitleLabel setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [self.contentView addSubview:self.cellTitleLabel];
        
        _cellAccessoryText = [[GTIOTextFieldForPickerViews alloc] initWithFrame:CGRectZero];
        [self.cellAccessoryText setBackgroundColor:[UIColor clearColor]];
        [self.cellAccessoryText setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLightItal size:14.0]];
        [self.cellAccessoryText setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [self.cellAccessoryText setTextAlignment:UITextAlignmentRight];
        [self.cellAccessoryText setDelegate:self];
        [self.cellAccessoryText setReturnKeyType:UIReturnKeyNext];
        [self.cellAccessoryText addTarget:self action:@selector(updateSaveData:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:self.cellAccessoryText];
        
        _accessoryToolBar = [[GTIODoneToolBar alloc] initWithTarget:self action:@selector(keyboardDoneTapped:)];
        
        _cellAccessoryTextMulti = [[GTIOPlaceHolderTextView alloc] initWithFrame:CGRectZero];
        [self.cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [self.cellAccessoryTextMulti setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLightItal size:14.0]];
        [self.cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [self.cellAccessoryTextMulti setDelegate:self];
        [self.cellAccessoryTextMulti setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [self.cellAccessoryTextMulti setPlaceholderColor:[UIColor gtio_lightGrayTextColor]];
        [self.cellAccessoryTextMulti setReturnKeyType:UIReturnKeyDone];
        [self.cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSaveDataMulti:) name:UITextViewTextDidChangeNotification object:self.cellAccessoryTextMulti];
        
        _usesPicker = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"] && [textView isEqual:self.cellAccessoryTextMulti]) {
        if (self.multiLine) {
            if ([self.delegate respondsToSelector:@selector(resetScrollAfterEditing)]) {
                [self.delegate resetScrollAfterEditing];
            }
            [self.cellAccessoryTextMulti resignFirstResponder];
            return NO;
        }
    }
    if (textView.text.length == 1 && text.length == 0) {
        textView.text = text;
        [textView setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegularItal size:14.0]];
        [textView setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
    } else {
        [textView setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
        [textView setTextColor:[UIColor gtio_signInColor]];
    }
    return YES;
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
    if ([self.delegate respondsToSelector:@selector(moveResponderToNextCellFromCellAtIndexPath:)]) {
        [self.delegate moveResponderToNextCellFromCellAtIndexPath:self.indexPath];
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
    if (textField.text.length == 1 && string.length == 0) {
        textField.text = string;
        [textField setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegularItal size:14.0]];
        [textField setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
    } else {
        [textField setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
        [textField setTextColor:[UIColor gtio_signInColor]];
    }
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
    UIColor *textColor = (required) ? [UIColor gtio_pinkTextColor] : [UIColor gtio_grayTextColor9C9C9C];
    [self.cellTitleLabel setTextColor:textColor];
}

- (void)setAccessoryTextUsesPicker:(BOOL)usesPicker
{
    _usesPicker = usesPicker;
    [self.cellAccessoryText setUsesPicker:usesPicker];
}

- (void)setPickerViewItems:(NSArray *)pickerViewItems
{
    _pickerViewItems = pickerViewItems;
    _pickerView = [[GTIOPickerViewForTextFields alloc] initWithFrame:CGRectZero andPickerItems:self.pickerViewItems];
    [self.accessoryToolBar useNextButtonWithTarget:self action:@selector(pickerNextTapped:)];
    [self.cellAccessoryText setInputAccessoryView:self.accessoryToolBar];
    [self.pickerView setPlaceHolderText:self.placeHolderText];
    [self.pickerView bindToTextField:self.cellAccessoryText];
    [self.cellAccessoryText setInputView:self.pickerView];
}

- (void)setAccessoryTextIsMultipleLines:(BOOL)multipleLines
{
    _multiLine = multipleLines;
    if (multipleLines) {
        [self.cellAccessoryText removeFromSuperview];
        [self.contentView addSubview:self.cellAccessoryTextMulti];
    } else {
        [self.cellAccessoryTextMulti removeFromSuperview];
        [self.contentView addSubview:self.cellAccessoryText];
    }
}

- (void)setAccessoryText:(NSString*)text
{
    if (self.multiLine) {
        [self.cellAccessoryTextMulti setText:text];
        if (text.length > 0) {
            [self.cellAccessoryTextMulti setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
            [self.cellAccessoryTextMulti setTextColor:[UIColor gtio_signInColor]];
        }
    } else {
        [self.cellAccessoryText setText:text];
    }
}

- (void)setAccessoryTextPlaceholderText:(NSString*)text
{
    _placeHolderText = text;
    if (self.multiLine) {
        [self.cellAccessoryTextMulti setPlaceholderText:text];
        [self.cellAccessoryTextMulti setFrame:(CGRect){ self.cellTitleLabel.frame.origin.x, self.cellTitleLabel.frame.origin.y + self.cellTitleLabel.frame.size.height, self.frame.size.width - 40, 70 }];
    } else {
        [self.cellAccessoryText setPlaceholder:text];
        [self.cellAccessoryText setFrame:(CGRect){ self.cellTitleLabel.frame.origin.x + self.cellTitleLabel.frame.size.width + 3, self.cellTitleLabel.frame.origin.y, self.frame.size.width - self.cellTitleLabel.frame.size.width - 43, self.cellTitleLabel.frame.size.height }];
    }
}

@end
