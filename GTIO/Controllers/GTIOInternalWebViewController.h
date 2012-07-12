//
//  GTIOInternalWebViewController.h
//  GTIO
//
//  Created by Scott Penrose on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"

extern NSString * const kGTIOStyleResourcePath;

/** Internal GTIO links with the following route go here
    gtio://InternalWebview/[custom title (urlencoded)]/[url (url encoded)]
 */
@interface GTIOInternalWebViewController : GTIOViewController

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *navigationTitle;

@end
