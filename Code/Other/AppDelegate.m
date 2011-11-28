//
//  AppDelegate.m
//  GTIO
//
//  Created by Blake Watters on 4/11/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/ObjectMapping/RKErrorMessage.h>
#import <Three20/Three20.h>
#import "AppDelegate.h"
#import "GTIOHomeViewController.h"
#import "GTIOWelcomeViewController.h"
#import "GTIOLoginViewController.h"

#import <TWTAlertViewDelegate.h>
#import <TWTBundledAssetsURLCache.h>
#import "GTIOOpinionRequestSession.h"
#import "GTIOStyleSheet.h"
#import "GTIOUser.h"
#import "GTIOAnalyticsTracker.h"
#import "GTIOReachabilityObserver.h"
#import "GTIOOutfit.h"
#import "GTIOProfile.h"
#import "GTIOReview.h"
#import "GTIOBadge.h"
#import "GTIOLoadingOverlayManager.h"
#import "GTIOChangeItReason.h"
#import "GTIOVotingResultSet.h"
#import "Facebook.h"
#import "GTIOBrowseList.h"
#import "GTIOCategory.h"
#import "GTIOSortTab.h"
#import "GTIOUserIconOption.h"
#import "GTIOListSection.h"
#import "GTIONotification.h"
#import "GTIOStylistRelationship.h"
#import "GTIOGlobalVariableStore.h"
#import "GTIOBannerAd.h"
#import "GTIOTopRightBarButton.h"
#import "GTIOExtraProfileRow.h"
#import "GTIOStylistsQuickLook.h"
#import "GTIOPushPersonalStylistsViewController.h"
#import "GTIOProfileCreatedAddStylistsViewController.h"
#import "GTIOFacebookInviteTableViewController.h"
#import "TestFlight.h"
#import "Crittercism.h"
#import "GTIOInternalURLHelper.h"

@interface NSURLRequest(anyssl)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
@end
@implementation NSURLRequest(anyssl)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    // Accept all certs so that facebook login works.
    if ([host rangeOfString:@"facebook.com"].location != NSNotFound) {
        return YES;
    }
    // JanRain can't seem to load anything either (on pre 3.2 devices).
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
        return YES;
    }
    return NO;
}
@end

@interface AppDelegate (Private)

- (void)viewRemoteNotification:(NSDictionary*)aps;

@end

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@implementation AppDelegate

@synthesize window = _window;

