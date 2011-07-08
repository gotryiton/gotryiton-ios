//
//  GTIOMyStylistsTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOMyStylistsTableViewController.h"
#import <RestKit/Three20/Three20.h>
#import "GTIOBrowseList.h"
#import "GTIOProfile.h"
#import "NSObject_Additions.h"
#import <TWTAlertViewDelegate.h>
#import "GTIOHeaderView.h"
#import "GTIOBadge.h"
#import "GTIOHomeViewController.h"

@interface GTIOMyStylistTableItem : TTTableImageItem {
@private
    GTIOProfile* _profile;
}

@property (nonatomic, retain) GTIOProfile* profile;
@end
@implementation GTIOMyStylistTableItem

@synthesize profile = _profile;

@end

@interface GTIOMyStylistTableItemCell : TTTableImageItemCell {
	UILabel* _nameLabel;
	UILabel* _locationLabel;
    NSMutableArray* _badgeImageViews;
    UIImageView* _backgroundImageView;
    UIImageView* _connectionImageView;
    UIImageView* _borderImageView;
}
@end

@implementation GTIOMyStylistTableItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 82.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.font = kGTIOFetteFontOfSize(25);
		_nameLabel.textColor = kGTIOColorBrightPink;
		_nameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_nameLabel];
		
		_locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_locationLabel.font = kGTIOFontHelveticaNeueOfSize(13);
		_locationLabel.textColor = RGBCOLOR(130,130,130);
		_locationLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_locationLabel];
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mystylists-bg.png"]];
        [self.contentView insertSubview:_backgroundImageView atIndex:0];
        
        _connectionImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:_connectionImageView];
        
        _borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-overlay-110.png"]];
		[[self contentView] addSubview:_borderImageView];
    }
    return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_nameLabel);
	TT_RELEASE_SAFELY(_locationLabel);
    TT_RELEASE_SAFELY(_badgeImageViews);
    TT_RELEASE_SAFELY(_backgroundImageView);
    TT_RELEASE_SAFELY(_connectionImageView);
	[super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundImageView.frame = CGRectOffset(_backgroundImageView.bounds, 10, 10-5);
    
    _imageView2.frame = CGRectMake(17+0.5,17-5+0.5, 56,56);
    _borderImageView.frame = CGRectInset(_imageView2.frame, -4,-4);
    
	_nameLabel.frame = CGRectMake(82+4, 24-5+1.5, 195, 30);
    [_nameLabel sizeToFit];
	
    
    _locationLabel.frame = CGRectMake(82+4, CGRectGetMaxY(_nameLabel.frame)+2+2 - 5, 210, 18);
    [_locationLabel sizeToFit];
    
    _connectionImageView.frame = CGRectMake(255,57,17,16);
    
    int i = 0;
    for (UIView* view in _badgeImageViews) {
        view.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+2+(i*23), 19, 24, 24);
        i++;
    }
}

