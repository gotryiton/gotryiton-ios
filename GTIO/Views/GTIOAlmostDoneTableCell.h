//
//  GTIOAlmostDoneTableCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOTextFieldForPickerViews.h"

typedef enum GTIOAlmostDoneTableCellStatus {
    GTIOAlmostDoneTableCellStatusSuccess = 0,
    GTIOAlmostDoneTableCellStatusFailure,
    GTIOAlmostDoneTableCellStatusLoading
} GTIOAlmostDoneTableCellStatus;

typedef void(^GTIOAlmostDoneTableCellChangeHandler)(id sender);

@protocol GTIOAlmostDoneTableCellDelegate <NSObject>

@required
- (void)updateDataSourceWithValue:(id)value ForKey:(NSString*)key;

@optional
- (void)scrollUpWhileEditing:(NSUInteger)cellIdentifier;
- (void)resetScrollAfterEditing;
- (void)moveResponderToNextCellFromCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GTIOAlmostDoneTableCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSArray *pickerViewItems;
@property (nonatomic, copy) NSString* apiKey;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger characterLimit;
@property (nonatomic, strong) GTIOTextFieldForPickerViews* cellAccessoryText;
@property (nonatomic, strong) UIView* cellAccessoryView;
@property (nonatomic, weak) id<GTIOAlmostDoneTableCellDelegate> delegate;
@property (nonatomic, copy) GTIOAlmostDoneTableCellChangeHandler changeHandler;

- (void)setCellTitle:(NSString*)title;
- (void)setRequired:(BOOL)required;
- (void)setAccessoryTextUsesPicker:(BOOL)usesPicker;
- (void)setAccessoryTextIsMultipleLines:(BOOL)multipleLines;
- (void)setAccessoryTextPlaceholderText:(NSString*)text;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)setStatusIndicatorWithSuccessImage:(UIImageView *)success failureImage:(UIImageView *)failure;
- (void)setStatusIndicatorStatus:(GTIOAlmostDoneTableCellStatus)status;
- (void)setChangeHandler:(GTIOAlmostDoneTableCellChangeHandler)changeHandler;
- (void)boldInput;

@end
