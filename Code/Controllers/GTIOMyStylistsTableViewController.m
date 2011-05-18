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

@implementation GTIOMyStylistsTableViewController

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

- (void)cancelButtonPressed:(id)sender {
    [self setEditing:NO animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setRightBarButtonItem:_editButton animated:YES];
    // TODO: revert any unsaved changes.
}

- (void)doneButtonPressed:(id)sender {
    [self setEditing:NO animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setRightBarButtonItem:_editButton animated:YES];
    // TODO: save changes.
}

- (void)editButtonPressed:(id)sender {
    [self setEditing:YES animated:YES];
    [self.navigationItem setLeftBarButtonItem:_cancelButton animated:YES];
    [self.navigationItem setRightBarButtonItem:_doneButton animated:YES];
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
    if (list && list.stylists) {
        NSMutableArray* items = [NSMutableArray array];
        [items addObject:[TTTableTextItem itemWithText:@"find stylists" URL:@"gtio://findStylists"]];
        
        for (GTIOProfile* stylist in list.stylists) {
            NSString* url = [NSString stringWithFormat:@"gtio://profile/%@", stylist.uid];
            TTTableTextItem* item = [TTTableTextItem itemWithText:stylist.displayName URL:url];
            [items addObject:item];
        }
        
        TTListDataSource* ds = [TTListDataSource dataSourceWithItems:items];
        ds.model = model;
        self.dataSource = ds;
    } else {
        [self fail];
    }
}

@end
