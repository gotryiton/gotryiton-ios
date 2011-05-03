//
//  UIDeviceHardware.h
//
//  Used to determine EXACT version of device software is running on.

#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject {
}

+ (UIDeviceHardware*)deviceHardware;

- (NSString *)platform;
- (NSString *)platformString;

// Convenience accessors
- (BOOL)isiPhone4;
- (BOOL)isiPhone3G;
- (BOOL)isiPhone3GS;

@end
