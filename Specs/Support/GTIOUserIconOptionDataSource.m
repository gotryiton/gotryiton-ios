//
//  GTIOUserIconOptionDataSource.m - Testing Mock
//  GTIO
//
//  Created by Daniel Hammond on 5/23/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOUserIconOptionDataSource.h"
#import "GTIOUserIconOption.h"
#import "GTIOUser.h"

@implementation GTIOUserIconOptionDataSource
+ (id)iconOptionRequestWithDelegate:(id)delegate {
    // TODO: Implement some sort of fixture here for icon options
    
    GTIOUserIconOption* option = [GTIOUserIconOption new];
    option.url = @"http://assets.gotryiton.com/img/profile-default.png";
    option.type = @"Default";
    GTIOUserIconOption* option2 = [GTIOUserIconOption new];
    option2.url = @"http://assets.gotryiton.com/img/profile-default.png?arg=2";
    option2.type = @"Default";
    GTIOUserIconOption* option3 = [GTIOUserIconOption new];
    option3.url = [[GTIOUser currentUser] profileIconURL];
    option3.type = @"Facebook";

    NSArray* options = [NSArray arrayWithObjects:option,option2,option3,nil];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:options forKey:@"userIconOptions"];
    [delegate objectLoader:nil didLoadObjectDictionary:dict];
    
    [option release];
    [option2 release];
    [option3 release];
    
    return nil;
}
@end
