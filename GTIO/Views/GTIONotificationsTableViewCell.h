//
//  GTIONotificationsTableViewCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIONotification.h"
#import "DTCoreText.h"

@interface GTIONotificationsTableViewCell : UITableViewCell <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) GTIONotification *notification;

+ (CGFloat)heightWithNotification:(GTIONotification *)notification;

@end
