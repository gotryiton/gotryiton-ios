//
//  RKRequest+mock.m
//  GTIO
//
//  Created by Daniel Hammond on 5/24/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

@interface RKRequest (mockrequest)
- (NSString*)filePathForResourcePath:(NSString*)resourcePath;
@end
@implementation RKRequest (mockrequest)

- (void)fireAsynchronousRequest {
    NSString* baseURL = [kGTIOBaseURLString stringByAppendingString:GTIORestResourcePath(@"")];
    NSString* urlPath = [[[self URL] absoluteString] stringByReplacingOccurrencesOfString:baseURL withString:@""];  
    if ([GTIOUser currentUser].token) {
        urlPath = [urlPath stringByReplacingOccurrencesOfString:[GTIOUser currentUser].token withString:@"xxx"];
    }  else {
        urlPath = [urlPath stringByReplacingOccurrencesOfString:[GTIOUser uniqueIdentifier] withString:@"xxx"];
    }
    NSLog(@"urlPath=%@",urlPath);
    if ([self filePathForResourcePath:urlPath]) {
        NSLog(@"Attempting to fake %@ request to URL %@.", [self HTTPMethod], urlPath);
        _isLoading = YES;    
        
        if ([self.delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
            [self.delegate requestDidStartLoad:self];
        }
        
        NSString* filePath = [self filePathForResourcePath:urlPath];
        RKResponse* response = [[[RKResponse alloc] initWithRequest:self] autorelease];
        [response connection:nil didReceiveData:[NSData dataWithContentsOfFile:filePath]];
        [self didFinishLoad:response];
        [[NSNotificationCenter defaultCenter] postNotificationName:RKRequestSentNotification object:self userInfo:nil];   
    } else {        
        [self prepareURLRequest];
        NSString* body = [[NSString alloc] initWithData:[_URLRequest HTTPBody] encoding:NSUTF8StringEncoding];
        NSLog(@"No Local Fixture Mapping Found - Firing Request to Server");
        NSLog(@"=== a fixture should probably be created for %@ ===",urlPath);
        NSLog(@"Sending real %@ request to URL %@. HTTP Body: %@", [self HTTPMethod], [[self URL] absoluteString], body);
        [body release];        
        
        _isLoading = YES;    
        
        if ([self.delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
            [self.delegate requestDidStartLoad:self];
        }
        
        RKResponse* response = [[[RKResponse alloc] initWithRequest:self] autorelease];
        _connection = [[NSURLConnection connectionWithRequest:_URLRequest delegate:response] retain];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RKRequestSentNotification object:self userInfo:nil];
    }    
}

- (NSString*)filePathForResourcePath:(NSString*)resourcePath {
    NSDictionary* mappings = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"my_looks",@"/profile/1CCD774/looks",
                              @"status",@"/status?gtioToken=xxx&iphoneAppVersion=3.0",
                              @"status",@"/status?uniqueId=xxx&iphoneAppVersion=3.0",
                              @"profile",@"/profile/1CCD774",
                              @"user_icons",@"/user-icons?gtioToken=xxx",
                              @"welcome_outfits",@"/welcome-outfits",
                              @"reviews",@"/reviews/E6B67F6",
                              nil];
    if ([mappings objectForKey:resourcePath]) {
        return [[NSBundle mainBundle] pathForResource:[mappings objectForKey:resourcePath] ofType:@"json"];
    } else {
        return nil;
    }
}

@end

//
@interface RKResponse (fakemimetype)
@end

@implementation RKResponse (fakemimetype)
- (NSString*)MIMEType {
	return @"application/json";
}
@end
