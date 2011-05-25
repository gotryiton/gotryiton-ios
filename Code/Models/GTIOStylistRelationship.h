//
//  GTIOStylistRelationship.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/25/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOStylistRelationship : NSObject {
    BOOL _isMyStylist;
    BOOL _isMyStylistIgnored;
    BOOL _iStyle;
    BOOL _iStyleIgnored;
}

@property (nonatomic, assign) BOOL isMyStylist;
@property (nonatomic, assign) BOOL isMyStylistIgnored;
@property (nonatomic, assign) BOOL iStyle;
@property (nonatomic, assign) BOOL iStyleIgnored;

- (UIImage*)imageForConnection;

@end
