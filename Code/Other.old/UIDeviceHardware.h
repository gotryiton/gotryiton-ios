//
//  UIDeviceHardware.h
//
//  Used to determine EXACT version of device software is running on.
/// UIDeviceHardware is used to determine the amount to scale an image from the camera based on the iphone device type
#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject {
}
/// Returns a UIDeviceHardware instance
+ (UIDeviceHardware*)deviceHardware;
/// Returns system string representing of the platform
- (NSString *)platform;
/// Returns human readable string of the platform
- (NSString *)platformString;

// Convenience accessors
/// True if iPhone 4
- (BOOL)isiPhone4;
/// True if iPhone 3G
- (BOOL)isiPhone3G;
/// True if iPhone 3Gs
- (BOOL)isiPhone3GS;

@end