- (void)setupRestKit {
    
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:kGTIOBaseURLString];
//    RKLogConfigureByName("RestKit/*", kGTIOLogLevel);
//    RKLogConfigureByName("RestKit/Network/*", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    RKObjectMappingProvider* provider = [[[RKObjectMappingProvider alloc] init] autorelease];
    
    RKObjectMapping* reviewMapping = [RKObjectMapping mappingForClass:[GTIOReview class]];
    [reviewMapping addAttributeMapping:RKObjectAttributeMappingMake(@"outfitId", @"outfitID")];
    [reviewMapping addAttributeMapping:RKObjectAttributeMappingMake(@"uid", @"uid")];
    [reviewMapping addAttributeMapping:RKObjectAttributeMappingMake(@"reviewId", @"reviewID")];
    [reviewMapping addAttributeMapping:RKObjectAttributeMappingMake(@"timestamp", @"timestamp")];
    [reviewMapping addAttributeMapping:RKObjectAttributeMappingMake(@"text", @"text")];
    [reviewMapping addAttributeMapping:RKObjectAttributeMappingMake(@"agreeVotes", @"agreeVotes")];
    [reviewMapping addAttributeMapping:RKObjectAttributeMappingMake(@"flags", @"flags")];
    [provider setObjectMapping:reviewMapping forKeyPath:@"reviews"];
    [provider setObjectMapping:reviewMapping forKeyPath:@"review"];
    
    RKObjectMapping* adMapping = [RKObjectMapping mappingForClass:[GTIOBannerAd class]];
    [adMapping mapAttributes:@"height", @"width", @"clickUrl", @"bannerImageUrlLarge", @"bannerImageUrlSmall", nil];
    [provider setObjectMapping:adMapping forKeyPath:@"bannerAd"];
    
    RKObjectMapping* topRightButtonMapping = [RKObjectMapping mappingForClass:[GTIOTopRightBarButton class]];
    [topRightButtonMapping mapAttributes:@"text", @"url", nil];
    [provider setObjectMapping:topRightButtonMapping forKeyPath:@"topRightBtn"];
    
    RKObjectMapping* extraProfileRowMapping = [RKObjectMapping mappingForClass:[GTIOExtraProfileRow class]];
    [extraProfileRowMapping mapAttributes:@"text", @"api", nil];
    
    RKObjectMapping* votingResultsMapping = [RKObjectMapping mappingForClass:[GTIOVotingResultSet class]];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"reasons", @"reasons")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"totalVotes", @"totalVotes")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"userVote", @"userVoteString")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"verdict", @"verdict")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"voteRecorded", @"voteRecordedString")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"wear0", @"wear0")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"wear1", @"wear1")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"wear2", @"wear2")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"wear3", @"wear3")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"wear4", @"wear4")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"pending", @"pending")];
    [votingResultsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"winning", @"winningOutfit")];
    [provider setObjectMapping:votingResultsMapping forKeyPath:@"votingResults"];
    
    RKObjectMapping* outfitMapping = [RKObjectMapping mappingForClass:[GTIOOutfit class]];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"outfitID", @"outfitID")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"uid", @"uid")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"name", @"name")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"city", @"city")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"state", @"state")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"location", @"location")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"timestamp", @"timestamp")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"public", @"isPublic")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"description", @"descriptionString")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"event", @"event")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"eventId", @"eventId")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"url", @"url")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"method", @"method")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"isMulti", @"isMultipleOption")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"photoCount", @"photoCount")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"imgPath", @"imagePath")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"mainImg", @"mainImageUrl")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"iphoneThumb", @"iphoneThumbnailUrl")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"smallThumb", @"smallThumbnailUrl")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"userReview", @"userReview")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"reviewCount", @"reviewCount")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user", @"user")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"isNew",@"isNew")];
    [outfitMapping addAttributeMapping:RKObjectAttributeMappingMake(@"photos", @"photos")];
    [provider setObjectMapping:outfitMapping forKeyPath:@"outfit"];
    
    RKObjectMapping* badgeMapping = [RKObjectMapping mappingForClass:[GTIOBadge class]];
    [badgeMapping addAttributeMapping:RKObjectAttributeMappingMake(@"type", @"type")];
    [badgeMapping addAttributeMapping:RKObjectAttributeMappingMake(@"since", @"since")];
    [badgeMapping addAttributeMapping:RKObjectAttributeMappingMake(@"imgURL", @"imgURL")];
    [badgeMapping addAttributeMapping:RKObjectAttributeMappingMake(@"outfitBadgeURL", @"outfitBadgeURL")];
    
    RKObjectMapping* profileMapping = [RKObjectMapping mappingForClass:[GTIOProfile class]];
    [profileMapping mapAttributes:@"uid", @"auth", @"displayName", @"firstName", @"gender", @"city", @"state", @"location", @"aboutMe",
                                  @"isAuthorizedUser", @"featuredText", @"activeStylist", @"facebookId", nil];
    [profileMapping addAttributeMapping:RKObjectAttributeMappingMake(@"isBrand", @"isBranded")];
    [profileMapping addAttributeMapping:RKObjectAttributeMappingMake(@"profileIcon", @"profileIconURL")];
    [profileMapping addAttributeMapping:RKObjectAttributeMappingMake(@"badgeURLs", @"badgeImageURLs")];
    [profileMapping addAttributeMapping:RKObjectAttributeMappingMake(@"stylistRelationship.iStyleAlerts", @"stylistRequestAlertsEnabled")];
    [provider setObjectMapping:profileMapping forKeyPath:@"user"];
    
    RKObjectMapping* statMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [statMapping mapAttributes:@"name", @"value", nil];
    [profileMapping addRelationshipMapping:
     [RKObjectRelationshipMapping mappingFromKeyPath:@"userStats" toKeyPath:@"userStats" withMapping:statMapping]];
    
    RKObjectMapping* userIconOptionMapping = [RKObjectMapping mappingForClass:[GTIOUserIconOption class]];
    [userIconOptionMapping addAttributeMapping:RKObjectAttributeMappingMake(@"url",@"url")];
    [userIconOptionMapping addAttributeMapping:RKObjectAttributeMappingMake(@"type",@"type")];
    [userIconOptionMapping addAttributeMapping:RKObjectAttributeMappingMake(@"width",@"width")];
    [userIconOptionMapping addAttributeMapping:RKObjectAttributeMappingMake(@"height",@"height")];
    [userIconOptionMapping addAttributeMapping:RKObjectAttributeMappingMake(@"selected",@"selected")];
    [provider setObjectMapping:userIconOptionMapping forKeyPath:@"userIconOptions"];
    
    RKObjectMapping* todosBadgeMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [todosBadgeMapping addAttributeMapping:RKObjectAttributeMappingMake(@"", @"count")];
    [provider setObjectMapping:todosBadgeMapping forKeyPath:@"todosBadge"];
    
    RKObjectMapping* browseListMapping = [RKObjectMapping mappingForClass:[GTIOBrowseList class]];
    [browseListMapping addAttributeMapping:RKObjectAttributeMappingMake(@"title", @"title")];
    [browseListMapping addAttributeMapping:RKObjectAttributeMappingMake(@"subtitle", @"subtitle")];
    [browseListMapping addAttributeMapping:RKObjectAttributeMappingMake(@"includeSearch", @"includeSearch")];
    [browseListMapping addAttributeMapping:RKObjectAttributeMappingMake(@"searchText", @"searchText")];
    [browseListMapping addAttributeMapping:RKObjectAttributeMappingMake(@"includeAlphaNav", @"includeAlphaNav")];
    [browseListMapping addAttributeMapping:RKObjectAttributeMappingMake(@"searchApi", @"searchAPI")];
    
    [provider setObjectMapping:browseListMapping forKeyPath:@"list"];
    
    RKObjectMapping* stylistsQuickLookMapping = [GTIOStylistsQuickLook qlMapping];
    [provider setObjectMapping:stylistsQuickLookMapping forKeyPath:@"user.stylistsQuickLook"];
    
    RKObjectMapping* sectionMapping = [RKObjectMapping mappingForClass:[GTIOListSection class]];
    [sectionMapping mapAttributes:@"title", nil];
    
    RKObjectMapping* categoryMapping = [RKObjectMapping mappingForClass:[GTIOCategory class]];
    [categoryMapping addAttributeMapping:RKObjectAttributeMappingMake(@"name", @"name")];
    [categoryMapping addAttributeMapping:RKObjectAttributeMappingMake(@"api", @"apiEndpoint")];
    [categoryMapping addAttributeMapping:RKObjectAttributeMappingMake(@"iconSmall", @"iconSmallURL")];
    [categoryMapping addAttributeMapping:RKObjectAttributeMappingMake(@"iconLarge", @"iconLargeURL")];
    
    RKObjectMapping* sortTabMapping = [RKObjectMapping mappingForClass:[GTIOSortTab class]];
    [sortTabMapping addAttributeMapping:RKObjectAttributeMappingMake(@"sortText", @"sortText")];
    [sortTabMapping addAttributeMapping:RKObjectAttributeMappingMake(@"default", @"defaultTab")];
    [sortTabMapping addAttributeMapping:RKObjectAttributeMappingMake(@"selected", @"selected")];
    [sortTabMapping addAttributeMapping:RKObjectAttributeMappingMake(@"sortApi", @"sortAPI")];
    
    RKObjectMapping* todoTabMapping = [RKObjectMapping mappingForClass:[GTIOSortTab class]];
    [todoTabMapping addAttributeMapping:RKObjectAttributeMappingMake(@"default", @"defaultTab")];
    [todoTabMapping addAttributeMapping:RKObjectAttributeMappingMake(@"selected", @"selected")];
    [todoTabMapping addAttributeMapping:RKObjectAttributeMappingMake(@"api", @"sortAPI")];
    [todoTabMapping addAttributeMapping:RKObjectAttributeMappingMake(@"subtitle", @"subtitle")];
    [todoTabMapping mapAttributes:@"badgeNumber", @"title", nil];
    
    RKObjectMapping* errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addAttributeMapping:RKObjectAttributeMappingMake(@"", @"errorMessage")];
    [provider setObjectMapping:errorMapping forKeyPath:@"error"];
    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMapping:RKObjectAttributeMappingMake(@"", @"response")];
    [provider setObjectMapping:responseMapping forKeyPath:@"response"];
    
    RKObjectMapping* notificationMapping = [GTIONotification notificationMapping];
    [provider setObjectMapping:notificationMapping forKeyPath:@"notifications"];
    
    RKObjectMapping* stylistRelationshipMapping = [RKObjectMapping mappingForClass:[GTIOStylistRelationship class]];
    [stylistRelationshipMapping mapAttributes:@"isMyStylist", @"isMyStylistIgnored", @"iStyle", @"iStyleIgnored", nil];
    
    [browseListMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"categories" toKeyPath:@"categories" withMapping:categoryMapping]];
    [browseListMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"outfits" toKeyPath:@"outfits" withMapping:outfitMapping]];
    [browseListMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"myLooks" toKeyPath:@"myLooks" withMapping:outfitMapping]];
    [browseListMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"sortTabs" toKeyPath:@"sortTabs" withMapping:sortTabMapping]];
    [browseListMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"tabs" toKeyPath:@"tabs" withMapping:todoTabMapping]];
    [browseListMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"bannerAd" toKeyPath:@"bannerAd" withMapping:adMapping]];
    [browseListMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"topRightBtn" toKeyPath:@"topRightButton" withMapping:topRightButtonMapping]];
    
    [browseListMapping mapRelationship:@"sections" withMapping:sectionMapping];
    [browseListMapping mapRelationship:@"stylists" withMapping:profileMapping];
    [browseListMapping mapRelationship:@"reviews" withMapping:reviewMapping];
    
    [sectionMapping mapRelationship:@"stylists" withMapping:profileMapping];
    [sectionMapping mapRelationship:@"outfits" withMapping:outfitMapping];
    
    [reviewMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:profileMapping]];
    [reviewMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"outfit" toKeyPath:@"outfit" withMapping:outfitMapping]];
    
    [outfitMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"reviews" toKeyPath:@"reviews" withMapping:reviewMapping]];
    [outfitMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"votingResults" toKeyPath:@"results" withMapping:votingResultsMapping]];
    [outfitMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"badges" toKeyPath:@"badges" withMapping:badgeMapping]];
    [outfitMapping mapRelationship:@"stylistRelationship" withMapping:stylistRelationshipMapping];
    
    [profileMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"outfits" toKeyPath:@"outfits" withMapping:outfitMapping]];
    [profileMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"reviewsOutfits" toKeyPath:@"reviewsOutfits" withMapping:outfitMapping]];
    [profileMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"badges" toKeyPath:@"badges" withMapping:badgeMapping]];
    [profileMapping mapRelationship:@"stylistRelationship" withMapping:stylistRelationshipMapping];
    [profileMapping mapRelationship:@"extraProfileRow" withMapping:extraProfileRowMapping];
    [profileMapping mapRelationship:@"stylists" withMapping:profileMapping];
    
    objectManager.mappingProvider = provider;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING
    [TestFlight takeOff:@"25547739e2554e6dbe9fd5bbb3e0f6db_NzcwMg"];
    #else
    [Crittercism initWithAppID: @"4ebabf0eddf5206d3a0001e4"
                        andKey:@"4ebabf0eddf5206d3a0001e4h9zr6giv"
                     andSecret:@"puwfoyudx1oci7lsajbghwb5ekjq08g2"];

    #endif
    
	// Initialize Flurry
    // Don't use flurry's exception handling anymore. use crittercism or testflight.
