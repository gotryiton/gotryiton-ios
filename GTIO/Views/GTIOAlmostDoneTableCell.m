//
//  GTIOAlmostDoneTableCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlmostDoneTableCell.h"

@interface GTIOAlmostDoneTableCell() {
@private
    UILabel* _cellTitle;
    UITextField* _cellAccessoryText;
    UITextView* _cellAccessoryTextMulti;
    NSString* _placeHolderText;
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
        [self.contentView addSubview:_cellAccessoryText];
        
        _cellAccessoryTextMulti = [[UITextView alloc] initWithFrame:CGRectZero];
        [_cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [_cellAccessoryTextMulti setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0]];
        [_cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [_cellAccessoryTextMulti setDelegate:self];
        [_cellAccessoryTextMulti setTextColor:UIColorFromRGB(0xA0A0A0)];
        
        _usesPicker = NO;
        _placeHolderText = @"";
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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
    if ([textField.text isEqualToString:@""] && !_usesPicker) {
        [textField setText:_placeHolderText];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(scrollUpWhileEditing:)]) {
        [_delegate scrollUpWhileEditing:[self tag]];
    }
    if ([textView.text isEqualToString:_placeHolderText] && !_usesPicker) {
        [textView setText:@""];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""] && !_usesPicker) {
        [textView setText:_placeHolderText];
    }
}

- (void)setCellTitle:(NSString*)title
{
    [_cellTitle setText:title];
    [_cellTitle sizeToFit];
    [_cellAccessoryTextMulti setFrame:(CGRect){_cellTitle.frame.origin.x,_cellTitle.frame.origin.y+_cellTitle.frame.size.height,self.frame.size.width-40,70}];
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

- (void)setAccessoryTextIsMultipleLines:(BOOL)multipleLines
{
    _multiLine = multipleLines;
    if (multipleLines) {
        [_cellAccessoryText removeFromSuperview];
        [_cellAccessoryTextMulti setText:_placeHolderText];
        [self.contentView addSubview:_cellAccessoryTextMulti];
    } else {
        [_cellAccessoryTextMulti removeFromSuperview];
        [_cellAccessoryText setText:_placeHolderText];
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
    [_cellAccessoryText setText:text];
    [_cellAccessoryText setFrame:(CGRect){_cellTitle.frame.origin.x+_cellTitle.frame.size.width+3,_cellTitle.frame.origin.y,self.frame.size.width-_cellTitle.frame.size.width-43,_cellTitle.frame.size.height}];
}

@end
