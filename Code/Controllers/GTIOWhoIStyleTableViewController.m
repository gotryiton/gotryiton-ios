//
//  GTIOWhoIStyleTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/23/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOWhoIStyleTableViewController.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOListSection.h"
#import "GTIOProfile.h"
#import "CustomUISwitch.h"
#import "GTIOBarButtonItem.h"
#import "GTIODropShadowSectionTableViewDelegate.h"
#import "GTIOUserMiniProfileHeaderView.h"

@interface GTIOWhoIStyleTableItem : TTTableImageItem {
    GTIOProfile* _profile;
    id<GTIOWhoIStyleTableItemDelegate> _settingsDelegate;
}

@property (nonatomic, retain) GTIOProfile* profile;
@property (nonatomic, assign) id<GTIOWhoIStyleTableItemDelegate> settingsDelegate;

@end

@implementation GTIOWhoIStyleTableItem

@synthesize profile = _profile;
@synthesize settingsDelegate = _settingsDelegate;

- (void)dealloc {
    [_profile release];
    [super dealloc];
}

@end

@interface GTIOWhoIStyleTableItemCell : TTTableImageItemCell {
    GTIOUserMiniProfileHeaderView* _miniProfileHeaderView;
    UIButton* _silenceButton;
    UIButton* _unsilenceButton;
    UIImageView* _backgroundImage;
    UILabel* _nameLabel;
    UILabel* _alertTextLabel;
    CustomUISwitch* _alertSwitch;
}
@end

@implementation GTIOWhoIStyleTableItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        _backgroundImage = [UIImageView new];
        [_backgroundImage setImage:[UIImage imageNamed:@"istyle-bg.png"]];
        [_backgroundImage setFrame:self.contentView.frame];
        [self.contentView addSubview:_backgroundImage];

        _miniProfileHeaderView = [GTIOUserMiniProfileHeaderView new];
        [self.contentView addSubview:_miniProfileHeaderView];
        
        _silenceButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_silenceButton setImage:[UIImage imageNamed:@"ignore-OFF.png"] forState:UIControlStateNormal];
        [_silenceButton setImage:[UIImage imageNamed:@"ignore-ON.png"] forState:UIControlStateHighlighted];
        [_silenceButton addTarget:self action:@selector(silenceButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_silenceButton];
        
        _unsilenceButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_unsilenceButton setImage:[UIImage imageNamed:@"enable-OFF.png"] forState:UIControlStateNormal];
        [_unsilenceButton setImage:[UIImage imageNamed:@"enable-ON.png"] forState:UIControlStateHighlighted];
        [_unsilenceButton addTarget:self action:@selector(unSilenceButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_unsilenceButton];
        
        _alertSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
        [_alertSwitch addTarget:self action:@selector(alertSwitchToggled:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_alertSwitch];
        
        _alertTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _alertTextLabel.text = @"alerts";
        _alertTextLabel.font = [UIFont boldSystemFontOfSize:12];
        _alertTextLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_alertTextLabel];
        
        [_imageView2 removeFromSuperview];
    }
    return self;
}

- (void)dealloc {
    [_miniProfileHeaderView release];
    [_silenceButton release];
    [_unsilenceButton release];
    [_alertSwitch release];
    [_alertTextLabel release];
    [super dealloc];
}

- (void)alertSwitchToggled:(UISwitch*)sender {
    GTIOWhoIStyleTableItem* item = (GTIOWhoIStyleTableItem*)_item;
    [item.settingsDelegate tableItem:item toggledAlertSwitch:sender];
}

- (void)unSilenceButtonWasPressed:(id)sender {
    GTIOWhoIStyleTableItem* item = (GTIOWhoIStyleTableItem*)_item;
    [item.settingsDelegate tableItem:item unSilenceButtonWasPressed:sender];
}

- (void)silenceButtonWasPressed:(id)sender {
    GTIOWhoIStyleTableItem* item = (GTIOWhoIStyleTableItem*)_item;
    [item.settingsDelegate tableItem:item silenceButtonWasPressed:sender];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textLabel setFrame:CGRectZero];
    self.contentView.frame = CGRectOffset(self.contentView.frame, 0, -5);
    _backgroundImage.frame = CGRectMake(12,12,self.contentView.frame.size.width-24,self.contentView.frame.size.height-12);
    [_alertSwitch sizeToFit];
    _alertTextLabel.frame = CGRectMake(26,67,50,20);
    _alertSwitch.frame = CGRectOffset(_alertSwitch.bounds, 67, 65);
    CGRect buttonRect = CGRectMake(252,69,48,20);
    _unsilenceButton.frame = buttonRect;
    _silenceButton.frame = buttonRect;
}

