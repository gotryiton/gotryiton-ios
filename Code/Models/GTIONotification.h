//
//  GTIONotification.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIONotification : NSObject {
    NSString* _text;
    NSString* _url;
    NSNumber* _notificationID;
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSNumber* notificationID;

@end
