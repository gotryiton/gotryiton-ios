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
    UILabel *cellTitle;
    UITextField *cellAccessoryText;
    UITextView* cellAccessoryTextMulti;
    NSString *placeHolderText;
}

@end

@implementation GTIOAlmostDoneTableCell

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        cellTitle = [[UILabel alloc] initWithFrame:(CGRect){10,self.frame.size.height/2-8,0,0}];
        [cellTitle setBackgroundColor:[UIColor clearColor]];
        [cellTitle setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:14.0]];
        [cellTitle setTextColor:UIColorFromRGB(0xA0A0A0)];
        [self.contentView addSubview:cellTitle];
        
        cellAccessoryText = [[UITextField alloc] initWithFrame:CGRectZero];
        [cellAccessoryText setBackgroundColor:[UIColor clearColor]];
        [cellAccessoryText setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0]];
        [cellAccessoryText setTextColor:UIColorFromRGB(0xA0A0A0)];
        [cellAccessoryText setTextAlignment:UITextAlignmentRight];
        [cellAccessoryText setDelegate:self];
        [self.contentView addSubview:cellAccessoryText];
        
        cellAccessoryTextMulti = [[UITextView alloc] initWithFrame:CGRectZero];
        [cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [cellAccessoryTextMulti setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0]];
        [cellAccessoryTextMulti setBackgroundColor:[UIColor clearColor]];
        [cellAccessoryTextMulti setDelegate:self];
        [cellAccessoryTextMulti setTextColor:UIColorFromRGB(0xA0A0A0)];
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
    if ([textField.text isEqualToString:placeHolderText]) {
        [textField setText:@""];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        [textField setText:placeHolderText];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(scrollUpWhileEditing:)]) {
        [_delegate scrollUpWhileEditing:[self tag]];
    }
    if ([textView.text isEqualToString:placeHolderText]) {
        [textView setText:@""];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        [textView setText:placeHolderText];
    }
}

- (void)setCellTitle:(NSString*)title
{
    [cellTitle setText:title];
    [cellTitle sizeToFit];
    [cellAccessoryTextMulti setFrame:(CGRect){cellTitle.frame.origin.x,cellTitle.frame.origin.y+cellTitle.frame.size.height,self.frame.size.width-40,70}];
}

- (void)setRequired:(BOOL)required
{
    UIColor *textColor = (required) ? UIColorFromRGB(0xFF8285) : UIColorFromRGB(0xA0A0A0);
    [cellTitle setTextColor:textColor];
}

- (void)setAccessoryTextEditable:(BOOL)editable
{
    [cellAccessoryText setEnabled:editable];
    UIFont *placeHolderFont = (editable) ? [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0] : [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:14.0];
    [cellAccessoryText setFont:placeHolderFont];
}

- (void)setAccessoryTextIsMultipleLines:(BOOL)multipleLines
{
    if (multipleLines) {
        [cellAccessoryText removeFromSuperview];
        [cellAccessoryTextMulti setText:placeHolderText];
        [self.contentView addSubview:cellAccessoryTextMulti];
    } else {
        [cellAccessoryTextMulti removeFromSuperview];
        [cellAccessoryText setText:placeHolderText];
        [self.contentView addSubview:cellAccessoryText];
    }
}

- (void)setAccessoryTextPlaceholderText:(NSString*)text
{
    placeHolderText = text;
    [cellAccessoryText setText:text];
    [cellAccessoryText setFrame:(CGRect){cellTitle.frame.origin.x+cellTitle.frame.size.width+3,cellTitle.frame.origin.y,self.frame.size.width-cellTitle.frame.size.width-43,cellTitle.frame.size.height}];
}

@end
