//
//  GTIONotification.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONotification.h"

@implementation GTIONotification

@synthesize notificationID = _notificationID, text = _text, action = _action, icon = _icon, viewed = _viewed;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.notificationID = [coder decodeObjectForKey:@"notificationID"];
        self.text = [coder decodeObjectForKey:@"text"];
        self.action = [coder decodeObjectForKey:@"action"];
        self.icon = [coder decodeObjectForKey:@"icon"];
        self.viewed = [coder decodeObjectForKey:@"viewed"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.notificationID forKey:@"notificationID"];
    [coder encodeObject:self.text forKey:@"text"];
    [coder encodeObject:self.action forKey:@"action"];
    [coder encodeObject:self.icon forKey:@"icon"];
    [coder encodeObject:self.viewed forKey:@"viewed"];
}

@end
