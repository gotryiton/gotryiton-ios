//
//  JRSessionData_Overrides.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JRSessionData_Overrides.h"


static NSString * const iconNames[5] = { @"icon_%@_30x30.png",
    @"icon_%@_30x30@2x.png",
    @"logo_%@_280x65.png",
    @"logo_%@_280x65@2x.png", nil };

static NSString * const iconNamesSocial[11] = { @"icon_%@_30x30.png",
    @"icon_%@_30x30@2x.png",
    @"logo_%@_280x65.png",
    @"logo_%@_280x65@2x.png",
    @"icon_bw_%@_30x30.png",
    @"icon_bw_%@_30x30@2x.png",
    @"button_%@_135x40.png",
    @"button_%@_135x40@2x.png",
    @"button_%@_280x40.png",
    @"button_%@_280x40@2x.png", nil };

@interface JRSessionData (Private)

- (id)initWithName:(NSString*)name andDictionary:(NSDictionary*)dictionary;
- (void)checkForIcons:(NSString**)a forProvider:(id)b;

@end

@interface JRProvider (Private)

@property (nonatomic, readonly) BOOL social;

@end

@implementation JRSessionData (Overrides)

- (NSError*)finishGetConfiguration:(NSString*)dataStr {
//    ALog (@"Configuration information needs to be updated.");
    
    /* Make sure that the returned string can be parsed as json (which there should be no reason that this wouldn't happen) */
    if (![dataStr respondsToSelector:@selector(JSONValue)])
        return [JRError setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                        withCode:JRJsonError];
    
    NSDictionary *jsonDict = [dataStr JSONValue];
    
    /* Double-check the return value */
    if(!jsonDict)
        return [JRError setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                        withCode:JRJsonError];
    
    [baseUrl release];
    baseUrl = [[[jsonDict objectForKey:@"baseurl"] 
                stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] retain];
    
    /* Then save it */
    [[NSUserDefaults standardUserDefaults] setValue:baseUrl forKey:@"jrengage.sessionData.baseUrl"];
    
    /* Get the providers out of the provider_info section.  These are most likely to have changed. */
    NSDictionary *providerInfo   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"provider_info"]];
    
    [allProviders release];
    allProviders = [[NSMutableDictionary alloc] initWithCapacity:[[providerInfo allKeys] count]];
    
    /* For each provider... */
    for (NSString *name in [providerInfo allKeys])
    {   /* Get its dictionary, */
        NSDictionary *dictionary = [providerInfo objectForKey:name];
        
        /* use this to create a provider object, */
        JRProvider *provider = [[[JRProvider alloc] initWithName:name
                                                   andDictionary:dictionary] autorelease];
        
        /* make sure we have this provider's icons, */
        [self checkForIcons:((provider.social) ? (NSString**)&iconNamesSocial : (NSString**)&iconNames) forProvider:name];
        
        /* and finally add the object to our dictionary of providers. */
        [allProviders setObject:provider forKey:name];
    }
    
    /* Save these now, in case the downloading of the icons gets interrupted for any reason */
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:iconsStillNeeded] 
                                              forKey:@"jrengage.sessionData.iconsStillNeeded"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:providersWithIcons] 
                                              forKey:@"jrengage.sessionData.providersWithIcons"];    
    [[NSUserDefaults standardUserDefaults] synchronize];    
    
    [basicProviders release];
    [socialProviders release];
    
    /* Get the ordered list of basic providers */
    NSMutableArray* providers = [[[jsonDict objectForKey:@"enabled_providers"] mutableCopy] autorelease];
    [providers removeObject:@"facebook"];
    basicProviders = [[NSArray arrayWithArray:providers] retain];
    
    /* Get the ordered list of social providers */
    socialProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"social_providers"]] retain];
    
    /* yippie, yahoo! */
    
    /* Then save our stuff */
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:allProviders] 
                                              forKey:@"jrengage.sessionData.allProviders"];
    [[NSUserDefaults standardUserDefaults] setObject:basicProviders forKey:@"jrengage.sessionData.basicProviders"];
    [[NSUserDefaults standardUserDefaults] setObject:socialProviders forKey:@"jrengage.sessionData.socialProviders"];
    
    /* Figure out if we need to hide the tag line */
    if ([[jsonDict objectForKey:@"hide_tagline"] isEqualToString:@"YES"])
        hidePoweredBy = YES;
    else
        hidePoweredBy = NO;
    
    /* And finally, save that too */
    [[NSUserDefaults standardUserDefaults] setBool:hidePoweredBy forKey:@"jrengage.sessionData.hidePoweredBy"];
    
    /* Once we know that everything is parsed and saved correctly, save the new etag */
    [[NSUserDefaults standardUserDefaults] setValue:newEtag forKey:@"jrengage.sessionData.configurationEtag"];
    
    [[NSUserDefaults standardUserDefaults] setValue:gitCommit forKey:@"jrengage.sessionData.engageCommit"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /* Now, download any missing icons */
    [self downloadAnyIcons:iconsStillNeeded];
    
    /* Then release our saved configuration information */
    [savedConfigurationBlock release];
    [newEtag release];
    
    savedConfigurationBlock = nil;
    newEtag = nil;
    
    return nil;
}

@end
