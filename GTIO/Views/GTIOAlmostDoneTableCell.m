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
#import <QuartzCore/QuartzCore.h>

static NSInteger kGTIOMaxCharacterCount = 20;


static CGFloat const kGTIOSpinnerSize = 12.0;
static CGFloat const kGTIOSpinnerDefaultSize = 21.0;
static CGFloat const kGTIOSpinnerScale = 0.55;
static CGFloat const kGTIOSpinnerTopPadding = 2.0;
static CGFloat const kGTIOAlmostDoneCellRightPadding = 21.0;
static CGFloat const kGTIOAlmostDoneCellStatusPadding = 10.0;
static CGFloat const kGTIOAlmostDoneCellLeftPadding = 22.0;



@interface GTIOAlmostDoneTableCell()

@property (nonatomic, strong) GTIOPlaceHolderTextView *cellAccessoryTextMulti;
@property (nonatomic, strong) NSString *placeHolderText;
@property (nonatomic, strong) GTIODoneToolBar *accessoryToolBar;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;
@property (nonatomic, strong) GTIOPickerViewForTextFields *pickerView;
@property (nonatomic, strong) UIImageView *successStatusAccessoryView;
@property (nonatomic, strong) UIImageView *failureStatusAccessoryView;
@property (nonatomic, strong) UIActivityIndicatorView *spinnerStatusAccessoryView;
@property (nonatomic, assign) BOOL usesPicker;
@property (nonatomic, assign, getter = isMultiLine) BOOL multiLine;

@end

@implementation GTIOAlmostDoneTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _characterLimit = kGTIOMaxCharacterCount;

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
        [self.cellAccessoryText setReturnKeyType:UIReturnKeyNext];
        [self.cellAccessoryText setDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSaveDataFromNotification:) name:UITextFieldTextDidChangeNotification object:self.cellAccessoryText];

        [self.contentView addSubview:self.cellAccessoryText];
        _accessoryToolBar = [[GTIODoneToolBar alloc] initWithTarget:self action:@selector(keyboardDoneTapped:)];
        
        _cellAccessoryTextMulti = [[GTIOPlaceHolderTextView alloc] initWithFrame:CGRectZero];
        [self.cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [self.cellAccessoryTextMulti setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLightItal size:14.0]];
        [self.cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [self.cellAccessoryTextMulti setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [self.cellAccessoryTextMulti setPlaceholderColor:[UIColor gtio_grayTextColorB3B3B3]];
        [self.cellAccessoryTextMulti setReturnKeyType:UIReturnKeyDone];
        [self.cellAccessoryTextMulti setDelegate:self];
        [self.cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSaveDataFromNotification:) name:UITextViewTextDidChangeNotification object:self.cellAccessoryTextMulti];
            
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
    if ([self availableCharactersIn:textView.text input:text range:range]<0){
        return NO;
    }
    if (textView.text.length == 1 && text.length == 0) {
        [textView setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegularItal size:14.0]];
        [textView setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
    } else {
        [textView setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
        [textView setTextColor:[UIColor gtio_signInColor]];
    }
    if (self.usesPicker) {
        return NO;
    }

    if (self.changeHandler){
        // Wait 0.5 seconds then dispatch change handler 
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (self.changeHandler){
                self.changeHandler(self);
            }
        });
    }

    return YES;
}


- (void)pickerNextTapped:(id)sender
{
    [self.pickerView updateSelectedRow];
    [self moveToNextCell];
}

- (void)pickerDoneTapped:(id)sender
{
    [self.pickerView updateSelectedRow];
    [self.cellAccessoryText resignFirstResponder];

    if ([self.delegate respondsToSelector:@selector(resetScrollAfterEditing)]) {
        [self.delegate resetScrollAfterEditing];
    }
}

- (NSInteger)availableCharactersIn:(NSString *)existingString input:(NSString *)inputString range:(NSRange)range
{
    if (NSMaxRange(range)>0 && inputString.length>0){
        NSString * newText = [existingString stringByReplacingCharactersInRange:range withString:inputString];
        return  self.characterLimit - newText.length;    
    }
    return self.characterLimit;
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

- (void)boldInput
{
    self.cellAccessoryText.usesBoldFont = YES;
}

- (void)updateSaveData:(id)sender
{
    UITextField *textField = (UITextField*)sender;
    if ([self.delegate respondsToSelector:@selector(updateDataSourceWithValue:ForKey:)]) {
        [self.delegate updateDataSourceWithValue:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] ForKey:self.apiKey];
    }
}

