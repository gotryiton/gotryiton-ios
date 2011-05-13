//
//  GTIOBrowseTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOBrowseTableViewController.h"
#import "GTIOCategory.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOOutfitTableViewCell.h"
#import "GTIOGiveAnOpinionTableViewDataSource.h"
#import "GTIOPaginationTableViewDelegate.h"

@interface GTIOBrowseListDataSource : TTListDataSource
@end

@implementation GTIOBrowseListDataSource

- (TTTableItem*)tableItemForObject:(id)object {
	if ([object isKindOfClass:[GTIOOutfit class]]) {
		return [GTIOOutfitTableViewItem itemWithOutfit:object];
	} else {
		return [TTTableTextItem itemWithText:[object description]];
	}
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOOutfitTableViewItem class]]) {
		return [GTIOOutfitTableViewCell class];	
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

- (NSString*)titleForEmpty {
	return @"Nothing Here";
}

@end

@interface GTIOBrowseSectionedDataSource: TTSectionedDataSource
@end
@implementation GTIOBrowseSectionedDataSource
@end

@interface GTIOSectionedDataSourceWithIndexSidebar : GTIOBrowseSectionedDataSource
@end

@implementation GTIOSectionedDataSourceWithIndexSidebar

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

@end

@implementation GTIOBrowseTableViewController

@synthesize apiEndpoint = _apiEndpoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.apiEndpoint = GTIORestResourcePath(@"/categories");
        self.variableHeightRows = YES;
        
    }
    return self;
}

- (id)initWithAPIEndpoint:(NSString*)endpoint {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        endpoint = [endpoint stringByReplacingOccurrencesOfString:@"." withString:@"/"];
        self.apiEndpoint = endpoint;
        NSLog(@"Endpoint: %@", endpoint);
    }
    return self;
}

- (TTTableViewDelegate*)createDelegate {
    return [[[GTIOPaginationTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	
    GTIOBrowseListTTModel* model = [[[GTIOBrowseListTTModel alloc] initWithResourcePath:_apiEndpoint
                                                                                 params:[GTIOUser paramsByAddingCurrentUserIdentifier:params]
                                                                                 method:RKRequestMethodPOST] autorelease];
    
    TTListDataSource* temporaryDataSource = [TTListDataSource dataSourceWithObjects:nil];
    temporaryDataSource.model = model;
    self.dataSource = temporaryDataSource;
}

- (void)fail {
    [self.model performSelector:@selector(didFailLoadWithError:) withObject:[NSError errorWithDomain:@"GTIO Error" code:0 userInfo:nil]];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    [self fail];
}
- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader*)objectLoader {
    [self fail];
}

- (void)didLoadMore {
    NSLog(@"DidLoadMore");
    GTIOBrowseListDataSource* ds = (GTIOBrowseListDataSource*)self.dataSource;
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    
    [self.tableView beginUpdates];
    NSMutableArray* items = [[model.objects mutableCopy] autorelease];
    for (GTIOOutfitTableViewItem* item in ds.items) {
        [items removeObject:item];
    }
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (GTIOOutfit* outfit in items) {
        GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
        [ds.items addObject:item];
        [indexPaths addObject:[NSIndexPath indexPathForRow:[ds.items indexOfObject:item] inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (void)loadedList:(GTIOBrowseList*)list {
    // TODO: simplify/refactor this.
    if (list) {
        self.title = list.title;
        
        if (list.categories) {
            if ([list.includeAlphaNav boolValue]) {
                NSArray* sections = [@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,#" componentsSeparatedByString:@","];
                NSMutableDictionary* dict = [NSMutableDictionary dictionary];
                for (GTIOCategory* category in list.categories) {
                    NSString* upcasedFirstCharacterOfName = [[category.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                    if ([sections indexOfObject:upcasedFirstCharacterOfName] == NSNotFound) {
                        upcasedFirstCharacterOfName = @"#";
                    }
                    NSMutableArray* items = [dict objectForKey:upcasedFirstCharacterOfName];
                    if (nil == items) {
                        items = [NSMutableArray array];
                        [dict setObject:items forKey:upcasedFirstCharacterOfName];
                    }
                    NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [category.apiEndpoint stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
                    TTTableTextItem* item = [TTTableTextItem itemWithText:category.name URL:url];
                    [items addObject:item];
                }
                GTIOSectionedDataSourceWithIndexSidebar* ds = (GTIOSectionedDataSourceWithIndexSidebar*)[GTIOSectionedDataSourceWithIndexSidebar dataSourceWithItems:[NSMutableArray array] sections:[NSMutableArray array]];
                for (NSString* key in sections) {
                    NSMutableArray* obj = [dict objectForKey:key];
                    if (obj) {
                        [ds.sections addObject:key];
                        [ds.items addObject:obj];
                    }
                }
                ds.model = self.model;
                self.dataSource = ds;
            } else {
                NSMutableArray* items = [NSMutableArray array];
                for (GTIOCategory* category in list.categories) {
                    NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [category.apiEndpoint stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
                    NSLog(@"URL: %@", url);
                    TTTableTextItem* item = [TTTableTextItem itemWithText:category.name URL:url];
                    [items addObject:item];
                }
                
                // TODO: show search bar if used. 
                
                if (list.subtitle) {
                    TTSectionedDataSource* ds = [GTIOBrowseSectionedDataSource dataSourceWithArrays:list.subtitle, items, nil];
                    ds.model = self.model;
                    self.dataSource = ds;
                } else {
                    TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:items];
                    ds.model = self.model;
                    self.dataSource = ds;
                }
            }
        } else if (list.outfits) {
            NSMutableArray* items = [NSMutableArray array];
            for (GTIOOutfit* outfit in list.outfits) {
                GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
                [items addObject:item];
            }
            TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:items];
            ds.model = self.model;
            self.dataSource = ds;
        } else {
            TTListDataSource* ds = [GTIOBrowseListDataSource dataSourceWithItems:[NSMutableArray array]];
            ds.model = self.model;
            self.dataSource = ds;
        }
    } else {
        // no list was loaded. hrm...
        [self fail];
    }
}

- (void)didLoadModel:(BOOL)firstTime {
    if (firstTime) {
        NSLog(@"Loaded First Time!");
        GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
        [self loadedList:model.list];
    } else {
        [self didLoadMore];
    }
}

@end