//	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	[FlurryAnalytics startSession:kGTIOFlurryAPIKey];
    
	[TTStyleSheet setGlobalStyleSheet:[[[GTIOStyleSheet alloc] init] autorelease]];
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
	
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	
	TTURLMap* map = navigator.URLMap;
	
	[map from:@"gtio://home" toSharedViewController:[GTIOHomeViewController class]];
	[map from:@"gtio://welcome" toModalViewController:[GTIOWelcomeViewController class]];
	[map from:@"gtio://login" toViewController:[GTIOLoginViewController class]];
    
	[map from:@"gtio://loginWithJanRain" toObject:[GTIOUser currentUser] selector:@selector(loginWithJanRain)];
	[map from:@"gtio://loginWithFacebook" toObject:[GTIOUser currentUser] selector:@selector(loginWithFacebook)];
	[map from:@"gtio://logout" toObject:[GTIOUser currentUser] selector:@selector(logout)];
	
	// External URL's
	_externalURLHelper = [[GTIOExternalURLHelper alloc] init];
    GTIOInternalURLHelper* internalURLHelper = [[GTIOInternalURLHelper alloc] init];
    
    [map from:@"gtio://myProfile/myLooks" toObject:internalURLHelper selector:@selector(showMyLooks)];
    [map from:@"gtio://myProfile/myReviews" toObject:internalURLHelper selector:@selector(showMyReviews)];

	// Convenience Helpers for SMS/E-mail
	[map from:@"gtio://looks/(initWithOutfitID:)" toViewController:NSClassFromString(@"GTIOOutfitViewController")];
	[map from:@"gtio://looks" toViewController:NSClassFromString(@"GTIOGiveAnOpinionTableViewController")];
	
	// Main external URL's. Not very pretty.
	[map from:@"gtio://external/showOutfitOnProfileTab/(showOutfitOnProfileTab:)" toObject:_externalURLHelper];	
	[map from:@"gtio://external/showOutfitOnGiveAnOpinionTab/(showOutfitOnGiveAnOpinionTab:)" toObject:_externalURLHelper];
	[map from:@"gtio://external/ensureLogin/showProfileTab" toObject:_externalURLHelper selector:@selector(showOutfitOnProfileTab:)];
	[map from:@"gtio://external/ensureLogin/showOutfitOnProfileTab/(requireLoginAndShowOutfitOnProfileTab:)" toObject:_externalURLHelper];
	[map from:@"gtio://external/ensureLogin/showGiveAnOpinionTab" toObject:_externalURLHelper selector:@selector(showOutfitOnGiveAnOpinionTab:)];
	[map from:@"gtio://external/ensureLogin/showOutfitOnGiveAnOpinionTab/(requireLoginAndShowOutfitOnGiveAnOpinionTab:)" toObject:_externalURLHelper];
	
	[map from:@"gtio://launching" toSharedViewController:NSClassFromString(@"GTIOLaunchingViewController")];
	[map from:@"gtio://settings" toSharedViewController:NSClassFromString(@"GTIOSettingsViewController")];
	[map from:@"gtio://contacts" toModalViewController:NSClassFromString(@"GTIOContactViewController")];
	[map from:@"gtio://photosPreview" toSharedViewController:NSClassFromString(@"GTIOPhotosPreviewViewController")];
	[map from:@"gtio://takeAPicture" toModalViewController:NSClassFromString(@"GTIOTakeAPictureViewController")];
	[map from:@"gtio://photoGuidelines" toViewController:NSClassFromString(@"GTIOPhotoGuidelinesViewController") transition:UIViewAnimationTransitionCurlDown];
	
	// Get an Opinion
	[map from:@"gtio://getAnOpinion" toSharedViewController:NSClassFromString(@"GTIOGetAnOpinionViewController")];
	[map from:@"gtio://getAnOpinion/photosPreview" parent:@"gtio://getAnOpinion" toSharedViewController:NSClassFromString(@"GTIOPhotosPreviewViewController")];
	[map from:@"gtio://getAnOpinion/tellUsAboutIt/multiplePhotos" parent:@"gtio://getAnOpinion/photosPreview" toSharedViewController:NSClassFromString(@"GTIOTellUsAboutItViewController")];
	[map from:@"gtio://getAnOpinion/tellUsAboutIt" parent:@"gtio://getAnOpinion" toSharedViewController:NSClassFromString(@"GTIOTellUsAboutItViewController")];
	[map from:@"gtio://getAnOpinion/share" toViewController:NSClassFromString(@"GTIOShareViewController")];	
	
	// Give an Opinion
	[map from:@"gtio://giveAnOpinion" toViewController:NSClassFromString(@"GTIOGiveAnOpinionTableViewController")];
	// Registered within the controller...
	
	// Profile view
	[map from:@"gtio://profile" toViewController:NSClassFromString(@"GTIOProfileViewController")];	
	[map from:@"gtio://profile/look/(initWithOutfitID:)" toViewController:NSClassFromString(@"GTIOOutfitViewController")];
	
	[map from:@"gtio://profile/new" toModalViewController:NSClassFromString(@"GTIOEditProfileViewController") selector:@selector(initWithNewProfile)];
	[map from:@"gtio://profile/edit" toModalViewController:NSClassFromString(@"GTIOEditProfileViewController") selector:@selector(initWithEditProfile)];		
	[map from:@"gtio://profile/edit/picture/(initWithName:)/(location:)" toModalViewController:NSClassFromString(@"GTIOEditProfilePictureViewController")];
	[map from:@"gtio://profile/(initWithUserID:)" toViewController:NSClassFromString(@"GTIOProfileViewController")];
    [map from:@"gtio://profile/new/addStylists" toModalViewController:[GTIOProfileCreatedAddStylistsViewController class]];
     
	// Get an Opinion session
	GTIOOpinionRequestSession* session = [GTIOOpinionRequestSession globalSession];
	[map from:@"gtio://getAnOpinion/start" toObject:session selector:@selector(start)];
	[map from:@"gtio://getAnOpinion/next" toObject:session selector:@selector(next)];
	[map from:@"gtio://getAnOpinion/cancel" toObject:session selector:@selector(cancel)];
	[map from:@"gtio://getAnOpinion/share/contacts" toObject:session selector:@selector(shareWithContacts)];
	
	[map from:@"gtio://getAnOpinion/photos/new" toObject:session selector:@selector(presentPhotoSourceActionSheetWithoutGuidelines)];
	[map from:@"gtio://getAnOpinion/photos/edit/(editPhoto:)" toObject:session selector:@selector(editPhoto:)];
    
    [map from:@"gtio://stylists" toViewController:NSClassFromString(@"GTIOMyStylistsTableViewController")];
    [map from:@"gtio://stylists/edit" toViewController:NSClassFromString(@"GTIOMyStylistsTableViewController") selector:@selector(initWithEditEnabled)];
    [map from:@"gtio://stylists/add" toViewController:NSClassFromString(@"GTIOAddStylistsViewController")];
    [map from:@"gtio://pushStylists" toModalViewController:[GTIOPushPersonalStylistsViewController class]];
	
	// step1/next for the current next
	// cancel will drop it anywhere
	// TODO: tellUsAboutIt (step2), takeAPicture (step1), share (step3). Considering centralizing navigation into the session to decouple controllers
	[map from:@"gtio://getAnOpinion/submit" toObject:session selector:@selector(submit)];
    [map from:@"gtio://getAnOpinion/cancelUpload" toObject:session selector:@selector(cancelUpload)];
	
	// Analytics Tracking
	GTIOAnalyticsTracker* tracker = [GTIOAnalyticsTracker sharedTracker];
	[map from:@"gtio://analytics/(dispatchEventWithName:)" toObject:tracker];
    
	
	// Message composer
	_messageComposer = [[GTIOMessageComposer alloc] init];
	[map from:@"gtio://messageComposer/email/(emailComposerWithOutfitID:)/(subject:)/(body:)" toModalViewController:_messageComposer];
	[map from:@"gtio://messageComposer/textMessage/(textMessageComposerWithOutfitID:)/(body:)" toModalViewController:_messageComposer];
    
	//[map from:@"gtio://popViewController" toObject:session selector:@selector(popViewController)];
	[map from:@"gtio://popToRootViewController" toObject:session selector:@selector(popToRootViewController)];
	
	[map from:@"gtio://show_reviews/(initWithOutfitID:)" toViewController:NSClassFromString(@"GTIOOutfitReviewsController") transition:UIViewAnimationTransitionFlipFromRight];
	
	// Map loading urls
	[map from:@"gtio://loading" toObject:[GTIOLoadingOverlayManager sharedManager] selector:@selector(showLoading)];
	[map from:@"gtio://stopLoading" toObject:[GTIOLoadingOverlayManager sharedManager] selector:@selector(stopLoading)];
    
    [map from:@"gtio://browse" toViewController:NSClassFromString(@"GTIOBrowseTableViewController")];
    [map from:@"gtio://browse/(initWithAPIEndpoint:)" toViewController:NSClassFromString(@"GTIOBrowseTableViewController")];
    [map from:@"gtio://browse/(initWithAPIEndpoint:)/(searchText:)" toViewController:NSClassFromString(@"GTIOBrowseTableViewController")];
    
    [map from:@"gtio://todos" toViewController:NSClassFromString(@"GTIOTodosTableViewController")];
    [map from:@"gtio://todos/(initWithAPIEndpoint:)" toViewController:NSClassFromString(@"GTIOTodosTableViewController")];
    
    [map from:@"gtio://whoIStyle" toViewController:NSClassFromString(@"GTIOWhoIStyleTableViewController")];
    [map from:@"gtio://featured" toViewController:NSClassFromString(@"GTIOFeaturedViewController")];
	
    
	// All other links open the web controller
	[map from:@"*" toViewController:[TTWebController class]];
	
    navigator.window = self.window;
    [self.window makeKeyAndVisible];
    
	[navigator openURLAction:
	 [[TTURLAction actionWithURLPath:@"gtio://launching"] applyAnimated:NO]];	
	
	// User Account housekeeping
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(userDidLoginWithIncompleteProfile:) 
												 name:kGTIOUserDidLoginWithIncompleteProfileNotificationName 
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:kGTIOUserDidLoginNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:kGTIOUserDidLogoutNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidStartLogin:) name:kGTIOUserDidBeginLoginProcess object:nil];
	
	// Handle Launch Options
	if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
		NSDictionary* aps = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"];
		[self performSelector:@selector(viewRemoteNotification:) withObject:aps afterDelay:1.0];
	} else if ([launchOptions objectForKey:UIApplicationLaunchOptionsURLKey]) {
		// Save the launch URL for dispatch after the session has been resumed
		NSURL* URL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
		if (NO == [[URL absoluteString] isEqualToString:@"gtio://external/launch"]) {
			_launchURL = [URL retain];
		} 
	}
