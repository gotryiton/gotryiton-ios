//
//  GTIOAlmostDoneTableCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOTextFieldForPickerViews.h"

@protocol GTIOAlmostDoneTableCellDelegate <NSObject>

@required
- (void)updateDataSourceWithValue:(id)value ForKey:(NSString*)key;

@optional
- (void)scrollUpWhileEditing:(NSUInteger)cellIdentifier;
- (void)resetScrollAfterEditing;
- (void)moveResponderToNextCellFromCell:(NSUInteger)cellIdentifier;

@end

@interface GTIOAlmostDoneTableCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) NSArray *pickerViewItems;
@property (nonatomic, copy) NSString* apiKey;
@property (nonatomic, retain) GTIOTextFieldForPickerViews* cellAccessoryText;
@property (nonatomic, unsafe_unretained) id<GTIOAlmostDoneTableCellDelegate> delegate;

- (void)setCellTitle:(NSString*)title;
- (void)setRequired:(BOOL)required;
- (void)setAccessoryTextUsesPicker:(BOOL)usesPicker;
- (void)setAccessoryTextIsMultipleLines:(BOOL)multipleLines;
- (void)setAccessoryTextPlaceholderText:(NSString*)text;

@end
