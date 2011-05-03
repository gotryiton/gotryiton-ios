//
//  GTIOPaginationTableViewDelegate.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface GTIOPaginationTableViewDelegate : TTTableViewDragRefreshDelegate {
	BOOL _loading;
	UIView* _loadingMoreView;
}

- (void)hideLoadMore;

@end
