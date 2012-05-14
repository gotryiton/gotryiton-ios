//
//  GTIOVisit.h
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOVisit : NSObject

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *iOSVersion;
@property (nonatomic, strong) NSString *iOSDevice;
@property (nonatomic, strong) NSString *buildVersion;

+ (GTIOVisit *)visit;

@end
