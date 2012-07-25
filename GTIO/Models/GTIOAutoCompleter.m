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
@synthesize completerID = _completerID;

- (NSString *)completerString 
{
	if ([self.type isEqualToString:@"@"]){
		return [@"@" stringByAppendingString:self.name];
	}
    if ([self.type isEqualToString:@"#"]){
        return [@"#" stringByAppendingString:self.name];
    }
	return self.name;
}

+ (void)loadBrandDictionaryWithCompletionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *dictionaryPath = @"/autocomplete-dictionary/brands";
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:dictionaryPath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {                
            if (completionHandler) {
                completionHandler(objects, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

+ (void)loadUsersDictionaryWithUserID:(NSString *)userID completionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *dictionaryPath = [@"" stringByAppendingFormat:@"/autocomplete-dictionary/users/%@/post", userID];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:dictionaryPath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {                
            if (completionHandler) {
                completionHandler(objects, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

+ (void)loadUsersDictionaryWithUserID:(NSString *)userID postID:(NSString *)postID completionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *dictionaryPath = [@"" stringByAppendingFormat:@"/autocomplete-dictionary/users/%@/post/%@", userID, postID];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:dictionaryPath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {                
            if (completionHandler) {
                completionHandler(objects, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}


@end
