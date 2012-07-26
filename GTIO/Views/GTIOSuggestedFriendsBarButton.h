//
//  GTIOSuggestedFriendsBarView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOSuggestedFriendsBarButton : UIButton

@property (nonatomic, copy) NSString *barTitle;
@property (nonatomic, assign) BOOL hasGreenBackgroundColor;
@property (nonatomic, assign) BOOL showMagnifyingGlassIcon;
@property (nonatomic, strong) NSArray *suggestedFriends;
@property (nonatomic, copy) NSString *routingURL;

@end
