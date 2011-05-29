//
//  GTIOGiveAnOpinionTableViewDataSource.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/23/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOGiveAnOpinionTableViewDataSource is used by the [GTIOGiveAnOpinionTableViewController](GTIOGiveAnOpinionTableViewController); Both Candidates for Deletion

#import <Three20/Three20.h>

@interface GTIOGiveAnOpinionTableViewDataSource : TTListDataSource <TTURLRequestDelegate, UIWebViewDelegate> {
	NSArray* _outfits;
	UIWebView* _imageWebView;
}

@property (nonatomic, retain) NSArray* outfits;

@end
