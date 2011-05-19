//
//  GTIOUserIconOption.h
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface GTIOUserIconOption : NSObject {
	NSString* _url;
	NSString* _type;
	NSNumber* _width;
	NSNumber* _height;
	NSNumber* _selected;
}

@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, retain) NSNumber* width;
@property (nonatomic, retain) NSNumber* height;
@property (nonatomic, retain) NSNumber* selected;

@end
