//
//  GTIOPhoto.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOPhoto : NSObject {
	UIImage* _image;
	NSString* _brandsYouAreWearing;
	BOOL _blurApplied;
}

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSString* brandsYouAreWearing;
@property (nonatomic, assign) BOOL blurApplied;

@end
