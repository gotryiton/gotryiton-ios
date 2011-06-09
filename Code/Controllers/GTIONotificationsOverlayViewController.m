//
//  GTIONotificationsOverlayViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIONotificationsOverlayViewController.h"
#import "GTIOUser.h"
#import "GTIONotification.h"

@interface GTIONotificationTableItem : TTTableImageItem {
    BOOL _unseeen;
}
@property (nonatomic, assign) BOOL unseen;
@end

@implementation GTIONotificationTableItem
@synthesize unseen = _unseen;
@end

@interface GTIONotificationTableItemCell : TTTableImageItemCell
@end

@implementation GTIONotificationTableItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        UIView* separatorView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,0,1)] autorelease];
        separatorView.backgroundColor = RGBCOLOR(225,225,225);
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self.backgroundView addSubview:separatorView];
    }
    return self;
}

- (void)layoutSubviews {
    self.textLabel.font = [UIFont systemFontOfSize:13];
    [super layoutSubviews];
    _imageView2.frame = CGRectMake(8, floor((self.contentView.bounds.size.height - 42) / 2), 42, 42);
    self.textLabel.frame = CGRectMake(8+42+8, floor((self.contentView.bounds.size.height - 42) / 2), 300 - 8 - 42 - 8, 42);
}

- (void)setObject:(id)obj {
    [super setObject:obj];
    if ([(GTIONotificationTableItem*)obj unseen]) {
        self.backgroundView.backgroundColor = RGBCOLOR(255,252,218);
    } else {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

@end

@interface GTIOWelcomeDataSource : TTListDataSource
@end

@implementation GTIOWelcomeDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTTableTextItem* object = (TTTableTextItem*)[self tableView:tableView objectForRowAtIndexPath:indexPath];
    GTIONotification* note = object.userInfo;
    [[GTIOUser currentUser] markNotificationAsSeen:note];
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[GTIONotificationTableItem class]]) {
        return [GTIONotificationTableItemCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}

@end

@implementation GTIONotificationsOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = self.view.bounds;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"full-wallpaper.png"]] autorelease];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.frame = self.view.bounds;
    [self.view insertSubview:imageView atIndex:0];
    // Do any additional setup after loading the view from its nib.
}

- (void)createModel {
    NSArray* notifications = [GTIOUser currentUser].notifications;
    NSLog(@"Notifications: %@", [notifications valueForKey:@"text"]);
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:[notifications count]];
    for (GTIONotification* notification in notifications) {
        GTIONotificationTableItem* item = [GTIONotificationTableItem itemWithText:notification.text imageURL:notification.notificationIcon URL:notification.url];
        item.unseen = ![[GTIOUser currentUser] hasSeenNotification:notification];
        item.userInfo = notification;
        [items addObject:item];
    }
    self.dataSource = [GTIOWelcomeDataSource dataSourceWithItems:items];
    
}

@end
