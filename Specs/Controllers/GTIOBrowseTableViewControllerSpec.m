//
//  GTIOBrowseTableViewControllerSpec.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIQuery.h"
#import "UISpec.h"
#import "UIExpectation.h"
#import <RestKit/RestKit.h>

@interface GTIOBrowseTableViewControllerSpec : NSObject <UISpec> {
    UIQuery* _app;
}
@end

@implementation GTIOBrowseTableViewControllerSpec

- (void)before {
    [[RKObjectManager sharedManager].client setBaseURL:@"http://10.0.1.8:4567"];
    
    _app = [UIQuery withApplication];
    [_app wait:1];
    [[GTIOUser currentUser] setLoggedIn:YES];
    [_app wait:1];
    TTOpenURL(@"gtio://home");
    [_app wait:1];
}

- (void)after {
    [_app release];
    _app = nil;
}

- (void)itShouldShowAllCategories {
    // /rest/v3/categories
    TTOpenURL(@"gtio://browse");
    [_app wait:1];
    [[[_app label] text:@"popular"] should].exist;
    [[[_app label] text:@"recent"] should].exist;
    [[[_app label] text:@"brands"] should].exist;
    [[[_app label] text:@"events"] should].exist;
}

- (void)itShouldLetMeSearch {
    // /rest/v3/categories
    TTOpenURL(@"gtio://browse");
    [_app wait:1];
    UIQuery* searchBar = [_app view:@"UISearchBar"];
    [searchBar setText:@"a night out"];
    http://iphonedev.gotryiton.com/rest/v3/search. HTTP Body: query=a%20night%20out&gtioToken=62fd2eb677b87355fd87c6610f11138b
    [[searchBar delegate] searchBarSearchButtonClicked:searchBar];
    [_app wait:1];
    // TODO: finish this spec
    @"";
}

@end
