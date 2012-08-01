//
//  GTIOButtonAction.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOButtonAction : NSObject

@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) NSString *endpoint;
@property (nonatomic, copy) NSURL *twitterURL;
@property (nonatomic, copy) NSString *twitterText;
@property (nonatomic, strong) NSNumber *spinner;

+ (id)buttonActionWithDestination:(NSString *)destination;

@end
