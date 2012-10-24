//
//  GTIOIntroExploreLooksViewController.h
//  GTIO
//
//  Created by Simon Holroyd on 10/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "GTIONotificationViewDisplayProtocol.h"
#import "GTIOMasonGridView.h"
#import "GTIOUser.h"

@interface GTIOIntroExploreLooksViewController : GTIOViewController <GTIONotificationViewDisplayProtocol, GTIOMasonGridViewPaginationDelegate>

@property (nonatomic, copy) NSString *resourcePath;
@property (nonatomic, copy) GTIOLoginHandler loginHandler;

@end
