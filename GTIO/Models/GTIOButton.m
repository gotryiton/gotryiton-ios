//
//  GTIOButton.m
//  GTIO
//
//  Created by Scott Penrose on 6/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOButton.h"
#import "Social/Social.h"

static NSString * const kGTIOFacebookButtonType = @"facebook";


@implementation GTIOButton

- (BOOL)isAvilableForIOSDevice
{
    if ([self.buttonType isEqualToString:kGTIOFacebookButtonType]){
        return ([[[UIDevice currentDevice] systemVersion] compare:@"6" options:NSNumericSearch] != NSOrderedAscending);
    }
    return YES;
}

@end