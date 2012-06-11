//
//  GTIONavigationTitleView.h
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIONavigationTitleView : UIView

@property (nonatomic, assign, getter = isItalic) BOOL italic;
@property (nonatomic, strong) NSString *title;

- (id)initWithTitle:(NSString*)title italic:(BOOL)italic;

@end
