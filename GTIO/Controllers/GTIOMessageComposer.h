//
//  GTIOMessageComposer.h
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <MessageUI/MessageUI.h>

typedef void(^GTIOMessageComposerDidFinish)(MFMessageComposeViewController *controller, MessageComposeResult result);

@interface GTIOMessageComposer : MFMessageComposeViewController

@property (nonatomic, copy) GTIOMessageComposerDidFinish didFinishHandler;

@end
