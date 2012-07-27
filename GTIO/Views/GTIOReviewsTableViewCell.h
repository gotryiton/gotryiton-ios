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
- (void)removeReview:(GTIOReview *)review;
- (void)goToProfileOfUserID:(NSString *)userID;
- (UIView *)viewForSpinner;

@end

@interface GTIOReviewsTableViewCell : UITableViewCell <DTAttributedTextContentViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) GTIOReview *review;
@property (nonatomic, weak) id<GTIOReviewsTableViewCellDelegate> delegate;

+ (CGFloat)heightWithReview:(GTIOReview *)review;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
