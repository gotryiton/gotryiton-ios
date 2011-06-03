//
//  GTIOBrowseTableViewControllerSpec.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIQuery.h"
#import "UISpec.h"
#import "UIExpectation.h"
#import <RestKit/RestKit.h>
#import "GTIOCategory.h"
#import "GTIOBrowseList.h"
#import "GTIOOutfit.h"
#import "GTIOReview.h"
#import "GTIOBrowseTableViewController.h"
#import "GTIOPaginatedTTModel.h"
#import "GTIOBrowseListPresenter.h"
#import "GTIOListSection.h"
#import "GTIOSortTab.h"

@interface GTIOBrowseTableViewControllerSpec : NSObject <UISpec> {
    UIQuery* _app;
}
@end

@implementation GTIOBrowseTableViewControllerSpec

//- (void)before {
//    [[RKObjectManager sharedManager].client setBaseURL:@"http://10.0.1.8:4567"];
//    
//    _app = [UIQuery withApplication];
//    [_app wait:1];
//    [[GTIOUser currentUser] setLoggedIn:YES];
//    [_app wait:1];
//    TTOpenURL(@"gtio://home");
//    [_app wait:1];
//}
//
//- (void)after {
//    [_app release];
//    _app = nil;
//}
//
//- (void)itShouldShowAllCategories {
//    // /rest/v3/categories
//    TTOpenURL(@"gtio://browse");
//    [_app wait:1];
//    [[[_app label] text:@"popular"] should].exist;
//    [[[_app label] text:@"recent"] should].exist;
//    [[[_app label] text:@"brands"] should].exist;
//    [[[_app label] text:@"events"] should].exist;
//}
//
//- (void)itShouldLetMeSearch {
//    // /rest/v3/categories
//    TTOpenURL(@"gtio://browse");
//    [_app wait:1];
//    UIQuery* searchBar = [_app view:@"UISearchBar"];
//    [searchBar setText:@"a night out"];
//    http://iphonedev.gotryiton.com/rest/v3/search. HTTP Body: query=a%20night%20out&gtioToken=62fd2eb677b87355fd87c6610f11138b
//    [[searchBar delegate] searchBarSearchButtonClicked:searchBar];
//    [_app wait:1];
//    // TODO: finish this spec
//    @"";
//}

#pragma mark GTIOCategory

- (void)itShouldEscapeTheCategoryAPIEndpoints {
    GTIOCategory* category = [[[GTIOCategory alloc] init] autorelease];
    category.apiEndpoint = @"escape/this/api/endpoint";
    [expectThat(category.escapedAPIEndpoint) should:be(@"escape.this.api.endpoint")];
}

#pragma mark GTIOBrowseList

- (void)itShouldTurnTheBrowseListIntoTableItemsWhenItIsAListOfCategories {
    GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
    GTIOCategory* category1 = [[GTIOCategory new] autorelease];
    category1.name = @"Category 1";
    category1.apiEndpoint = @"/api/endpoint/1";
    category1.iconSmallURL = @"http://bogus.url/1.jpg";
    GTIOCategory* category2 = [[GTIOCategory new] autorelease];
    category2.name = @"Category 2";
    category2.apiEndpoint = @"/api/endpoint/2";
    category2.iconSmallURL = @"http://bogus.url/2.jpg";
    GTIOCategory* category3 = [[GTIOCategory new] autorelease];
    category3.name = @"Category 3";
    category3.apiEndpoint = @"/api/endpoint/3";
    category3.iconSmallURL = @"http://bogus.url/3.jpg";
    list.categories = [NSArray arrayWithObjects:category1, category2, category3, nil];
    GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
    
    NSArray* tableItems = presenter.tableItems;
    [expectThat([tableItems count]) should:be(3)];
    TTTableImageItem* item = [tableItems objectAtIndex:0];
    [expectThat(NSStringFromClass([item class])) should:be(NSStringFromClass([TTTableImageItem class]))];
    [expectThat(item.text) should:be(@"Category 1")];
    [expectThat(item.imageURL) should:be(@"http://bogus.url/1.jpg")];
    [expectThat(item.URL) should:be(@"gtio://browse/.api.endpoint.1")];
}

