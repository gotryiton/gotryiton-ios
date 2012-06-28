//
//  GTIOWhoHeartedThisView.h
//  GTIO
//
//  Created by Scott Penrose on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "DTCoreText.h"

@interface GTIOWhoHeartedThisView : UIView <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) NSString *whoHeartedThis;

+ (CGFloat)heightWithWhoHeartedThis:(NSString *)whoHeartedThis;

@end
