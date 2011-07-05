//
//  GTIOBadge.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/19/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GTIOBadge : NSObject {
	NSString* _type;
	NSNumber* _since;
	NSString* _imgURL;
    NSString* _outfitBadgeURL;
}

@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSNumber *since;
@property (nonatomic, copy) NSString *imgURL;
@property (nonatomic, copy) NSString* outfitBadgeURL;

@end
