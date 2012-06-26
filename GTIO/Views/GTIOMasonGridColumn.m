//
//  GTIOMasonGridColumn.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMasonGridColumn.h"
#import "GTIOMasonGridItem.h"

@implementation GTIOMasonGridColumn

@synthesize items = _items;
@synthesize height = _height;
@synthesize imageSpacer = _imageSpacer;
@synthesize columnNumber = _columnNumber;

+ (id)gridColumnWithColumnNumber:(NSInteger)columnNumber
{
    GTIOMasonGridColumn *gridColumn = [[self alloc] init];
    gridColumn.columnNumber = columnNumber;
    return gridColumn;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
        self.imageSpacer = 5.0f;
    }
    return self;
}

- (CGFloat)height
{
    CGFloat totalHeight = 0.0f;
    for (GTIOMasonGridItem *item in self.items) {
        if (item) {
            totalHeight += item.image.size.height;
        }
    }
    NSLog(@"column height: %f", totalHeight + (([self.items count] - 1) * self.imageSpacer));
    if (totalHeight == 0) {
        return 0.0f;
    } else {
        return totalHeight + (([self.items count] - 1) * self.imageSpacer);
    }
}

@end