//
//  GTIODraggableImageView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/25/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTIODraggableImageViewDelegate;

@interface GTIODraggableImageView : UIImageView {
	CGPoint _oldPoint;
	CGRect _constrainingRect;
	CGFloat _oldDistance;
	
	int _counter;
	
	NSObject<GTIODraggableImageViewDelegate>* _delegate;
	
	NSMutableArray* _touches;
}

@property (nonatomic, assign) NSObject<GTIODraggableImageViewDelegate>* delegate;
@property (nonatomic, assign) CGRect constrainingRect;

@end

@protocol GTIODraggableImageViewDelegate
@optional

/**
 * Allows the delegate to provide the draggable image view
 * with a new image to show after a drag has completed. 
 */
// TODO: Pass the rect in?
- (UIImage*)imageForDraggableImageView:(GTIODraggableImageView*)draggableImageView;

// TODO: New flavor with the rect??
@end
