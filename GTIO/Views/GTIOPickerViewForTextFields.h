//
//  GTIOPickerViewForTextFields.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOPickerViewForTextFields : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSArray *pickerItems;
@property (nonatomic, copy) NSString *placeHolderText;

- (id)initWithFrame:(CGRect)frame andPickerItems:(NSArray *)pickerItems;
- (NSString *)selectedRowLabel;
- (void)bindToTextField:(UITextField *)textField;

@end
