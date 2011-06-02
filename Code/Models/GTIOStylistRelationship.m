//
//  GTIOStylistRelationship.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/25/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOStylistRelationship.h"


@implementation GTIOStylistRelationship

@synthesize isMyStylist = _isMyStylist;
@synthesize isMyStylistIgnored = _isMyStylistIgnored;
@synthesize iStyle = _iStyle;
@synthesize iStyleIgnored = _iStyleIgnored;

// For Lists. Note that we use the -profile images for the top of the profile, and the -small images for the "cards" as matt calls them.
// also, none of them are the same.
- (UIImage*)imageForConnection {
    if (_iStyleIgnored || (!_iStyle && !_isMyStylist)) {
        return nil;//[UIImage imageNamed:@"connection-1.png"];
    }
    if (_iStyle && _isMyStylist) {
        return [UIImage imageNamed:@"connection-4.png"];
    }
    if (_iStyle && !_isMyStylist) {
        return [UIImage imageNamed:@"connection-3.png"];
    }
    return [UIImage imageNamed:@"connection-2.png"];
}

- (UIImage*)imageForProfileConnection {
    if (_iStyleIgnored || (!_iStyle && !_isMyStylist)) {
        return [UIImage imageNamed:@"connection-1-profile.png"];
    }
    if (_iStyle && _isMyStylist) {
        return [UIImage imageNamed:@"connection-4-profile.png"];
    }
    if (_iStyle && !_isMyStylist) {
        return [UIImage imageNamed:@"connection-3-profile.png"];
    }
    return [UIImage imageNamed:@"connection-2-profile.png"];
}

@end
