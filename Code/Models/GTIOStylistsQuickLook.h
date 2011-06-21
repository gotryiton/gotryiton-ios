//
//  GTIOStylistsQuickLook.h
//  GTIO
//
//  Created by Jeremy Ellison on 6/20/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOStylistsQuickLook : NSObject {
    NSArray* _thumbs;
    NSString* _text;
}

@property (nonatomic, retain) NSArray* thumbs;
@property (nonatomic, retain) NSString* text;

@end
