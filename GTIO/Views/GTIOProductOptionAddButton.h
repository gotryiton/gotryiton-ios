//
//  GTIOProductOptionAddButton.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOProductOption.h"

@protocol GTIOProductOptionAddButtonDelegate <NSObject>

@required
- (void)refreshScreenData;

@end

@interface GTIOProductOptionAddButton : UIView

@property (nonatomic, strong) GTIOProductOption *productOption;
@property (nonatomic, weak) id<GTIOProductOptionAddButtonDelegate> delegate;

@end
