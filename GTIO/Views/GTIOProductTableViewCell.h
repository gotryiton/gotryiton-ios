//
//  GTIOProductTableViewCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/18/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOProduct.h"
#import "GTIOButton.h"

typedef enum GTIOProductTableCellType {
    GTIOProductTableViewCellTypeShoppingList = 0,
    GTIOProductTableViewCellTypeShoppingBrowse,
    GTIOProductTableViewCellTypeShopThisLook
} GTIOProductTableCellType;

@protocol GTIOProductTableViewCellDelegate <NSObject>

@optional
- (void)removeProduct:(GTIOProduct *)product;
- (void)loadWebViewControllerWithURL:(NSURL *)url;
- (void)productButtonTap:(GTIOButton* )button productID:(NSNumber *)productID;

@end

@interface GTIOProductTableViewCell : UITableViewCell

@property (nonatomic, strong) GTIOProduct *product;

@property (nonatomic, weak) id<GTIOProductTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier GTIOProductTableCellType:(GTIOProductTableCellType)type;

@end
