//
//  GTIOExploreLooksViewController.h
//  GTIO
//
//  Created by Scott Penrose on 5/8/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOViewController.h"
#import "GTIONotificationViewDisplayProtocol.h"
#import "GTIOMasonGridView.h"

@interface GTIOExploreLooksViewController : GTIOViewController <GTIONotificationViewDisplayProtocol, GTIOMasonGridViewPaginationDelegate>

@property (nonatomic, copy) NSString *resourcePath;

@end
