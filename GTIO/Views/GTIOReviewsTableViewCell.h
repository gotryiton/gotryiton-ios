//
//  GTIOReviewsTableViewCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOReview.h"
#import "DTCoreText.h"

@protocol GTIOReviewsTableViewCellDelegate <NSObject>

@required
- (void)updateDataSourceWithReview:(GTIOReview *)review atIndexPath:(NSIndexPath *)indexPath;
- (void)removeReviewAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)viewForSpinner;

@end

@interface GTIOReviewsTableViewCell : UITableViewCell <DTAttributedTextContentViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) GTIOReview *review;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<GTIOReviewsTableViewCellDelegate> delegate;

+ (CGFloat)heightWithReview:(GTIOReview *)review;

@end
