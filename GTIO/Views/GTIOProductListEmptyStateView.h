//
//  GTIOProductListEmptyStateView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOProductListEmptyStateView : UIView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title linkText:(NSString *)linkText linkTapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
