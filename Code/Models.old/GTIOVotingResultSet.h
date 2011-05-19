//
//  GTIOVotingResultSet.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GTIOVotingResultSet : NSObject {
	NSArray* _reasons;
	NSNumber* _totalVotes;
	NSString* _userVoteString;
	NSString* _voteRecordedString;
	NSString* _verdict;
	NSNumber* _wear0;
	NSNumber* _wear1;
	NSNumber* _wear2;
	NSNumber* _wear3;
	NSNumber* _wear4;
	NSNumber* _winningOutfit;
	NSNumber* _pending;
}

@property (nonatomic, retain) NSNumber *pending;
@property (nonatomic, readonly) BOOL isPending;
@property (nonatomic, copy) NSArray *reasons;
@property (nonatomic, retain) NSNumber *totalVotes;
@property (nonatomic, copy) NSString *userVoteString;
@property (nonatomic, copy) NSString *voteRecordedString;
@property (nonatomic, copy) NSString *verdict;
@property (nonatomic, retain) NSNumber *wear0;
@property (nonatomic, retain) NSNumber *wear1;
@property (nonatomic, retain) NSNumber *wear2;
@property (nonatomic, retain) NSNumber *wear3;
@property (nonatomic, retain) NSNumber *wear4;
@property (nonatomic, retain) NSNumber *winningOutfit;

@property (nonatomic, readonly) NSInteger userVoteIndex;
@property (nonatomic, readonly) NSInteger numberOfOutfits;
@property (nonatomic, readonly) NSInteger winningVoteCount;

@end
