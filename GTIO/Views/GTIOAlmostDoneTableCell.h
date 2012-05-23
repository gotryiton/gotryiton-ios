//
//  GTIOAlmostDoneTableCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTIOAlmostDoneTableCellDelegate <NSObject>

@optional
- (void)scrollUpWhileEditing:(NSUInteger)cellIdentifier;
- (void)resetScrollAfterEditing;
- (void)moveResponderToNextCellFromCell:(NSUInteger)cellIdentifier;

@end

@interface GTIOAlmostDoneTableCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) NSArray *pickerViewItems;
@property (nonatomic, unsafe_unretained) id<GTIOAlmostDoneTableCellDelegate> delegate;

- (void)setCellTitle:(NSString*)title;
- (void)setRequired:(BOOL)required;
- (void)setAccessoryTextUsesPicker:(BOOL)usesPicker;
- (void)setAccessoryTextIsMultipleLines:(BOOL)multipleLines;
- (void)setAccessoryTextPlaceholderText:(NSString*)text;

@end
