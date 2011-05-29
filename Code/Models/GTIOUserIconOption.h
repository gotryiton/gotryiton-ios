//
//  GTIOUserIconOption.h
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOUserIconOption represents a potential profile picture for the current user

@interface GTIOUserIconOption : NSObject {
	NSString* _url;
	NSString* _type;
	NSNumber* _width;
	NSNumber* _height;
	NSNumber* _selected;
}
/// URL of the image
@property (nonatomic, copy) NSString* url;
/// Type of the image (currently "facebook","outfit",or "default")
@property (nonatomic, copy) NSString* type;
/// width of the image
@property (nonatomic, retain) NSNumber* width;
/// height of the image
@property (nonatomic, retain) NSNumber* height;
/// true if the image is currently selected
@property (nonatomic, retain) NSNumber* selected;

@end