- (void)setObject:(id)obj {
    [super setObject:obj];
    GTIOWhoIStyleTableItem* item = (GTIOWhoIStyleTableItem*)_item;
    GTIOProfile* profile = item.profile;
    [_miniProfileHeaderView displayProfile:profile];
    
    [_silenceButton setTitle:@"ignore" forState:UIControlStateNormal];
    [_unsilenceButton setTitle:@"enable" forState:UIControlStateNormal];
    
    if ([profile.activeStylist boolValue]) {
        [_unsilenceButton removeFromSuperview];
        [self.contentView addSubview:_silenceButton];
        _alertSwitch.enabled = YES;
        _alertTextLabel.textColor = RGBCOLOR(120,120,120);
    } else {
        [_silenceButton removeFromSuperview];
        [self.contentView addSubview:_unsilenceButton];
        _alertSwitch.enabled = NO;
        _alertTextLabel.textColor = RGBCOLOR(165,165,165);
    }
    _alertSwitch.on = [profile.stylistRequestAlertsEnabled boolValue];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object { 
    return 95; 
}

@end

@interface GTIOWhoIStyleDataSource : TTSectionedDataSource {
}
@end

@implementation GTIOWhoIStyleDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOWhoIStyleTableItem class]]) {
        return [GTIOWhoIStyleTableItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

@implementation GTIOWhoIStyleTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)loadView {
    [super loadView];
    self.title = @"who I style";
    UIImage* settingsButtonImage = [UIImage imageNamed:@"settingsBarButton.png"];
    GTIOBarButtonItem* item  = [[GTIOBarButtonItem alloc] initWithImage:settingsButtonImage target:self action:@selector(settingsButtonAction:)];
    [self.navigationItem setRightBarButtonItem:item];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (id)createDelegate {
    GTIODropShadowSectionTableViewDelegate* delegate = [[[GTIODropShadowSectionTableViewDelegate alloc] initWithController:self] autorelease];
    delegate.footerHeight = 8.0f;
    return delegate;
}

- (void)settingsButtonAction:(id)sender {
	TTOpenURL(@"gtio://settings");
}

- (void)createModel {
    NSString* path = GTIORestResourcePath(@"/i-style");
    NSDictionary* params = [NSDictionary dictionary];
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:nil];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    GTIOBrowseListTTModel* model = [GTIOBrowseListTTModel modelWithObjectLoader:objectLoader];
    
    TTListDataSource* temporaryDataSource = [TTListDataSource dataSourceWithObjects:nil];
    temporaryDataSource.model = model;
    self.dataSource = temporaryDataSource;
}

- (void)didLoadModel:(BOOL)firstTime {
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    NSLog(@"List: %@", model.list);
    NSMutableArray* sectionNames = [NSMutableArray array];
    NSMutableArray* sections = [NSMutableArray array];
    for (GTIOListSection* section in model.list.sections) {
        [sectionNames addObject:section.title];
        NSMutableArray* items  = [NSMutableArray array];
        for (GTIOProfile* stylist in section.stylists) {
            NSString* url = [NSString stringWithFormat:@"gtio://profile/%@", stylist.uid];
            GTIOWhoIStyleTableItem* item = (GTIOWhoIStyleTableItem*)[GTIOWhoIStyleTableItem itemWithText:stylist.displayName imageURL:stylist.profileIconURL URL:url];
            item.profile = stylist;
            item.settingsDelegate = self;
            item.imageStyle = [TTImageStyle styleWithImageURL:nil
                                                 defaultImage:nil
                                                  contentMode:UIViewContentModeScaleAspectFit
                                                         size:CGSizeMake(40,40)
                                                         next:nil];
            [items addObject:item];
        }
        [sections addObject:items];
    }
    
    TTSectionedDataSource* ds = [GTIOWhoIStyleDataSource dataSourceWithItems:sections sections:sectionNames];
    ds.model = self.model;
    self.dataSource = ds;
}

- (void)tableItem:(GTIOWhoIStyleTableItem*)item toggledAlertSwitch:(UISwitch*)alertSwitch {
    RKObjectLoader* loader = nil;
    if ([alertSwitch isOn]) {
        loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath([NSString stringWithFormat:@"/i-style/loud/%@", item.profile.uid]) delegate:nil];                                                          
    } else {
        loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath([NSString stringWithFormat:@"/i-style/quiet/%@", item.profile.uid]) delegate:nil];
    }
    loader.method = RKRequestMethodPOST;
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    [loader send];
}

- (void)tableItem:(GTIOWhoIStyleTableItem*)item silenceButtonWasPressed:(id)sender {
    NSLog(@"sender: %@", sender);
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath([NSString stringWithFormat:@"/i-style/ignore/%@", item.profile.uid]) delegate:nil];                                                          
    loader.method = RKRequestMethodPOST;
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    [loader sendSynchronously];
    [self invalidateModel];
}

- (void)tableItem:(GTIOWhoIStyleTableItem*)item unSilenceButtonWasPressed:(id)sender {
    NSLog(@"sender: %@", sender);
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath([NSString stringWithFormat:@"/i-style/activate/%@", item.profile.uid]) delegate:nil];                                                          
    loader.method = RKRequestMethodPOST;
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    [loader sendSynchronously];
    [self invalidateModel];
}

@end
