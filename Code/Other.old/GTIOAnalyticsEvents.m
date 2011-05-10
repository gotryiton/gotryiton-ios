//
//  GTIOAnalyticsEvents.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "GTIOAnalyticsEvents.h"

NSString* const kAppDidFinishLaunchingEventName = @"App - Launched";
NSString* const kAppDidBecomeActiveEventName = @"App - Became Active";
NSString* const kUserDidRegisterOniPhoneEventName = @"User - Registed";
NSString* const kUserDidLoginOniPhoneEventName = @"User - Login";
NSString* const kUserDidLogoutOniPhoneEventName = @"User - Logout";
NSString* const kUserDidViewGetStartedEventName = @"Upload - getStarted";
NSString* const kUserDidViewTellUsAboutItEventName = @"Upload - Step2";
NSString* const kUserDidViewShareEventName = @"Upload - Step3";
NSString* const kUserDidViewHomepageEventName = @"Page - Homepage";
NSString* const kUserDidViewSettingsTabEventName = @"Page - Settings";
NSString* const kUserDidViewLoginEventName = @"Page - Login";
NSString* const kUserDidViewAddFromContactsEventName = @"Upload - addContacts";
NSString* const kUserDidViewPhotoGuidelinesEventName = @"Upload - photoGuidelines";
NSString* const kUserDidApplyBlurMaskEventName = @"Upload - blurMask";
NSString* const kUserDidTouchCreateMyOutfitPageEventName = @"Upload - createButtonClicked";
NSString* const kUserDidAddContactEventName = @"Upload - addedContact";
NSString* const kUserDidRemoveContactEventName = @"Upload - removedContact";
NSString* const kUserDidTouchGiveAnOpinionFromHomePageEventName = @"Page - Homepage - GiveOpinionButton";
NSString* const kUserDiDTouchGetAnOpinionFromHomePageEventName = @"Page - Homepage - GetOpinionButton";
NSString* const kUserDidSubmitOutfitWithParametersEventName = @"Upload - Successful Upload";
NSString* const kControllerDidAppearEventName = @"Page - General Controller View";




NSString* const kOutfitPageView = @"Page - Outfit";
NSString* const kRecentListPageView = @"Page - Recent";
NSString* const kPopularListPageView = @"Page - Popular";
NSString* const kProfilePageView = @"Page - Profile";
NSString* const kMyProfilePageView = @"Page - My Profile";
NSString* const kSearch = @"Search";
NSString* const kAnyListRefresh = @"Page - List - Refresh";
NSString* const kOutfitRefresh = @"Page - Outfit - Refresh";
NSString* const kOutfitDescriptionExpand = @"Page - Outfit - Expand Description";
NSString* const kOutfitFullScreen= @"Page - Outfit - Full Screen";
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