//    _launchURL = [[NSURL URLWithString:@"gtio://looks/F180C6D"] retain];
	
	// Bring the reachability observer online
	[GTIOReachabilityObserver sharedObserver];
	
    // Initialize RestKit
    [self setupRestKit];
    
	// Register for Push Notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    // Sometimes the callback isn't getting called. Resume manually... HRM... NOT WORKING ON IOS4...
    [self resumeSession];
	
	// Track app load
	TTOpenURL(@"gtio://analytics/trackAppDidFinishLaunching");
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
	return YES;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	// Special handling for the external launch URL: gtio://external/launch
	// If we are have been launched via gtio://external/launch and there is not a top view controller
	// we want to show the Home screen (gtio://home)
	if ([[URL absoluteString] isEqualToString:@"gtio://external/launch"]) {
		if (nil == [TTNavigator globalNavigator].topViewController) {
			[[TTNavigator navigator] openURLAction:
			 [TTURLAction actionWithURLPath:@"gtio://home"]];
			
			return YES;			
		}
	} else if ([[URL absoluteString] rangeOfString:@"fb"].location == 0) {
        Facebook* facebook = [GTIOUser currentUser].facebook;
        return [facebook handleOpenURL:URL];
    } else {
		if (![URL isEqual:_launchURL]) {
            [self performSelector:@selector(openNotificationUrl:)
                       withObject:URL.absoluteString
                       afterDelay:0.5];
			return YES;
		}
	}		
	
	return NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_externalURLHelper release];
    [_messageComposer release];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	TTOpenURL(@"gtio://analytics/trackAppDidBecomeActive");
	if (_lastWentInactiveAt) {
		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_lastWentInactiveAt];
		NSLog(@"Inactive for: %f seconds", interval);
        
        #if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING
		NSTimeInterval refreshInterval = 30;
        #else
        NSTimeInterval refreshInterval = 60*15;
        #endif

		if (interval >= refreshInterval) {
			// Refresh notifications and todos.
			[[GTIOUser currentUser] resumeSession];
            TTOpenURL(@"gtio://getAnOpinion/cancelUpload"); // if we were in the middle of an upload, hide loading.
			TTOpenURL(@"gtio://home");
            
			UIViewController* rootController = [[[[TTNavigator navigator] topViewController].navigationController viewControllers] objectAtIndex:0];
			NSLog(@"Root Controller: %@", rootController);
			if ([rootController isKindOfClass:NSClassFromString(@"GTIOEditProfileViewController")]) {
				[rootController dismissModalViewControllerAnimated:NO];
				rootController = [[[[TTNavigator navigator] topViewController].navigationController viewControllers] objectAtIndex:0];
			}
			if ([rootController isKindOfClass:NSClassFromString(@"GTIOGiveAnOpinionTableViewController")] ||
				[rootController isKindOfClass:NSClassFromString(@"GTIOProfileViewController")]) {
				[[[TTNavigator navigator] topViewController].navigationController popToRootViewControllerAnimated:NO];
                [(TTModelViewController*)rootController invalidateModel];
			}
		}

		[_lastWentInactiveAt release];
		_lastWentInactiveAt = nil;
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
	_lastWentInactiveAt = [[NSDate date] retain];
}

