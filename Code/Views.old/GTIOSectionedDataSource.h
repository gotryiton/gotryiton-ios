//
//  GTIOSectionedDataSource.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/7/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOSectionedDataSource is a TTSectionedDataSource that links the [GTIOTableImageControlItem](GTIOTableImageControlItem) to the [GTIOTableImageControlCell](GTIOTableImageControlCell)

#import <Three20/Three20.h>
#import "GTIOStylistsQuickLook.h"

@interface GTIOSectionedDataSource : TTSectionedDataSource {

}

@end

@interface GTIOPersonalStylistsItem : TTTableItem {
    GTIOStylistsQuickLook* _stylistsQuickLook;
}

@property (nonatomic, retain) GTIOStylistsQuickLook* stylistsQuickLook;

@end