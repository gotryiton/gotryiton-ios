//
//  CustomUISwitch.h
//
//  Created by Duane Homick
//  Homick Enterprises - www.homick.com
//
/// The CustomUISwitch can be used the same way a UISwitch can, but using the PSD attached, you can create your own color scheme.
/// Imported from www.homick.com

#import <UIKit/UIKit.h>

@protocol CustomUISwitchDelegate;

@interface CustomUISwitch : UIControl 
{
	id<CustomUISwitchDelegate> _delegate;
	BOOL _on;

	NSInteger _hitCount;
	UIImageView* _backgroundImage;
	UIImageView* _switchImage;
}
/// Delegate that conforms to the <[CustomUISwitchDelegate](CustomUISwitchDelegate)> protocol
@property (nonatomic, assign, readwrite) id delegate;
/// Current Value of Switch
@property (nonatomic, getter=isOn) BOOL on;

/** Init with a GGRect Frame
* Note: This class enforces a size appropriate for the control. The frame size is ignored.
*/
- (id)initWithFrame:(CGRect)frame;

- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action

@end
/// Delegate for [CustomUISwitch](CustomUISwitch) controls
@protocol CustomUISwitchDelegate

@optional
/// Sent when the [CustomUISwitch](CustomUISwitch) value changes
- (void)valueChangedInView:(CustomUISwitch*)view;

@end

