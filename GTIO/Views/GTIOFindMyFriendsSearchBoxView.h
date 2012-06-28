//
//  GTIOFindMyFriendsSearchBoxView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOFindMyFriendsSearchBoxView : UIView

@property (nonatomic, copy) NSString *subTitleText;
@property (nonatomic, copy) NSString *searchBarPlaceholder;
@property (nonatomic, weak) id<UISearchBarDelegate> searchBarDelegate;

@property (nonatomic, assign) BOOL showFollowingLabel;

@end
