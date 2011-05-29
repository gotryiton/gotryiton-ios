//
//  GTIOStylistRelationship.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/25/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOStylistRelationship contains the relationship between an arbitrary [GTIOUser](GTIOUser) and the curent user

@interface GTIOStylistRelationship : NSObject {
    BOOL _isMyStylist;
    BOOL _isMyStylistIgnored;
    BOOL _iStyle;
    BOOL _iStyleIgnored;
}
/// true if they are the current user stylist
@property (nonatomic, assign) BOOL isMyStylist;
/// true if they are on the current user stylists ignore list
@property (nonatomic, assign) BOOL isMyStylistIgnored;
/// true if the current user is a stylist for them
@property (nonatomic, assign) BOOL iStyle;
/// true if current user is a on their ignore list
@property (nonatomic, assign) BOOL iStyleIgnored;
/// returns the apropriate image given the relationship
- (UIImage*)imageForConnection;

@end
