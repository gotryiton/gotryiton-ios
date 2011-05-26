//
//  main.m
//  GTIO
//
//  Created by Blake Watters on 4/11/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef FRANK
#include "FrankServer.h"
static FrankServer *sFrankServer;
#endif

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
#ifdef FRANK
    sFrankServer = [[FrankServer alloc] initWithDefaultBundle];
    [sFrankServer startServer];
#endif
    
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
