//
//  GTIOCategory.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOCategory represents a category found in a GTIOBrowseList

@interface GTIOCategory : NSObject {
    NSString* _name;
    NSString* _apiEndpoint;
    NSString* _iconSmallURL;
    NSString* _iconLargeURL;
}
/// Category Name
@property (nonatomic, retain) NSString* name;
/// API Endpoint
@property (nonatomic, retain) NSString* apiEndpoint;
/// Small Category Icon URL
@property (nonatomic, retain) NSString* iconSmallURL;
/// Large Category Icon URL
@property (nonatomic, retain) NSString* iconLargeURL;

@end
