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
}
@end

@implementation GTIOMyStylistTableItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 82.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.font = kGTIOFetteFontOfSize(24);
		_nameLabel.textColor = kGTIOColorBrightPink;
		_nameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_nameLabel];
		
		_locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_locationLabel.font = kGTIOFontHelveticaNeueOfSize(14.5);
		_locationLabel.textColor = kGTIOColorA5A5A5;
		_locationLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_locationLabel];
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mystylists-bg.png"]];
        [self.contentView insertSubview:_backgroundImageView atIndex:0];
        
        _connectionImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:_connectionImageView];
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
    
    _backgroundImageView.frame = CGRectOffset(_backgroundImageView.bounds, 10, 10);
    
    _imageView2.frame = CGRectMake(17,17, 56,56);
    _imageView2.layer.borderColor = RGBCOLOR(74,74,74).CGColor;
    _imageView2.layer.borderWidth = 1;
    
	_nameLabel.frame = CGRectMake(82, 23, 195, 30);
    [_nameLabel sizeToFit];
	
    
    _locationLabel.frame = CGRectMake(82, 43, 210, 30);
    [_locationLabel sizeToFit];
    
    _connectionImageView.frame = CGRectMake(250,60,20,20);
    
    int i = 0;
    for (UIView* view in _badgeImageViews) {
        view.frame = CGRectMake(100+_nameLabel.width+5+i*(16+5), 2+_locationLabel.height, 16, 16);
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
        [self addSubview:imageView];
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
    TWTAlertViewDelegate* delegate = [[TWTAlertViewDelegate new] autorelease];
    [delegate setTarget:self selector:@selector(finishDeleteForIndexPath:) object:[NSArray arrayWithObjects:tableView, indexPath, nil] forButtonIndex:1];
    
    TTTableTextItem* item = (TTTableTextItem*)[self tableView:tableView objectForRowAtIndexPath:indexPath];
    GTIOProfile* profile = (GTIOProfile*)item.userInfo;
    NSString* message = [NSString stringWithFormat:@"your outfits will no longer show in %@'s To-Do list, and they will not be notified when you upload.",profile.firstName];
    
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"remove personal stylist?" message:message delegate:delegate cancelButtonTitle:@"cancel" otherButtonTitles:@"remove", nil] autorelease];
    [alert show];
}

- (void)finishDeleteForIndexPath:(NSArray*)arguments {
    UITableView* tableView = [arguments objectAtIndex:0];
    NSIndexPath* indexPath = [arguments objectAtIndex:1];
    [[(GTIOMyStylistsTableViewDelegate*)tableView.delegate controller] performSelector:@selector(markItemAtIndexPathForDeletion:) withObject:indexPath];
	[tableView beginUpdates];
    [_items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

@end

@implementation GTIOMyStylistsTableViewController

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
    
    _cancelButton = [[GTIOBarButtonItem alloc] initWithTitle:@"Cancel" target:self action:@selector(cancelButtonPressed:)];
    _doneButton = [[GTIOBarButtonItem alloc] initWithTitle:@"Done" target:self action:@selector(doneButtonPressed:)];
    _editButton = [[GTIOBarButtonItem alloc] initWithTitle:@"Edit" target:self action:@selector(editButtonPressed:)];
	
	self.navigationItem.rightBarButtonItem = _editButton;
    
    _addMoreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_addMoreButton setImage:[UIImage imageNamed:@"add-stylists-OFF.png"] forState:UIControlStateNormal];
    [_addMoreButton setImage:[UIImage imageNamed:@"add-stylists-ON.png"] forState:UIControlStateHighlighted];
    [_addMoreButton addTarget:self action:@selector(addButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_addMoreButton sizeToFit];
    _addMoreButton.frame = CGRectOffset(_addMoreButton.bounds, 0, self.view.bounds.size.height - _addMoreButton.bounds.size.height);
    [self.view addSubview:_addMoreButton];
    self.tableView.frame = CGRectMake(0,0,320,self.view.bounds.size.height - _addMoreButton.bounds.size.height + 6);
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
    self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem homeBackBarButtonWithTarget:[GTIOBarButtonItem class] action:@selector(backButtonAction)];
    [self.navigationItem setRightBarButtonItem:_editButton animated:YES];
    // revert any unsaved changes.
    [(NSObject*)self.model performSelector:@selector(didFinishLoad) withObject:nil afterDelay:0.5];
}

- (void)doneButtonPressed:(id)sender {
    NSLog(@"Stylists to delete: %@", _stylistsToDelete);
    [self setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem homeBackBarButtonWithTarget:[GTIOBarButtonItem class] action:@selector(backButtonAction)];
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
    [self.navigationItem setLeftBarButtonItem:_cancelButton animated:YES];
    [self.navigationItem setRightBarButtonItem:_doneButton animated:YES];
}

- (void)addButtonWasPressed:(id)sender {
    TTOpenURL(@"gtio://stylists/add");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self invalidateModel];
}

- (id)createDelegate {
    return [[[GTIOMyStylistsTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	NSMutableDictionary* params = [NSMutableDictionary dictionary];
	
    RKRequestTTModel* model = [[[RKRequestTTModel alloc] initWithResourcePath:GTIORestResourcePath(@"/stylists")
                                                                                 params:[GTIOUser paramsByAddingCurrentUserIdentifier:params]
                                                                                 method:RKRequestMethodPOST] autorelease];
    
    TTListDataSource* temporaryDataSource = [TTListDataSource dataSourceWithObjects:nil];
    temporaryDataSource.model = model;
    self.dataSource = temporaryDataSource;
}

- (void)fail {
    [self.model performSelector:@selector(didFailLoadWithError:) withObject:[NSError errorWithDomain:@"GTIO Error" code:0 userInfo:nil]];
}

- (void)didLoadModel:(BOOL)firstTime {
    RKRequestTTModel* model = (RKRequestTTModel*)self.model;
    
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
}

@end
