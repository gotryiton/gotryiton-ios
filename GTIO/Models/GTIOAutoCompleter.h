//
//  AutocompleteOption.h
//  WebViewDemo
//
//  Created by Simon Holroyd on 6/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GTIOAutoCompleter : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *completer_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSURL *icon;

- (NSString *) getCompleterString;

+ (void) loadBrandDictionaryWithCompletionHandler:(GTIOCompletionHandler)completionHandler;
+ (void) loadUsersDictionaryWithCompletionHandler:(GTIOCompletionHandler)completionHandler withUserId:(NSString *) user_id;

@end
