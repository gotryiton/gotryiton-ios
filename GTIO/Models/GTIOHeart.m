//
//  GTIOHeart.m
//  GTIO
//
//  Created by Simon Holroyd on 8/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOHeart.h"

@implementation GTIOHeart

-(void) setPost:(GTIOPost *)post
{
    _post = post;
    self.photo = _post.photo;
    self.action = _post.action;
}


-(void) setProduct:(GTIOProduct *)product
{
    _product = product;
    self.photo = _product.photo;
    self.action = _product.action;
}

@end