- (void)itShouldTurnTheBrowseListIntoTableItemsWhenItIsAListOfCategoriesAndIHaveSearchText {
    GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
    GTIOCategory* category1 = [[GTIOCategory new] autorelease];
    category1.name = @"Category 1";
    category1.apiEndpoint = @"/api/endpoint/1";
    category1.iconSmallURL = @"http://bogus.url/1.jpg";
    GTIOCategory* category2 = [[GTIOCategory new] autorelease];
    category2.name = @"Category 2";
    category2.apiEndpoint = @"/api/endpoint/2";
    category2.iconSmallURL = @"http://bogus.url/2.jpg";
    GTIOCategory* category3 = [[GTIOCategory new] autorelease];
    category3.name = @"Category 3";
    category3.apiEndpoint = @"/api/endpoint/3";
    category3.iconSmallURL = @"http://bogus.url/3.jpg";
    list.categories = [NSArray arrayWithObjects:category1, category2, category3, nil];
    GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
    
    NSArray* tableItems = [presenter tableItemsWithSearchText:@"Category 2"];
    [expectThat([tableItems count]) should:be(1)];
    TTTableImageItem* item = [tableItems objectAtIndex:0];
    [expectThat(NSStringFromClass([item class])) should:be(NSStringFromClass([TTTableImageItem class]))];
    [expectThat(item.text) should:be(@"Category 2")];
    [expectThat(item.imageURL) should:be(@"http://bogus.url/2.jpg")];
    [expectThat(item.URL) should:be(@"gtio://browse/.api.endpoint.2")];
    
    tableItems = [presenter tableItemsWithSearchText:@""];
    [expectThat([tableItems count]) should:be(3)];
    
    tableItems = [presenter tableItemsWithSearchText:nil];
    [expectThat([tableItems count]) should:be(3)];
}

- (void)itShouldTurnTheBrowseListIntoSectionedTableItemsForAlphabetizedCategories {
    GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
    GTIOCategory* category1 = [[GTIOCategory new] autorelease];
    category1.name = @"A Category 1";
    category1.apiEndpoint = @"/api/endpoint/1";
    category1.iconSmallURL = @"http://bogus.url/1.jpg";
    GTIOCategory* category2 = [[GTIOCategory new] autorelease];
    category2.name = @"1 Category 2";
    category2.apiEndpoint = @"/api/endpoint/2";
    category2.iconSmallURL = @"http://bogus.url/2.jpg";
    GTIOCategory* category3 = [[GTIOCategory new] autorelease];
    category3.name = @"2 Category 3";
    category3.apiEndpoint = @"/api/endpoint/3";
    category3.iconSmallURL = @"http://bogus.url/3.jpg";
    list.categories = [NSArray arrayWithObjects:category1, category2, category3, nil];
    GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
    
    NSDictionary* tableItems = presenter.tableItemsGroupedAlphabetically;
    [expectThat([[tableItems objectForKey:@"A"] count]) should:be(1)];
    [expectThat([[tableItems objectForKey:@"#"] count]) should:be(2)];
    
    TTTableImageItem* item = [[tableItems objectForKey:@"A"] objectAtIndex:0];
    [expectThat(NSStringFromClass([item class])) should:be(NSStringFromClass([TTTableImageItem class]))];
    [expectThat(item.text) should:be(@"A Category 1")];
    [expectThat(item.imageURL) should:be(@"http://bogus.url/1.jpg")];
    [expectThat(item.URL) should:be(@"gtio://browse/.api.endpoint.1")];
    
    tableItems = [presenter tableItemsGroupedAlphabeticallyWithFilterText:@"2"];
    [expectThat([tableItems objectForKey:@"A"]) should:be(nil)];
    [expectThat([[tableItems objectForKey:@"#"] count]) should:be(2)];
}

- (void)itShouldTurnTheBrowseListIntoTableItemsWhenItIsAListOfOutfits {
    GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
    GTIOOutfit* outfit1 = [[GTIOOutfit new] autorelease];
    GTIOOutfit* outfit2 = [[GTIOOutfit new] autorelease];
    GTIOOutfit* outfit3 = [[GTIOOutfit new] autorelease];
    
    list.outfits = [NSArray arrayWithObjects:outfit1, outfit2, outfit3, nil];
    GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
    
    NSArray* tableItems = presenter.tableItems;
    [expectThat([tableItems count]) should:be(3)];
    
    TTTableImageItem* item = [tableItems objectAtIndex:0];
    [expectThat(NSStringFromClass([item class])) should:be(@"GTIOOutfitTableViewItem")];
    
}

- (void)itShouldTurnTheBrowseListIntoTableItemsWhenItIsAListOfMyLooks {
    GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
    GTIOOutfit* outfit1 = [[GTIOOutfit new] autorelease];
    GTIOOutfit* outfit2 = [[GTIOOutfit new] autorelease];
    GTIOOutfit* outfit3 = [[GTIOOutfit new] autorelease];
    
    list.myLooks = [NSArray arrayWithObjects:outfit1, outfit2, outfit3, nil];
    GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
    
    NSArray* tableItems = presenter.tableItems;
    [expectThat([tableItems count]) should:be(3)];
    
    TTTableImageItem* item = [tableItems objectAtIndex:0];
    [expectThat(NSStringFromClass([item class])) should:be(@"GTIOOutfitTableViewItem")];
    
}