- (void)setObject:(id)obj {
    [super setObject:obj];
	
    GTIOProfile* profile = [(GTIOMyStylistTableItem*)_item profile];
    
    _connectionImageView.image = [profile.stylistRelationship imageForConnection];
    
    self.textLabel.text = nil;
    
	_nameLabel.text = [[profile displayName] uppercaseString];
	_locationLabel.text = profile.location;
    
    for (UIView* view in _badgeImageViews) {
        [view removeFromSuperview];
    }
    [_badgeImageViews release];
    _badgeImageViews = [NSMutableArray new];
    for (GTIOBadge* badge in profile.badges) {
        TTImageView* imageView = [[TTImageView alloc] initWithFrame:CGRectMake(0,0,16,16)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.urlPath = badge.imgURL;
        [self.contentView addSubview:imageView];
        [_badgeImageViews addObject:imageView];
    }
    
	
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

@interface GTIOMyStylistsTableViewDelegate : TTTableViewVarHeightDelegate
@end

@implementation GTIOMyStylistsTableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end

@interface GTIOMyStylistsListDataSource : TTListDataSource
@end

@implementation GTIOMyStylistsListDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOMyStylistTableItem class]]) {
        return [GTIOMyStylistTableItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[(GTIOMyStylistsTableViewDelegate*)tableView.delegate controller] performSelector:@selector(markItemAtIndexPathForDeletion:) withObject:indexPath];
    GTIOAnalyticsEvent(kUserDeletedStylistEventName);
	[tableView beginUpdates];
    [_items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

@end

@implementation GTIOMyStylistsTableViewController

- (id)initWithEditEnabled {
    if ((self = [self initWithStyle:UITableViewStylePlain])) {
        _startInEditingState = YES;
    }
    return self;
}

- (void)dealloc {
    [_stylistsToDelete release];
    [_stylists release];
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"MY STYLISTS"];
    self.variableHeightRows = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _cancelButton = [[GTIOBarButtonItem alloc] initWithTitle:@"cancel" target:self action:@selector(cancelButtonPressed:)];
    _doneButton = [[GTIOBarButtonItem alloc] initWithTitle:@"done" target:self action:@selector(doneButtonPressed:)];
    _editButton = [[GTIOBarButtonItem alloc] initWithTitle:@"edit" target:self action:@selector(editButtonPressed:)];
	
	self.navigationItem.rightBarButtonItem = _editButton;
    
    UIImage* topShadow = [UIImage imageNamed:@"list-top-shadow.png"];
    UIView* topShadowImageView = [[[UIImageView alloc] initWithImage:topShadow] autorelease];
    [self.view addSubview:topShadowImageView];
}

- (void)setupAddMoreButton {
    if (nil == _addMoreButton) {
        _addMoreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_addMoreButton setImage:[UIImage imageNamed:@"add-stylists-OFF.png"] forState:UIControlStateNormal];
        [_addMoreButton setImage:[UIImage imageNamed:@"add-stylists-ON.png"] forState:UIControlStateHighlighted];
        [_addMoreButton addTarget:self action:@selector(addButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_addMoreButton sizeToFit];
        _addMoreButton.frame = CGRectOffset(_addMoreButton.bounds, 0, self.view.bounds.size.height - _addMoreButton.bounds.size.height);
        [self.view addSubview:_addMoreButton];
        self.tableView.frame = CGRectMake(2,0,320,self.view.bounds.size.height - _addMoreButton.bounds.size.height + 6);
        self.tableView.contentInset = UIEdgeInsetsMake(7, 0, 7, 0);
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_cancelButton release];
    _cancelButton = nil;
    [_doneButton release];
    _doneButton = nil;
    [_editButton release];
    _editButton = nil;
    [_addMoreButton release];
    _addMoreButton = nil;
}

- (void)markItemAtIndexPathForDeletion:(NSIndexPath*)indexPath {
    int index = indexPath.row;
    [_stylistsToDelete addObject:[_stylists objectAtIndex:index]];
    [_stylists removeObjectAtIndex:index];
}

- (void)cancelButtonPressed:(id)sender {
    [self setEditing:NO animated:YES];
    
    if ([self.parentViewController isKindOfClass:[GTIOHomeViewController class]]) {
        self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem homeBackBarButtonWithTarget:[GTIOBarButtonItem class] action:@selector(backButtonAction)];
    } else {
        self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem backButton];
    }
    [self.navigationItem setRightBarButtonItem:_editButton animated:YES];
    // revert any unsaved changes.
    [(NSObject*)self.model performSelector:@selector(didFinishLoad) withObject:nil afterDelay:0.5];
}

- (void)doneButtonPressed:(id)sender {
    NSLog(@"Stylists to delete: %@", _stylistsToDelete);
    [self setEditing:NO animated:YES];
    if ([self.parentViewController isKindOfClass:[GTIOHomeViewController class]]) {
        self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem homeBackBarButtonWithTarget:[GTIOBarButtonItem class] action:@selector(backButtonAction)];
    } else {
        self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem backButton];
    }
    [self.navigationItem setRightBarButtonItem:_editButton animated:YES];
    // Delete from Stylists to Delete
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/remove") delegate:nil];
    id ids = [[_stylistsToDelete valueForKey:@"uid"] jsonEncode];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:ids, @"stylistUids", nil];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    loader.method = RKRequestMethodPOST;
    [loader sendSynchronously];
    [self invalidateModel];
}

