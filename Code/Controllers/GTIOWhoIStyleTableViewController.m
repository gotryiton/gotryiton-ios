//
//  GTIOWhoIStyleTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/23/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOWhoIStyleTableViewController.h"
#import "GTIOBrowseListTTModel.h"

@implementation GTIOWhoIStyleTableViewController

- (void)loadView {
    [super loadView];
    self.title = @"who i style";
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
    if (nil == model.list) {
        // I don't style anyone
        
    }
}


@end
