//
//  GTIOCategory.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOCategory : NSObject {
    NSString* _name;
    NSString* _apiEndpoint;
    NSString* _iconSmallURL;
    NSString* _iconLargeURL;
}
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* apiEndpoint;
@property (nonatomic, retain) NSString* iconSmallURL;
@property (nonatomic, retain) NSString* iconLargeURL;

@end
