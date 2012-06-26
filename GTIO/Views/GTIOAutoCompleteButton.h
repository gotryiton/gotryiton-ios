//
//  GTIOAutoCompleteButton.h
//  GTIO
//
//  Created by Simon Holroyd on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOButton.h"

#import "GTIOAutoCompleter.h"

@interface GTIOAutoCompleteButton : GTIOUIButton

@property (nonatomic, strong) GTIOAutoCompleter *completer;

+ (id)gtio_autoCompleteButtonWithCompleter:(GTIOAutoCompleter *)completer;

@end
