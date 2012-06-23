//
//  AutocompleteOption.m
//  WebViewDemo
//
//  Created by Simon Holroyd on 6/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

#import "GTIOAutoCompleter.h"

@implementation GTIOAutoCompleter


@synthesize name = _name;
@synthesize type = _type;
@synthesize icon = _icon;
@synthesize completer_id = _completer_id;

- (void)dealloc
{
    _name = nil;
    _type = nil;
    _icon = nil;
    _completer_id = nil;
    
}

- (NSString *) getCompleterString 
{
	if ([self.type isEqualToString:@"@"]){
		return [@"@" stringByAppendingString:self.name];
	}
	return self.name;
}


@end
