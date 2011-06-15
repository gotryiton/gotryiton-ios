//
//  GTIOTopRightBarButton.h
//  GTIO
//
//  Created by Jeremy Ellison on 6/15/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOTopRightBarButton : NSObject {
    NSString* _text;
    NSString* _url;
}

@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) NSString* url;

@end
