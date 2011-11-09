//
//  GTIOPaginationTableViewDelegate.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOPaginationTableViewDelegate.h"
#import <Three20UI/TTTableHeaderDragRefreshView.h>
#import "GTIOPaginatedTTModel.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOOutfitViewController.h"
#import "GTIOBrowseList.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOTodosTableViewController.h"

//#define kTableViewEdgeInsets UIEdgeInsetsMake(8, 0, 0, 0)
#define kTableViewEdgeInsets UIEdgeInsetsMake(0, 0, 0, 0);

@interface TTTableViewDragRefreshDelegate (TTModelDelegate)
- (void)modelDidFinishLoad:(id<TTModel>)model;
- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error;
- (void)modelDidCancelLoad:(id<TTModel>)model;
@end

@interface TTTableHeaderDragRefreshView (private)

- (void)setImageFlipped:(BOOL)flipped;
- (void)showActivity:(BOOL)activity animated:(BOOL)animated;

@end

@interface TTTableHeaderDragRefreshView (Overrides)
- (UIImageView*)bgImageView;
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

- (id)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
        [self removeAllSubviews];
        
		UIImageView* bg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[self backgroundImageName]]] autorelease];
        bg.tag = 99293;
		bg.frame = self.bounds;
		bg.contentMode = UIViewContentModeBottom;
		[self addSubview:bg];
		self.backgroundColor = RGBCOLOR(240,240,240);
		
		_statusLabel = [[UILabel alloc]
						initWithFrame:CGRectMake(0.0f, frame.size.height - 25.0f,
												 frame.size.width, 20.0f )];
		_statusLabel.autoresizingMask =
		UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		_statusLabel.font             = TTSTYLEVAR(tableRefreshHeaderStatusFont);
		_statusLabel.textColor        = [UIColor darkGrayColor];
		_statusLabel.shadowColor      = TTSTYLEVAR(tableRefreshHeaderTextShadowColor);
		_statusLabel.shadowOffset     = TTSTYLEVAR(tableRefreshHeaderTextShadowOffset);
		_statusLabel.backgroundColor  = [UIColor clearColor];
		_statusLabel.textAlignment    = UITextAlignmentCenter;
		[self setStatus:TTTableHeaderDragRefreshPullToReload];
		[self addSubview:_statusLabel];
		
		_arrowImage = [[UIImageView alloc]
					   initWithFrame:CGRectMake(149.0f, frame.size.height - 65.0f + 3,
												23.0f, 41.0f)];
		_arrowImage.contentMode       = UIViewContentModeScaleAspectFit;
		_arrowImage.image             = [UIImage imageNamed:[self arrowImageName]];
		[_arrowImage layer].transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
		[self addSubview:_arrowImage];
		
		_activityView = [[UIActivityIndicatorView alloc]
						 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake( 115.0f, frame.size.height - 22.0f, 16.0f, 16.0f );
		_activityView.hidesWhenStopped  = YES;
		[self addSubview:_activityView];
		
        // TODO: this no longer exists and may mess up our drag refresh awesomeness?
		// _isFlipped = NO;
	}
	return self;
}

- (void)setStatus:(TTTableHeaderDragRefreshStatus)status {
    [_activityView stopAnimating];
	switch (status) {
		case TTTableHeaderDragRefreshReleaseToReload: {
			_statusLabel.text = @"release to update...";
            [self setImageFlipped:YES];
			break;
		}
			
		case TTTableHeaderDragRefreshPullToReload: {
			_statusLabel.text = @"pull down to update...";
            [self setImageFlipped:NO];
			break;
		}
			
		case TTTableHeaderDragRefreshLoading: {
            [_activityView startAnimating];
			_statusLabel.text = @"      updating...";
            [self setImageFlipped:YES];
			break;
		}
			
		default: {
			break;
		}
	}
}

@end


@implementation GTIOPaginationTableViewDelegate

- (id)initWithController:(TTTableViewController*)controller {
	if (self = [super initWithController:controller]) {
		// Add our refresh header
		CGRect frame = CGRectMake(0, _controller.tableView.superview.bounds.size.height+30, _controller.tableView.superview.width, 30);
		_loadingMoreView = [[TTActivityLabel alloc] initWithFrame:frame style:TTActivityLabelStyleBlackBanner text:@"loading more..."];
		[_controller.tableView.superview addSubview:_loadingMoreView];
		_headerView.backgroundColor = RGBCOLOR(240,240,240);
		
		_headerView.frame = CGRectMake(0, -_controller.tableView.bounds.size.height,
										  _controller.tableView.width,
										  _controller.tableView.bounds.size.height);
		
	}
	return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(nil != [self tableView:tableView viewForHeaderInSection:section]) {
        return 20;
    } else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return nil;
    }
    NSString* sectionTitle = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0,5,320,20)] autorelease];
    view.backgroundColor = RGBCOLOR(227,227,227);
    UIView* separator = [[[UIView alloc] initWithFrame:CGRectMake(0,19,320,1)] autorelease];
    separator.backgroundColor = RGBCOLOR(165,165,165);
    [view addSubview:separator];
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(15,5,300,12)] autorelease];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    if ([tableView.dataSource sectionIndexTitlesForTableView:tableView]) {
        label.textColor = RGBCOLOR(95,95,95);
    } else {
        label.textColor = RGBCOLOR(169,169,169);
    }
    label.text = sectionTitle;
    [view addSubview:label];
    return view;
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
	
    float totalheight = scrollView.contentOffset.y + scrollView.bounds.size.height;
    float height = scrollView.contentSize.height;
    GTIOPaginatedTTModel* model = (GTIOPaginatedTTModel*)_controller.model;
    BOOL hasMoreToLoad = (BOOL)[model hasMoreToLoad];
	if ((totalheight >= height && height > 0) && 
		!_loading &&
		hasMoreToLoad) {
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

- (void)setupContentInset {
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)_controller.model;
    if ([model isKindOfClass:[GTIOBrowseListTTModel class]]) {
        GTIOBrowseList* list = model.list;
    
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:ttkDefaultFastTransitionDuration];
        
        if (list.categories || list.sections) {
            _controller.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        } else {
            _controller.tableView.contentInset = UIEdgeInsetsMake(4,0,4,0);
            _headerView.frame = CGRectOffset(_headerView.frame, 0, -4);
//            [UIView commitAnimations];
//            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:ttkDefaultFastTransitionDuration];
            if (CGPointEqualToPoint(_controller.tableView.contentOffset, CGPointZero)) {
                _controller.tableView.contentOffset = CGPointMake(0,-4);
            }
        }
        
//        [UIView commitAnimations];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidFinishLoad:(id<TTModel>)model {
  	[self hideLoadMore];
    [_headerView setStatus:TTTableHeaderDragRefreshPullToReload];
    [self setupContentInset];
    
    if ([model respondsToSelector:@selector(loadedTime)]) {
        NSDate* date = [model performSelector:@selector(loadedTime)];
        [_headerView setUpdateDate:date];
        
    } else {
        [_headerView setCurrentDate];
    }
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error {
	[self hideLoadMore];
    [_headerView setStatus:TTTableHeaderDragRefreshPullToReload];
    [self setupContentInset];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidCancelLoad:(id<TTModel>)model {
	[self hideLoadMore];
    [_headerView setStatus:TTTableHeaderDragRefreshPullToReload];
    [self setupContentInset];
}

@end
