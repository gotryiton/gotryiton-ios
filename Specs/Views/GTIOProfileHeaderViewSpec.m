//
//  GTIOProfileHeaderViewSpec.m
//  GTIO
//
//  Created by Daniel Hammond on 5/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISpec.h"
#import "UIExpectation.h"
#import "GTIOProfileHeaderView.h"
#import "GTIOProfile.h"

@interface GTIOProfileHeaderViewSpec : NSObject <UISpec> {}
@end

@implementation GTIOProfileHeaderViewSpec

- (void)itShouldDisplayProfile {

	GTIOProfile* profile = [[GTIOProfile alloc] init];
	[profile setDisplayName:@"displayname"];
	[profile setLocation:@"location"];
	GTIOProfileHeaderView* header = [[GTIOProfileHeaderView new] autorelease];
	[header displayProfile:profile];

	[expectThat(header.nameLabel.text) should:be([@"displayname" uppercaseString])];
	[expectThat(header.locationLabel.text) should:be(@"location")];

}




@end