- (void)openNotificationUrl:(NSString*)url {
    // Don't try and pop the stack while we are pushing another one on.
    if (_lastWentInactiveAt) {
        [_lastWentInactiveAt release];
        _lastWentInactiveAt = nil;
    }
    UIViewController* vc = [[TTNavigator navigator] viewControllerForURL:url];
    if ([vc isKindOfClass:[TTWebController class]]) {
        // don't open web urls. it probably just didnt match anything.
        return;
    }
    // Trigger view load. for some reason this is not happening.
    vc.view;
    // By adding this wait, i've fixed the issue where if the app was returning to the home screen
    // and we were being opened via a URL, it would show a navigation bar for the view but no view (over the home screen).
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    [[[TTNavigator navigator] topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)handleLaunchURL {
	if (_launchURL) {
        UIViewController* tvc = [[TTNavigator navigator] topViewController];
        // wait until we hit the home screen..
        while ([tvc isKindOfClass:NSClassFromString(@"GTIOLaunchingViewController")]) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            tvc = [[TTNavigator navigator] topViewController];
        }
        [self openNotificationUrl:[_launchURL absoluteString]];
		
		[_launchURL release];
		_launchURL = nil;
	}
}

- (void)resumeSession {
    GTIOUser* user = [GTIOUser currentUser];
    if (user.token) {
        [user resumeSession];
    } else {
        _showStylistPush = YES;
        // This doesn't actually log us in, it just loads the globals.
        // This was sort of overlooked when we removed the /status call.
        [user resumeSession];
        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"gtio://home"] applyAnimated:NO]];
        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"gtio://welcome"] applyAnimated:NO]];
        [self handleLaunchURL];
    }
}


