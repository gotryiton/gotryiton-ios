//
//  GTIORouter.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIORouter : NSObject

+ (GTIORouter *)sharedRouter;
- (UIViewController *)routeTo:(NSString *)path;

@end
