//
//  GTIOPaginationTableViewDelegate.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOPaginationTableViewDelegate.h"
#import <Three20UI/TTTableHeaderDragRefreshView.h>
#import "GTIOPaginatedTTModel.h"

//#define kTableViewEdgeInsets UIEdgeInsetsMake(8, 0, 0, 0)
#define kTableViewEdgeInsets UIEdgeInsetsMake(0, 0, 0, 0)

@interface TTTableHeaderDragRefreshView (private)

- (void)setImageFlipped:(BOOL)flipped;
- (void)showActivity:(BOOL)activity animated:(BOOL)animated;

@end

@implementation TTTableHeaderDragRefreshView (Overrides)

- (NSString*)backgroundImageName {
    return @"background.png";
}

- (NSString*)arrowImageName {
    return @"arrow.png";
}

- (UIImageView*)bgImageView {
    return (UIImageView*)[self viewWithTag:99293];
}
//
//- (id)initWithFrame:(CGRect)frame {
//	if(self = [super initWithFrame:frame]) {
//		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		
//		UIImageView* bg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[self backgroundImageName]]] autorelease];
//        bg.tag = 99293;
//		bg.frame = self.bounds;
//		bg.contentMode = UIViewContentModeBottom;
//		[self addSubview:bg];
//		self.backgroundColor = RGBCOLOR(240,240,240);
//		
//		_statusLabel = [[UILabel alloc]
//						initWithFrame:CGRectMake(0.0f, frame.size.height - 25.0f,
//												 frame.size.width, 20.0f )];
//		_statusLabel.autoresizingMask =
//		UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
//		_statusLabel.font             = TTSTYLEVAR(tableRefreshHeaderStatusFont);
//		_statusLabel.textColor        = [UIColor darkGrayColor];
//		_statusLabel.shadowColor      = TTSTYLEVAR(tableRefreshHeaderTextShadowColor);
//		_statusLabel.shadowOffset     = TTSTYLEVAR(tableRefreshHeaderTextShadowOffset);
//		_statusLabel.backgroundColor  = [UIColor clearColor];
//		_statusLabel.textAlignment    = UITextAlignmentCenter;
//		[self setStatus:TTTableHeaderDragRefreshPullToReload];
//		[self addSubview:_statusLabel];
//		
//		_arrowImage = [[UIImageView alloc]
//					   initWithFrame:CGRectMake(149.0f, frame.size.height - 65.0f + 3,
//												23.0f, 41.0f)];
//		_arrowImage.contentMode       = UIViewContentModeScaleAspectFit;
//		_arrowImage.image             = [UIImage imageNamed:[self arrowImageName]];
//		[_arrowImage layer].transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
//		[self addSubview:_arrowImage];
//		
//		_activityView = [[UIActivityIndicatorView alloc]
//						 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//		_activityView.frame = CGRectMake( 150.0f, frame.size.height - 45.0f, 20.0f, 20.0f );
//		_activityView.hidesWhenStopped  = YES;
//		[self addSubview:_activityView];
//		
//        // TODO: this no longer exists and may mess up our drag refresh awesomeness?
//		// _isFlipped = NO;
//	}
//	return self;
//}
//
//- (void)setStatus:(TTTableHeaderDragRefreshStatus)status {
//	switch (status) {
//		case TTTableHeaderDragRefreshReleaseToReload: {
//			_statusLabel.text = @"release to update...";
//            [self setImageFlipped:YES];
//			break;
//		}
//			
//		case TTTableHeaderDragRefreshPullToReload: {
//			_statusLabel.text = @"pull down to update...";
//            [self setImageFlipped:NO];
//			break;
//		}
//			
//		case TTTableHeaderDragRefreshLoading: {
//			_statusLabel.text = @"updating...";
//            [self setImageFlipped:YES];
//			break;
//		}
//			
//		default: {
//			break;
//		}
//	}
//}

@end


@implementation GTIOPaginationTableViewDelegate

- (id)initWithController:(TTTableViewController*)controller {
	if (self = [super initWithController:controller]) {
		// Add our refresh header
		CGRect frame = CGRectMake(0, _controller.tableView.superview.bounds.size.height+30, _controller.tableView.superview.width, 30);
		_loadingMoreView = [[TTActivityLabel alloc] initWithFrame:frame style:TTActivityLabelStyleBlackBanner text:@"loading more..."];
		[_controller.tableView.superview addSubview:_loadingMoreView];
		_headerView.backgroundColor = RGBCOLOR(240,240,240);
		
		_headerView.frame = CGRectMake(0, -_controller.tableView.bounds.size.height - 11,
										  _controller.tableView.width,
										  _controller.tableView.bounds.size.height);
		
	}
	return self;
}

- (void)dealloc {
	[_loadingMoreView release];
	[super dealloc];
}

- (void)loadMore {
	 [_controller.model load:TTURLRequestCachePolicyNetwork more:YES];
	 [UIView beginAnimations:nil context:nil];
	 _loadingMoreView.frame = CGRectMake(0, _controller.tableView.superview.bounds.size.height-30, _controller.tableView.superview.width, 30);
	 [UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
	[super scrollViewDidScroll:scrollView];
	
	if ((scrollView.contentOffset.y + scrollView.bounds.size.height >= scrollView.contentSize.height) && 
		scrollView.contentSize.height > scrollView.bounds.size.height &&
		!_loading &&
		(BOOL)[(GTIOPaginatedTTModel*)_controller.model hasMoreToLoad]) {
		_loading = YES;
		[self performSelector:@selector(loadMore) withObject:nil afterDelay:0.0];
	}
}

- (void)hideLoadMore {
	_loading = NO;
	[UIView beginAnimations:nil context:nil];
	_loadingMoreView.frame = CGRectMake(0, _controller.tableView.superview.bounds.size.height+30, _controller.tableView.superview.width, 30);
	[UIView commitAnimations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)modelDidStartLoad:(id<TTModel>)model {
//	[_headerView showActivity:YES animated:YES];
//    
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:ttkDefaultFastTransitionDuration];
//	_controller.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 00.0f, 0.0f);
//	[UIView commitAnimations];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidFinishLoad:(id<TTModel>)model {
  	[self hideLoadMore];
    [super modelDidFinishLoad:model];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error {
	[self hideLoadMore];
    [super model:model didFailLoadWithError:error];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidCancelLoad:(id<TTModel>)model {
	[self hideLoadMore];
    [super modelDidCancelLoad:model];
}

@end