#pragma mark User Login

- (void)userDidStartLogin:(NSNotification*)note {
    _showStylistPush = YES;
}

- (void)userDidLogin:(NSNotification*)note {
    UIViewController* home = [[TTNavigator navigator] viewControllerForURL:@"gtio://home"];
    if (nil == home.parentViewController) {
        // If it's not on the stack, open it.
        TTOpenURL(@"gtio://home");
    }
    GTIOUser* user = [GTIOUser currentUser];
    #if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_PRODUCTION
        [Crittercism setUsername:user.UID];
    #endif
    if (user.stylistsCount != nil && [user.stylistsCount intValue] == 0 && _showStylistPush && ![user.showAlmostDoneScreen boolValue]) {
        // Wait for other navigations to finish
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
//        TTOpenURL(@"gtio://pushStylists");
        TTOpenURL(@"gtio://profile/new/addStylists");
        
    } else if ([user.showAlmostDoneScreen boolValue]) {
         [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
         TTOpenURL(@"gtio://profile/new");
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    [self handleLaunchURL];
}

- (void)userDidLogout:(NSNotification*)note {
    UIViewController* home = [[TTNavigator navigator] viewControllerForURL:@"gtio://home"];
    if (nil == home.parentViewController) {
        TTOpenURL(@"gtio://home");
        TTOpenURL(@"gtio://welcome");
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    [self handleLaunchURL];
}

#pragma mark Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {	
	GTIOUser* user = [GTIOUser currentUser];
	NSString* deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
	NSRange range = NSMakeRange(1, [deviceTokenString length] - 2);
	deviceTokenString = [deviceTokenString substringWithRange:range];
	user.deviceToken = deviceTokenString;
	NSLog(@"Sucessfully registered for push notifications. Device Token = %@", deviceTokenString);
    
    [user resumeSession];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Unable to register for remote notifications: %@", [error localizedDescription]);
	GTIOUser* user = [GTIOUser currentUser];
	user.deviceToken = nil;
	
    [user resumeSession];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {	
	NSDictionary* aps = [userInfo objectForKey:@"aps"];
	// If we multi task, and were already active, or we don't multitask, show alert
	if (([application respondsToSelector:@selector(applicationState)] 
         && UIApplicationStateActive == [application applicationState]) ||
		![application respondsToSelector:@selector(applicationState)]) {
		id alert = [aps objectForKey:@"alert"];
		NSString* message = nil;
		BOOL showViewButton = YES;
		if ([alert isKindOfClass:[NSString class]]) {
			message = alert;
		} else {
			message = [alert objectForKey:@"body"];
			if ([alert objectForKey:@"show-view"] != nil) {
				showViewButton = [[alert objectForKey:@"show-view"] boolValue];
			}
		}
		if (showViewButton) {
			TWTAlertViewDelegate* delegate = [[TWTAlertViewDelegate alloc] init];
			[delegate setTarget:self selector:@selector(viewRemoteNotification:) object:aps forButtonIndex:1];
			[[[[UIAlertView alloc] initWithTitle:@"GO TRY IT ON" 
										 message:message 
										delegate:delegate
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:@"View", nil] autorelease] show];
			[delegate autorelease];
		} else {
			[[[[UIAlertView alloc] initWithTitle:@"GO TRY IT ON" 
										 message:message 
										delegate:nil 
							   cancelButtonTitle:@"OK" 
							   otherButtonTitles:nil] autorelease] show];
		}
	} else {
		[self viewRemoteNotification:aps];
	}
}

- (void)viewRemoteNotification:(NSDictionary*)aps {
	// This gets called with the aps dictionary if the user taps the View button or the app is launched by a remote notification
	NSLog(@"View Remote Notification: %@", aps);
	// Let's assume that they will give us a tturl to open for now.
	NSString* url = [[aps objectForKey:@"loc-args"] objectForKey:@"url"];
	if (url) {
        [self openNotificationUrl:url];
	}
}
#ifdef FRANK

// Frank Helpers. Login, Logout, open URL, etc. Anything that needs to modify state of the app.

- (void)franklyLogoutUser {
    [[GTIOUser currentUser] logout];
}

- (void)franklyOpenURL:(NSString*)URL {
    TTOpenURL(URL);
}

- (void)franklyLogin {
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"userprofiledata" ofType:@"plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *data = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];    
    GTIOUser* user = [GTIOUser currentUser];
    [user digestProfileInfo:data];
	[user setLoggedIn:YES];
}

#endif

@end
