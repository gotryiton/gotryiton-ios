//
//  GTIOErrorController.h
//  GTIO
//
//  Created by Scott Penrose on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOErrorController : NSObject

+ (void)displayAlertViewForError:(NSError *)error;

@end
