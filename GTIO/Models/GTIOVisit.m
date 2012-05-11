//
//  GTIOVisit.m
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOVisit.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation GTIOVisit

@synthesize latitude = _latitude, longitude = _longitude;
@synthesize iOSVersion = _iOSVersion, iOSDevice = _iOSDevice;
@synthesize buildVersion = _buildVersion;

+ (GTIOVisit *)visit
{
    GTIOVisit *visit = [[self alloc] init];
    
    visit.iOSVersion = [visit phonesiOSVersion];
    visit.iOSDevice = [visit phonesiOSDevice];
    visit.buildVersion = [visit phonesBuildVersion];
    
    return visit;
}

#pragma mark - Get Values From Phone

- (NSString *)phonesiOSVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)phonesiOSDevice
{
    return [UIDevice currentDevice].model;
}

- (NSString *)phonesBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


@end
