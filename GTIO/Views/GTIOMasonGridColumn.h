//
//  GTIOMasonGridColumn.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOMasonGridColumn : NSObject

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, assign) CGFloat imageSpacer;
@property (nonatomic, assign) NSInteger columnNumber;

+ (id)gridColumnWithColumnNumber:(NSInteger)columnNumber;

@end
