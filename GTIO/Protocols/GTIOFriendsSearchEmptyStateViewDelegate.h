//
//  GTIOFriendsSearchEmptyStateViewDelegate.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTIOFriendsSearchEmptyStateViewDelegate <NSObject>

- (void)reloadTableData;
- (void)pushViewController:(UIViewController *)viewController;

@end
