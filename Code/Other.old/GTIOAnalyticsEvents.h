//
//  GTIOAnalyticsEvents.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

UIViewController* GTIOAnalyticsEvent(NSString* name);

NSString* GTIOAnalyticsBrandedProfileEventNameFor(NSString* name);
NSString* GTIOAnalyticsBrandedProfileLooksEventNameFor(NSString* name);
NSString* GTIOAnalyticsBrandedProfileReviewsEventNameFor(NSString* name);

extern NSString* const kAppDidFinishLaunchingEventName;
extern NSString* const kAppDidBecomeActiveEventName;
extern NSString* const kUserDidRegisterOniPhoneEventName;
extern NSString* const kUserDidLoginOniPhoneEventName;
extern NSString* const kUserDidLogoutOniPhoneEventName;
extern NSString* const kUserDidViewGetStartedEventName;
extern NSString* const kUserDidViewTellUsAboutItEventName;
extern NSString* const kUserDidViewShareEventName;
extern NSString* const kUserDidViewWelcomeScreenEventName;
extern NSString* const kUserDidViewHomepageEventName;
extern NSString* const kUserDidViewSettingsEventName;
extern NSString* const kUserDidViewLoginEventName;
extern NSString* const kUserDidViewLoginOtherProvidersEventName;
extern NSString* const kUserDidViewPhotoGuidelinesEventName;
extern NSString* const kUserDidApplyBlurMaskEventName;
extern NSString* const kUserDidTouchCreateMyOutfitPageEventName;
extern NSString* const kUserDidTouchGiveAnOpinionFromHomePageEventName;
extern NSString* const kUserDiDTouchGetAnOpinionFromHomePageEventName;
extern NSString* const kUserDidSubmitOutfitWithParametersEventName;
extern NSString* const kControllerDidAppearEventName;

//i'd like these pages separated out as events
extern NSString* const kOutfitPageView; // DONE
extern NSString* const kRecentListPageView; // DONE
extern NSString* const kPopularListPageView; // DONE
extern NSString* const kUserDidViewProfilePageEventName; // DONE
extern NSString* const kUserDidViewMyProfilePageEventName; // DONE

//nice to have: include searchQuery -> [query] as a param
extern NSString* const kSearch; // DONE

extern NSString* const kAnyListRefresh; // DONE
extern NSString* const kOutfitRefreshEventName;
extern NSString* const kOutfitDescriptionExpandedEventName; // DONE
extern NSString* const kOutfitFullScreenEventName; // Done

//please include param "voteType" => [wear0, wear1, etc]
extern NSString* const kVoteSubmitted; //DONE

extern NSString* const kWhyChangeSubmitted; // DONE
extern NSString* const kWhyChangeSkipped; // Done

extern NSString* const kOutfitEdit; //done
extern NSString* const kOutfitDelete; //done
extern NSString* const kOutfitPublic; // done
extern NSString* const kOutfitPrivate; //done

extern NSString* const kOutfitShareSMS;  //DONE
extern NSString* const kOutfitShareEmail;  //DONE


//nice to have param:  reviewBox -> "front" or "back"
extern NSString* const kReviewSubmitted;  //DONE

extern NSString* const kReviewFlag;
extern NSString* const kReviewAgree;

extern NSString* const kUserLoggedInParameterName;

extern NSString* const kUserSignUpAlmostDoneEventName;
extern NSString* const kUserEditProfileEventName;
extern NSString* const kUserEditProfilePictureEventName;
extern NSString* const kMyLooksEventName;
extern NSString* const kMyReviewsEventName;
extern NSString* const kMyStylistsEventName;
extern NSString* const kAddStylistsEventName;
extern NSString* const kEditStylistsEventName;
extern NSString* const kAddContactsStylistsEventName;
extern NSString* const kAddRecommendedStylistsEventName;
extern NSString* const kNotificationsPageEventName;
extern NSString* const kFeaturedStylistsPageEventName;
extern NSString* const kProfileLooksEventName;
extern NSString* const kProfileReviewsEventName;
extern NSString* const kTodosPageEventName;
extern NSString* const kCommunityTodosEventName;
extern NSString* const kCompletedTodosEventName;
extern NSString* const kWhoIStyleEventName;
extern NSString* const kBrowseEventName;
extern NSString* const kStylistsIntroEventName;
extern NSString* const kUploadGetStartedEventName;
extern NSString* const kUploadStepTwoEventName;
extern NSString* const kBrandedProfileEventName;
extern NSString* const kBrandedProfileLooksEventName;
extern NSString* const kBrandedProfileReviewsEventName;
extern NSString* const kCategoryPageEventNamePrefix;
extern NSString* const kOutfitListPageEventNamePrefix;
extern NSString* const kUnknownEventName;
extern NSString* const kGTIOListRefreshEventName;
extern NSString* const kUserAddedStylistsEventName;
extern NSString* const kUserDeletedStylistEventName;
extern NSString* const kUserIgnoredStylistEventName;
extern NSString* const kUserEditedProfileEventName;
extern NSString* const kUserEditedProfileIconEventName;
extern NSString* const kUserAddedFacebook;