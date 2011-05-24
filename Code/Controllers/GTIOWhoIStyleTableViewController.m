//
//  GTIOWhoIStyleTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/23/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOWhoIStyleTableViewController.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOListSection.h"
#import "GTIOProfile.h"

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
    NSMutableArray* sectionNames = [NSMutableArray array];
    NSMutableArray* sections = [NSMutableArray array];
    for (GTIOListSection* section in model.list.sections) {
        [sectionNames addObject:section.title];
        NSMutableArray* items  = [NSMutableArray array];
        for (GTIOProfile* stylist in section.stylists) {
            NSString* url = [NSString stringWithFormat:@"gtio://profile/%@", stylist.uid];
            TTTableImageItem* item = [TTTableImageItem itemWithText:stylist.displayName imageURL:stylist.profileIconURL URL:url];
            item.imageStyle = [TTImageStyle styleWithImageURL:nil
                                                 defaultImage:nil
                                                  contentMode:UIViewContentModeScaleAspectFit
                                                         size:CGSizeMake(40,40)
                                                         next:nil];
            [items addObject:item];
        }
        [sections addObject:items];
    }
    
    TTSectionedDataSource* ds = [TTSectionedDataSource dataSourceWithItems:sections sections:sectionNames];
    ds.model = self.model;
    self.dataSource = ds;
}


@end
