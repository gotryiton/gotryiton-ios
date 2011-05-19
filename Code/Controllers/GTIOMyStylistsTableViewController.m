//
//  GTIOMyStylistsTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/18/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOMyStylistsTableViewController.h"
#import <RestKit/Three20/Three20.h>
#import "GTIOBrowseList.h"
#import "GTIOProfile.h"
#import "NSObject_Additions.h"

@interface GTIOMyStylistsTableViewDelegate : TTTableViewDelegate
@end

@implementation GTIOMyStylistsTableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

@end

@interface GTIOMyStylistsListDataSource : TTListDataSource
@end

@implementation GTIOMyStylistsListDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    _cancelButton = [[UIBarButtonItem alloc] 
                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                   target:self
                   action:@selector(cancelButtonPressed:)];
    _doneButton = [[UIBarButtonItem alloc] 
                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                   target:self
                   action:@selector(doneButtonPressed:)];
    _editButton = [[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
									target:self
									action:@selector(editButtonPressed:)];
	
	self.navigationItem.rightBarButtonItem = _editButton;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_cancelButton release];
    _cancelButton = nil;
    [_doneButton release];
    _doneButton = nil;
    [_editButton release];
    _editButton = nil;
}

- (void)markItemAtIndexPathForDeletion:(NSIndexPath*)indexPath {
    int index = indexPath.row -1;
    [_stylistsToDelete addObject:[_stylists objectAtIndex:index]];
    [_stylists removeObjectAtIndex:index];
}

- (void)cancelButtonPressed:(id)sender {
    [self setEditing:NO animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setRightBarButtonItem:_editButton animated:YES];
    // revert any unsaved changes.
    [(NSObject*)self.model performSelector:@selector(didFinishLoad) withObject:nil afterDelay:0.5];
}

- (void)doneButtonPressed:(id)sender {
    NSLog(@"Stylists to delete: %@", _stylistsToDelete);
    [self setEditing:NO animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setRightBarButtonItem:_editButton animated:YES];
    // Delete from Stylists to Delete
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/remove") delegate:self];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self invalidateModel];
}

- (id)createDelegate {
    return [[[GTIOMyStylistsTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	NSMutableDictionary* params = [NSMutableDictionary dictionary]; // note, query text is usually nil. only used if we are searching.
	
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
    [items addObject:[TTTableTextItem itemWithText:@"find stylists" URL:@"gtio://stylists/add"]];
    
    [_stylists release];
    _stylists = [list.stylists mutableCopy];
    [_stylistsToDelete release];
    _stylistsToDelete = [NSMutableArray new];
    
    for (GTIOProfile* stylist in list.stylists) {
        NSString* url = [NSString stringWithFormat:@"gtio://profile/%@", stylist.uid];
        TTTableTextItem* item = [TTTableTextItem itemWithText:stylist.displayName URL:url];
        [items addObject:item];
    }
    
    TTListDataSource* ds = [GTIOMyStylistsListDataSource dataSourceWithItems:items];
    ds.model = model;
    self.dataSource = ds;
}

@end
