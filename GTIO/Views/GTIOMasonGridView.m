//
//  GTIOMasonGridView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMasonGridView.h"
#import "GTIOPost.h"
#import "GTIOMasonGridColumn.h"

@interface GTIOMasonGridView()

@property (nonatomic, strong) NSMutableArray *columns;

@end

@implementation GTIOMasonGridView

@synthesize columns = _columns;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _columns = [NSMutableArray arrayWithObjects:
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:0],
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:1],
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:2],
                    nil];
    }
    return self;
}

- (void)setPosts:(NSArray *)posts postsType:(GTIOPostType)postsType
{
    
}

@end