- (void)itShouldTurnTheBrowseListIntoSectionedTableItemsForAListOfReviews {
    GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
    GTIOReview* review1 = [[GTIOReview new] autorelease];
    GTIOReview* review2 = [[GTIOReview new] autorelease];
    GTIOReview* review3 = [[GTIOReview new] autorelease];
    GTIOOutfit* outfit1 = [[GTIOOutfit new] autorelease];
    GTIOOutfit* outfit2 = [[GTIOOutfit new] autorelease];
    GTIOOutfit* outfit3 = [[GTIOOutfit new] autorelease];
    review1.outfit = outfit1;
    review2.outfit = outfit2;
    review3.outfit = outfit3;
    
    list.reviews = [NSArray arrayWithObjects:review1, review2, review3, nil];
    GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
    
    NSArray* tableItems = presenter.tableItems;
    [expectThat([tableItems count]) should:be(3)];
    
    TTTableImageItem* item = [tableItems objectAtIndex:0];
    [expectThat(NSStringFromClass([item class])) should:be(@"GTIOUserReviewTableItem")];
}

- (void)itShouldCreateASearchBarIfRequired {
    GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
    GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
    
    [expectThat(presenter.searchBar) should:be(nil)];
     
    list.includeSearch = [NSNumber numberWithBool:YES];
    list.searchText = @"Placeholder Text";
    
    UISearchBar* searchBar = presenter.searchBar;
    [expectThat(searchBar) shouldNot:be(nil)];
    [expectThat(searchBar.placeholder) should:be(@"Placeholder Text")];
}

- (void)itShouldTurnTheBrowseListIntoSectionedTableItemsForAListOfSections {
    GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
    GTIOOutfit* outfit1 = [[GTIOOutfit new] autorelease];
    GTIOOutfit* outfit2 = [[GTIOOutfit new] autorelease];
    GTIOOutfit* outfit3 = [[GTIOOutfit new] autorelease];
    GTIOListSection* section1 = [[GTIOListSection new] autorelease];
    section1.title = @"section 1";
    section1.outfits = [NSArray arrayWithObjects:outfit1, nil];
    GTIOListSection* section2 = [[GTIOListSection new] autorelease];
    section2.title = @"section 2";
    section2.outfits = [NSArray arrayWithObjects:outfit2, outfit3, nil];
    list.sections = [NSArray arrayWithObjects:
                     section1,
                     section2,
                     nil];
    GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
    
    NSArray* expectedNames = [NSArray arrayWithObjects:@"section 1", @"section 2", nil];
    [expectThat(presenter.sectionNames) should:be(expectedNames)];
    NSArray* items = presenter.tableItems;
    [expectThat([items count]) should:be(2)];
    [expectThat([[items objectAtIndex:0] count]) should:be(1)];
    [expectThat([[items objectAtIndex:1] count]) should:be(2)];
}

- (void)itShouldReturnTheTabsAndTabNamesForSortTabsAndRegularTabs {
    {
        GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
        GTIOSortTab* tab1 = [[GTIOSortTab new] autorelease];
        tab1.sortText = @"tab1";
        GTIOSortTab* tab2 = [[GTIOSortTab new] autorelease];
        tab2.sortText = @"tab2";
        list.sortTabs = [NSArray arrayWithObjects:tab1, tab2, nil];
        GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
        NSArray* expectedNames = [NSArray arrayWithObjects:@"tab1", @"tab2", nil];
        [expectThat(presenter.tabNames) should:be(expectedNames)];
    }
    {
        GTIOBrowseList* list = [[GTIOBrowseList new] autorelease];
        GTIOSortTab* tab1 = [[GTIOSortTab new] autorelease];
        tab1.title = @"tab1";
        GTIOSortTab* tab2 = [[GTIOSortTab new] autorelease];
        tab2.title = @"tab2";
        list.tabs = [NSArray arrayWithObjects:tab1, tab2, nil];
        GTIOBrowseListPresenter* presenter = [GTIOBrowseListPresenter presenterWithList:list];
        NSArray* expectedNames = [NSArray arrayWithObjects:@"tab1", @"tab2", nil];
        [expectThat(presenter.tabNames) should:be(expectedNames)];
    }
}

- (void)itShouldBeAbleToLoadMoreOutfits {
//    UIQuery* app = [UIQuery withApplication];
//    [[GTIOUser currentUser] setLoggedIn:YES];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//    GTIOBrowseTableViewController* controller = TTOpenURL(@"gtio://browse");
//    [app wait:1];
//    NSLog(@"Top View Controller: %@", [TTNavigator navigator].topViewController);
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)itShouldBeAbleToLoadMoreMyLooks {
    
}

- (void)itShouldBeAbleToLoadMoreReviews {
    
}

@end