- (void)editButtonPressed:(id)sender {
    [self setEditing:YES animated:YES];
    GTIOAnalyticsEvent(kEditStylistsEventName);

    [self.navigationItem setLeftBarButtonItem:_cancelButton animated:YES];
    [self.navigationItem setRightBarButtonItem:_doneButton animated:YES];
}

- (void)addButtonWasPressed:(id)sender {
    TTOpenURL(@"gtio://stylists/add");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self invalidateModel];
    GTIOAnalyticsEvent(kMyStylistsEventName);
}

- (id)createDelegate {
    return [[[GTIOMyStylistsTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	NSMutableDictionary* params = [NSMutableDictionary dictionary];
	
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists") delegate:nil];
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    objectLoader.method = RKRequestMethodPOST;
    RKObjectLoaderTTModel* model = [RKObjectLoaderTTModel modelWithObjectLoader:objectLoader];
    
    TTListDataSource* temporaryDataSource = [TTListDataSource dataSourceWithObjects:nil];
    temporaryDataSource.model = model;
    self.dataSource = temporaryDataSource;
}

- (void)fail {
    [self.model performSelector:@selector(didFailLoadWithError:) withObject:[NSError errorWithDomain:@"GTIO Error" code:0 userInfo:nil]];
}

- (void)didLoadModel:(BOOL)firstTime {
    [self setupAddMoreButton];
    
    RKObjectLoaderTTModel* model = (RKObjectLoaderTTModel*)self.model;
    
    GTIOBrowseList* list = [model.objects objectWithClass:[GTIOBrowseList class]];
    NSLog(@"List: %@", list);
    NSMutableArray* items = [NSMutableArray array];
    
    [_stylists release];
    _stylists = [list.stylists mutableCopy];
    [_stylistsToDelete release];
    _stylistsToDelete = [NSMutableArray new];
    
    for (GTIOProfile* stylist in list.stylists) {
        NSString* url = [NSString stringWithFormat:@"gtio://profile/%@", stylist.uid];
        GTIOMyStylistTableItem* item = [GTIOMyStylistTableItem itemWithText:nil imageURL:stylist.profileIconURL URL:url];
        item.profile = stylist;
        // TODO: refactor.
        item.userInfo = stylist;
        item.imageStyle = [TTImageStyle styleWithImageURL:nil
                                             defaultImage:nil
                                              contentMode:UIViewContentModeScaleAspectFit
                                                     size:CGSizeMake(40,40)
                                                     next:nil];
        [items addObject:item];
    }
    
    TTListDataSource* ds = [GTIOMyStylistsListDataSource dataSourceWithItems:items];
    ds.model = model;
    self.dataSource = ds;
    
    if (_startInEditingState) {
        _startInEditingState = NO;
        [self editButtonPressed:nil];
    }
}

- (void)showEmpty:(BOOL)show {
    if (show) {
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pspush.png"]] autorelease];
        
        GTIOAnalyticsEvent(kStylistsIntroEventName);
        
        UIButton* invisibleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        invisibleButton.frame = imageView.bounds;
        [invisibleButton addTarget:self action:@selector(addButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:invisibleButton];
        
        UIButton* addButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [addButton setImage:[UIImage imageNamed:@"pspush-add-button-OFF.png"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"pspush-add-button-ON.png"] forState:UIControlStateHighlighted];
        [addButton addTarget:self action:@selector(addButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        addButton.frame = CGRectMake(8,self.view.bounds.size.height - 54, 304, 48);
        [imageView addSubview:addButton];
        self.emptyView = imageView;
        [self.view addSubview:imageView];
        imageView.frame = self.view.bounds;
        
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.emptyView = nil;
        self.navigationItem.rightBarButtonItem = _editButton;
    }
}

@end
