//
//  GTIOFilterButton.m
//  GTIO
//
//  Created by Scott Penrose on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFilterButton.h"

@implementation GTIOFilterButton

+ (id)buttonWithFilterType:(GTIOFilterType)filterType tapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    NSString *imageName = [NSString stringWithFormat:@"filter.%@.png", [GTIOFilterTypeName[filterType] lowercaseString]];
    NSString *selectedImageName = [NSString stringWithFormat:@"filter.%@.selected.png", [GTIOFilterTypeName[filterType] lowercaseString]];
    
    id button = [self buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [button setFrame:(CGRect){ CGPointZero, [button imageForState:UIControlStateNormal].size }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setTapHandler:tapHandler];
    return button;
}

@end
