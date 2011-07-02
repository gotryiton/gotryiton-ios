//
//  GTIOAnalyticsEvents.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

NSString* const kAppDidFinishLaunchingEventName;
NSString* const kAppDidBecomeActiveEventName;
NSString* const kUserDidRegisterOniPhoneEventName;
NSString* const kUserDidLoginOniPhoneEventName;
NSString* const kUserDidLogoutOniPhoneEventName;
NSString* const kUserDidViewGetStartedEventName;
NSString* const kUserDidViewTellUsAboutItEventName;
NSString* const kUserDidViewShareEventName;
NSString* const kUserDidViewWelcomeScreenEventName;
NSString* const kUserDidViewHomepageEventName;
NSString* const kUserDidViewSettingsTabEventName;
NSString* const kUserDidViewLoginEventName;
NSString* const kUserDidViewAddFromContactsEventName;
NSString* const kUserDidViewPhotoGuidelinesEventName;
NSString* const kUserDidApplyBlurMaskEventName;
NSString* const kUserDidTouchCreateMyOutfitPageEventName;
NSString* const kUserDidAddContactEventName;
NSString* const kUserDidRemoveContactEventName;
NSString* const kUserDidTouchGiveAnOpinionFromHomePageEventName;
NSString* const kUserDiDTouchGetAnOpinionFromHomePageEventName;
NSString* const kUserDidSubmitOutfitWithParametersEventName;
NSString* const kControllerDidAppearEventName;

//i'd like these pages separated out as events
NSString* const kOutfitPageView; // DONE
NSString* const kRecentListPageView; // DONE
NSString* const kPopularListPageView; // DONE
NSString* const kProfilePageView; // DONE
NSString* const kMyProfilePageView; // DONE

//nice to have: include searchQuery -> [query] as a param
NSString* const kSearch; // DONE

NSString* const kAnyListRefresh; // DONE
NSString* const kOutfitRefresh; // DONE

NSString* const kOutfitDescriptionExpand; // DONE
NSString* const kOutfitFullScreen; // Done

//please include param "voteType" => [wear0, wear1, etc]
NSString* const kVoteSubmitted; //DONE

NSString* const kWhyChangeSubmitted; // DONE
NSString* const kWhyChangeSkipped; // Done

NSString* const kOutfitEdit; //done
NSString* const kOutfitDelete; //done
NSString* const kOutfitPublic; // done
NSString* const kOutfitPrivate; //done

NSString* const kOutfitShareSMS;  //DONE
NSString* const kOutfitShareEmail;  //DONE


//nice to have param:  reviewBox -> "front" or "back"
NSString* const kReviewSubmitted;  //DONE

NSString* const kReviewFlag;
NSString* const kReviewAgree;

NSString* const kUserLoggedInParameterName;