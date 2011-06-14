//
//  GTIOFeaturedViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 6/14/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOFeaturedScrollView : UIScrollView {
    NSArray* _sections;
    NSArray* _sectionViews;
}

@property (nonatomic, retain) NSArray* sections;

@end

@interface GTIOFeaturedViewController : TTModelViewController {
    GTIOFeaturedScrollView* _scrollView;
}

@end
