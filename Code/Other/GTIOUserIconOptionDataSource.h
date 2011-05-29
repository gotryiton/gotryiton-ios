//
//  GTIOUserIconOptionDataSource.h
//  GTIO
//
//  Created by Daniel Hammond on 5/23/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOUserIconOptionDataSource is a helper that fires the request to get a users [GTIOUserIconOption](GTIOUserIconOption)

#import <Foundation/Foundation.h>


@interface GTIOUserIconOptionDataSource : NSObject {}
/// Fires RKObjectManager at the correct resource path with the passed in delegate
+ (void)iconOptionRequestWithDelegate:(id)delegate;
@end
