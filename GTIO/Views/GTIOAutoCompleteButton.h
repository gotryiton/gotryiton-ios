//
//  GTIOAutoCompleteButton.h
//  GTIO
//
//  Created by Simon Holroyd on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOButton.h"

#import "GTIOAutoCompleter.h"

@interface GTIOAutoCompleteButton : GTIOButton

@property (nonatomic, strong) GTIOAutoCompleter *completer;

- (id)initWithFrame:(CGRect) frame withCompleter:(GTIOAutoCompleter *) completer;

@end