- (void)updateSaveDataFromNotification:(NSNotification*)notification
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
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 1 && string.length == 0) {
        [textField setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegularItal size:14.0]];
        [textField setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
    } else {
        [textField setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
        [textField setTextColor:[UIColor gtio_signInColor]];
    }
    if ([self availableCharactersIn:textField.text input:string range:range]<0){
        return NO;
    }
    if (self.usesPicker) {
        return NO;
    }

    if (self.changeHandler){
        // Wait 0.5 seconds then dispatch change handler 
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (self.changeHandler){
                self.changeHandler(self);
            }
        });
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
    [self.accessoryToolBar useNextAndDoneButtonWithTarget:self doneAction:@selector(pickerDoneTapped:) nextAction:@selector(pickerNextTapped:)];
    [self.cellAccessoryText setInputAccessoryView:self.accessoryToolBar];
    [self.pickerView setPlaceHolderText:self.placeHolderText];
    [self.pickerView bindToTextField:self.cellAccessoryText];
    [self.cellAccessoryText setInputView:self.pickerView];
}


- (void)setStatusIndicatorWithSuccessImage:(UIImageView *)success failureImage:(UIImageView *)failure
{
    _successStatusAccessoryView = success;
    [_successStatusAccessoryView setFrame:CGRectZero];
    [self addSubview:_successStatusAccessoryView];

    _failureStatusAccessoryView = failure;
    [_failureStatusAccessoryView setFrame:CGRectZero];
    [self addSubview:_failureStatusAccessoryView];

    self.spinnerStatusAccessoryView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    self.spinnerStatusAccessoryView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.spinnerStatusAccessoryView setFrame:CGRectZero];
    self.spinnerStatusAccessoryView.transform = CGAffineTransformMakeScale(kGTIOSpinnerSize/kGTIOSpinnerDefaultSize, kGTIOSpinnerSize/kGTIOSpinnerDefaultSize);

    [self addSubview:self.spinnerStatusAccessoryView];
}

- (void)setStatusIndicatorStatus:(GTIOAlmostDoneTableCellStatus)status
{
    if (!self.successStatusAccessoryView || !self.failureStatusAccessoryView || !self.spinnerStatusAccessoryView) {
        return;
    }
    switch (status){
        case GTIOAlmostDoneTableCellStatusSuccess:
            [self.successStatusAccessoryView setHidden:NO];
            [self.failureStatusAccessoryView setHidden:YES];
            [self.spinnerStatusAccessoryView setHidden:YES];
            [self.spinnerStatusAccessoryView stopAnimating];
        break;
        case GTIOAlmostDoneTableCellStatusFailure:
            [self.successStatusAccessoryView setHidden:YES];
            [self.failureStatusAccessoryView setHidden:NO];
            [self.spinnerStatusAccessoryView setHidden:YES];
            [self.spinnerStatusAccessoryView stopAnimating];
        break;
        case GTIOAlmostDoneTableCellStatusLoading:
            [self.successStatusAccessoryView setHidden:YES];
            [self.failureStatusAccessoryView setHidden:YES];
            [self.spinnerStatusAccessoryView setHidden:NO];
            [self.spinnerStatusAccessoryView startAnimating];
        break;
    }
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
    if (self.usesPicker){
        [self.pickerView selectRowWithLabel:text];
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
        
        CGFloat rightPadding = 0;
        if (self.successStatusAccessoryView){
            rightPadding = self.successStatusAccessoryView.image.size.width +kGTIOAlmostDoneCellStatusPadding;
        }
        [self.cellAccessoryText setFrame:(CGRect){ self.cellTitleLabel.frame.origin.x + self.cellTitleLabel.frame.size.width + 3, self.cellTitleLabel.frame.origin.y, self.frame.size.width - self.cellTitleLabel.frame.size.width - kGTIOAlmostDoneCellRightPadding - kGTIOAlmostDoneCellLeftPadding - rightPadding, self.cellTitleLabel.frame.size.height }];
        
        if (self.successStatusAccessoryView){
            [self.successStatusAccessoryView setFrame:(CGRect){ {self.cellAccessoryText.frame.origin.x + self.cellAccessoryText.frame.size.width  + 2*kGTIOAlmostDoneCellStatusPadding , self.cellAccessoryText.frame.origin.y + 3}, self.successStatusAccessoryView.image.size }];
        }
        if (self.failureStatusAccessoryView){
            
            [self.failureStatusAccessoryView setFrame:(CGRect){ {self.cellAccessoryText.frame.origin.x + self.cellAccessoryText.frame.size.width  + 2*kGTIOAlmostDoneCellStatusPadding, self.cellAccessoryText.frame.origin.y + 3}, self.failureStatusAccessoryView.image.size }];
        }
        if (self.spinnerStatusAccessoryView){
            [self.spinnerStatusAccessoryView setFrame:(CGRect){ {self.cellAccessoryText.frame.origin.x + self.cellAccessoryText.frame.size.width + 2*kGTIOAlmostDoneCellStatusPadding, self.cellAccessoryText.frame.origin.y + 3}, self.failureStatusAccessoryView.image.size }];
        }

    }
}


@end
