
//
//  GTIOAnalyticsEvents.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#include "GTIOAnalyticsEvents.h"

UIViewController* GTIOAnalyticsEvent(NSString* name) {
    return TTOpenURL([NSString stringWithFormat:@"gtio://analytics/%@",
            [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]);
}

NSString* GTIOAnalyticsBrandedProfileEventNameFor(NSString* name) {
    return [kBrandedProfileEventName stringByAppendingString:name];
}

NSString* GTIOAnalyticsBrandedProfileLooksEventNameFor(NSString* name) {
    return [kBrandedProfileLooksEventName stringByAppendingString:name];
}

NSString* GTIOAnalyticsBrandedProfileReviewsEventNameFor(NSString* name) {
    return [kBrandedProfileReviewsEventName stringByAppendingString:name];
}

NSString* const kAppDidFinishLaunchingEventName = @"App - Launched";
NSString* const kAppDidBecomeActiveEventName = @"App - Became Active";
NSString* const kUserDidRegisterOniPhoneEventName = @"User - Registed";
NSString* const kUserDidLoginOniPhoneEventName = @"User - Login";
NSString* const kUserDidLogoutOniPhoneEventName = @"User - Logout";
NSString* const kUserDidViewGetStartedEventName = @"Upload - getStarted";
NSString* const kUserDidViewTellUsAboutItEventName = @"Upload - Step2";
NSString* const kUserDidViewShareEventName = @"Upload - Step3";
NSString* const kUserDidViewWelcomeScreenEventName = @"Page - Welcome";
NSString* const kUserDidViewHomepageEventName = @"Page - Homepage";
NSString* const kUserDidViewSettingsEventName = @"Page - Settings";
NSString* const kUserDidViewLoginEventName = @"Page - Login";
NSString* const kUserDidViewLoginOtherProvidersEventName = @"Page - Login Other Providers";
NSString* const kUserDidViewPhotoGuidelinesEventName = @"Upload - photoGuidelines";
NSString* const kUserDidApplyBlurMaskEventName = @"Upload - blurMask";
NSString* const kUserDidTouchCreateMyOutfitPageEventName = @"Upload - createButtonClicked";
NSString* const kUserDidTouchGiveAnOpinionFromHomePageEventName = @"Page - Homepage - GiveOpinionButton";
NSString* const kUserDiDTouchGetAnOpinionFromHomePageEventName = @"Page - Homepage - GetOpinionButton";
NSString* const kUserDidSubmitOutfitWithParametersEventName = @"Upload - Successful Upload";
NSString* const kControllerDidAppearEventName = @"Page - General Controller View";

NSString* const kOutfitPageView = @"Page - Outfit";
NSString* const kRecentListPageView = @"Page - Recent";
NSString* const kPopularListPageView = @"Page - Popular";
NSString* const kUserDidViewProfilePageEventName = @"Page - Profile";
NSString* const kUserDidViewMyProfilePageEventName = @"Page - My Profile";
NSString* const kSearch = @"Search";
NSString* const kAnyListRefresh = @"Page - List - Refresh";
NSString* const kOutfitRefreshEventName = @"Page - Outfit - Refresh";
NSString* const kOutfitDescriptionExpandedEventName = @"Page - Outfit - Expand Description";
NSString* const kOutfitFullScreenEventName= @"Page - Outfit - Full Screen";
NSString* const kVoteSubmitted = @"Vote";
NSString* const kWhyChangeSubmitted = @"Why Change";
NSString* const kWhyChangeSkipped = @"Why Change Skip";
NSString* const kOutfitEdit = @"Outfit Tools - Edit";
NSString* const kOutfitDelete = @"Outfit Tools - Delete";
NSString* const kOutfitPublic = @"Outfit Tools - Public";
NSString* const kOutfitPrivate = @"Outfit Tools - Private";
NSString* const kOutfitShareSMS = @"Outfit Share - SMS";
NSString* const kOutfitShareEmail = @"Outfit Share - Email";
NSString* const kReviewSubmitted = @"Review";
NSString* const kReviewFlag = @"Review - flagged";
NSString* const kReviewAgree = @"Review - agree";

NSString* const kUserLoggedInParameterName = @"Logged In";

NSString* const kUserSignUpAlmostDoneEventName = @"Page - Almost Done";
NSString* const kUserEditProfileEventName = @"Page - Edit Profile";
NSString* const kUserEditProfilePictureEventName = @"Page - Edit Profile Icon";
NSString* const kMyLooksEventName = @"Page - My Looks";
NSString* const kMyReviewsEventName = @"Page - My Reviews";
NSString* const kMyStylistsEventName = @"Page - My Stylists";
NSString* const kAddStylistsEventName = @"Page - Add Stylists";
NSString* const kEditStylistsEventName = @"Page - Edit Stylists";
NSString* const kAddContactsStylistsEventName = @"Page - Add Stylists (Contacts)";
NSString* const kAddRecommendedStylistsEventName = @"Page - Add Stylists (Recommended)";
NSString* const kNotificationsPageEventName = @"Page - Notifications";
NSString* const kFeaturedStylistsPageEventName = @"Page = Featured Stylists";
NSString* const kProfileLooksEventName = @"Page - Profile Looks";
NSString* const kProfileReviewsEventName = @"Page - Profile Reviews";
NSString* const kTodosPageEventName = @"Page - Todos";
NSString* const kCommunityTodosEventName = @"Page - Community Todos";
NSString* const kCompletedTodosEventName = @"Page - Completed Todos";
NSString* const kWhoIStyleEventName = @"Page - Who I Style";
NSString* const kBrowseEventName = @"Page - Browse";
NSString* const kStylistsIntroEventName = @"Page - Stylists Intro";
NSString* const kUploadGetStartedEventName = @"Page - Upload Get Started";
NSString* const kUploadStepTwoEventName = @"Page - Upload Step 2";
NSString* const kBrandedProfileEventName = @"Page - Profile ";
NSString* const kBrandedProfileLooksEventName = @"Page - Profile Looks ";
NSString* const kBrandedProfileReviewsEventName = @"Page - Profile Reviews ";
NSString* const kCategoryPageEventNamePrefix = @"Page - Category ";
NSString* const kOutfitListPageEventNamePrefix = @"Page - Outfit List ";
NSString* const kUnknownEventName = @"Unknown";
NSString* const kGTIOListRefreshEventName = @"Page - List - Refresh";
NSString* const kUserAddedStylistsEventName = @"Action - Add Stylist";
NSString* const kUserDeletedStylistEventName = @"Action - Remove As Stylist";
NSString* const kUserIgnoredStylistEventName = @"Action - Ignore Stylee";
NSString* const kUserEditedProfileEventName = @"Edit Profile";
NSString* const kUserEditedProfileIconEventName = @"Edit Profile Icon";
NSString* const kUserAddedFacebook = @"User - Added Facebook";

NSString* const kSwipeDownOnHomeScreen = @"Page - Home Screen View Thumbnails";
NSString* const kSwipeUpOnHomeScreen = @"Page - Home Screen Hide Thumbnails";