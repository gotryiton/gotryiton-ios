//
//  SupersequentImplementation.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/1/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <objc/runtime.h>
#import <objc/objc.h>

#define invokeSupersequentNoParameters() \
([self getImplementationOf:_cmd \
after:impOfCallingMethod(self, _cmd)]) \
(self, _cmd)

#define invokeSupersequent(...) \
([self getImplementationOf:_cmd \
after:impOfCallingMethod(self, _cmd)]) \
(self, _cmd, ##__VA_ARGS__)

IMP impOfCallingMethod(id lookupObject, SEL selector);

@interface NSObject (SupersequentImplementation)

- (IMP)getImplementationOf:(SEL)lookup after:(IMP)skip;

@end

