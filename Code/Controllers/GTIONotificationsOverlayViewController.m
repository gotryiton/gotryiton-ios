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

@interface GTIONotificationTableItemCell : TTTableImageItemCell {
    UIView* _mySeparatorView;
}
@end

static float const kNotificationLabelWidth = 250;

@implementation GTIONotificationTableItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    GTIONotificationTableItem* item = (GTIONotificationTableItem*)object;
    CGSize size = [item.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kNotificationLabelWidth, 9999)];
    return MAX(40,size.height + 20);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        _mySeparatorView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,0,1)] autorelease];
        _mySeparatorView.backgroundColor = RGBCOLOR(225,225,225);
        _mySeparatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.backgroundView addSubview:_mySeparatorView];
    }
    return self;
}

- (void)layoutSubviews {
    self.textLabel.font = [UIFont systemFontOfSize:13];
    [super layoutSubviews];
    float width = kNotificationLabelWidth;
    float height = self.textLabel.bounds.size.height;
    if (nil == _imageView2.urlPath) {
        _imageView2.frame = CGRectZero;
        self.textLabel.frame = CGRectMake(8, floor((self.contentView.bounds.size.height - height) / 2), width
                                          , height);
    } else {
        _imageView2.frame = CGRectMake(8, floor((self.contentView.bounds.size.height - 21) / 2), 21, 21);
        self.textLabel.frame = CGRectMake(8+21+8, floor((self.contentView.bounds.size.height - height) / 2), width, height);
    }
}

- (void)setObject:(id)obj {
    [super setObject:obj];
    GTIONotificationTableItem* item = (GTIONotificationTableItem*)obj;
    
    if ([item unseen]) {
        self.backgroundView.backgroundColor = RGBCOLOR(255,252,218);
    } else {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textLabel.numberOfLines = 0;
}

@end

@interface GTIOWelcomeDataSource : TTListDataSource
@end

@implementation GTIOWelcomeDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTTableTextItem* object = (TTTableTextItem*)[self tableView:tableView objectForRowAtIndexPath:indexPath];
    GTIONotification* note = object.userInfo;
    if (note && [note isKindOfClass:[GTIONotification class]]) {
        [[GTIOUser currentUser] markNotificationAsSeen:note];
    }
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidLoginNotificationName object:nil];
        self.variableHeightRows = YES;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)userStateChangedNotification:(NSNotification*)note {
    [self invalidateModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = self.view.bounds;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow-wallpaper.png"]] autorelease];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.frame = self.view.bounds;
    [self.view insertSubview:imageView atIndex:0];
    self.tableView.tableFooterView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list-top-shadow.png"]] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    GTIOAnalyticsEvent(kNotificationsPageEventName);
}

- (void)createModel {
    if ([[GTIOUser currentUser] isLoggedIn]) {
        NSArray* notifications = [GTIOUser currentUser].notifications;
        NSLog(@"Notifications: %@", [notifications valueForKey:@"text"]);
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:[notifications count]];
        for (GTIONotification* notification in notifications) {
            GTIONotificationTableItem* item = [GTIONotificationTableItem itemWithText:notification.text imageURL:notification.notificationIcon URL:notification.url];
            item.unseen = ![[GTIOUser currentUser] hasSeenNotification:notification];
            item.userInfo = notification;
//            item.text = @"This notification will span at least three lines. That means I need it to be longer than it is now. I might need it to be even longer than this. Who knows?!";
            [items addObject:item];
        }
        self.dataSource = [GTIOWelcomeDataSource dataSourceWithItems:items];
    } else {
        self.dataSource = [GTIOWelcomeDataSource dataSourceWithObjects:[GTIONotificationTableItem itemWithText:@"sign in to see your notifications" URL:@"gtio://login"], nil];;
    }
}

@end
