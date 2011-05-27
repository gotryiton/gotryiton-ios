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
        
        _silenceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_silenceButton addTarget:self action:@selector(silenceButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_silenceButton];
        
        _unsilenceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_unsilenceButton addTarget:self action:@selector(unSilenceButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_unsilenceButton];
        
        _alertSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
        [_alertSwitch addTarget:self action:@selector(alertSwitchToggled:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_alertSwitch];
    }
    return self;
}

- (void)dealloc {
    [_alertSwitch release];
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
    _backgroundImage.frame = CGRectMake(12,10,self.contentView.frame.size.width-24,self.contentView.frame.size.height-10);
    [_alertSwitch sizeToFit];
    _alertSwitch.frame = CGRectOffset(_alertSwitch.bounds, 220, 10);
    _unsilenceButton.frame = CGRectMake(140,10,30,30);
    _silenceButton.frame = CGRectMake(180,10,30,30);
}

- (void)setObject:(id)obj {
    [super setObject:obj];
    GTIOWhoIStyleTableItem* item = (GTIOWhoIStyleTableItem*)_item;
    GTIOProfile* profile = item.profile;
    [_miniProfileHeaderView displayProfile:profile];
    
    [_silenceButton setTitle:@"N" forState:UIControlStateNormal];
    [_unsilenceButton setTitle:@"Y" forState:UIControlStateNormal];
    
    [_silenceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_silenceButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_unsilenceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_unsilenceButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    if ([profile.activeStylist boolValue]) {
        _silenceButton.selected = YES;
        _unsilenceButton.selected = NO;
        [self.contentView addSubview:_alertSwitch];
    } else {
        _silenceButton.selected = NO;
        _unsilenceButton.selected = YES;
        [_alertSwitch removeFromSuperview];
    }
    _alertSwitch.on = [profile.stylistRequestAlertsEnabled boolValue];
    self.accessoryType = UITableViewCellAccessoryNone;
}


+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object { 
    return 92.5; 
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

- (void)loadView {
    [super loadView];
    self.title = @"who i style";
    UIImage* settingsButtonImage = [UIImage imageNamed:@"settingsBarButton.png"];
    GTIOBarButtonItem* item  = [[GTIOBarButtonItem alloc] initWithImage:settingsButtonImage target:self action:@selector(settingsButtonAction:)];
    [self.navigationItem setRightBarButtonItem:item];
}

- (id)createDelegate {
    return [[GTIODropShadowSectionTableViewDelegate new] autorelease];
}

- (void)settingsButtonAction:(id)sender {
	TTOpenURL(@"gtio://settings");
}

- (void)createModel {
    NSString* path = GTIORestResourcePath(@"/i-style");
    NSDictionary* params = [NSDictionary dictionary];
    GTIOBrowseListTTModel* model = [[[GTIOBrowseListTTModel alloc] initWithResourcePath:path
                                                                                 params:[GTIOUser paramsByAddingCurrentUserIdentifier:params]
                                                                                 method:RKRequestMethodPOST] autorelease];
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
