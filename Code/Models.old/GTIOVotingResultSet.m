//
//  GTIOVotingResultSet.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOVotingResultSet.h"


@implementation GTIOVotingResultSet

@synthesize pending = _pending;
@synthesize reasons = _reasons;
@synthesize totalVotes = _totalVotes;
@synthesize userVoteString = _userVoteString;
@synthesize voteRecordedString = _voteRecordedString;
@synthesize verdict = _verdict;
@synthesize wear0 = _wear0;
@synthesize wear1 = _wear1;
@synthesize wear2 = _wear2;
@synthesize wear3 = _wear3;
@synthesize wear4 = _wear4;
@synthesize winningOutfit = _winningOutfit;

- (void)dealloc {
	[_reasons release];
	_reasons = nil;
	[_totalVotes release];
	_totalVotes = nil;
	[_userVoteString release];
	_userVoteString = nil;
	[_voteRecordedString release];
	_voteRecordedString = nil;
	[_verdict release];
	_verdict = nil;
	[_wear0 release];
	_wear0 = nil;
	[_wear1 release];
	_wear1 = nil;
	[_wear2 release];
	_wear2 = nil;
	[_wear3 release];
	_wear3 = nil;
	[_wear4 release];
	_wear4 = nil;
	[_winningOutfit release];
	_winningOutfit = nil;

	[_pending release];
	_pending = nil;

	[super dealloc];
}

+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithKeysAndObjects:
			@"reasons", @"reasons",
			@"totalVotes", @"totalVotes",
			@"userVote", @"userVoteString",
			@"verdict", @"verdict",
			@"voteRecorded", @"voteRecordedString",
			@"wear0", @"wear0",
			@"wear1", @"wear1",
			@"wear2", @"wear2",
			@"wear3", @"wear3",
			@"wear4", @"wear4",
			@"pending", @"pending",
			@"winning", @"winningOutfit", nil];
}

- (void)setUserVoteString:(NSString *)str {
	if ([str isKindOfClass:[NSString class]]) {
		NSString* newValue = [str copy];
		[_userVoteString release];
		_userVoteString = newValue;
	} else {
		// This is set to a CFBoolean (false) if it should actually be blank...
		[_userVoteString release];
		_userVoteString = nil;
	}
}

- (NSInteger)userVoteIndex {
	if (nil == _userVoteString) {
		return -1;
	}
	return [[_userVoteString stringByReplacingOccurrencesOfString:@"wear" withString:@""] intValue];
}

- (NSInteger)numberOfOutfits {
	if (nil == _wear2) {
		return 1;
	}
	if (nil == _wear3) {
		return 2;
	}
	if (nil == _wear4) {
		return 3;
	}
	return 4;
}

- (BOOL)isPending {
	return [_pending boolValue];
}

- (int)winningVoteCount {
	return MAX(MAX(MAX(MAX([_wear1 intValue], [_wear2 intValue]), [_wear3 intValue]), [_wear4 intValue]), [_wear0 intValue]);
}

@end
