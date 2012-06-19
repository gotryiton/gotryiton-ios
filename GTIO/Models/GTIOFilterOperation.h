//
//  GTIOFilterOperation.h
//  GTIO
//
//  Created by Scott Penrose on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFilter.h"

typedef void(^GTIOFilterOperationFinishedHandler)(GTIOFilterType filterType, UIImage *filteredImage);

@interface GTIOFilterOperation : NSOperation

@property (nonatomic, assign) GTIOFilterType filterType;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *filteredImage;

@property (nonatomic, copy) GTIOFilterOperationFinishedHandler finishedHandler;

- (id)initWithFilterType:(GTIOFilterType)filterType;

@end
