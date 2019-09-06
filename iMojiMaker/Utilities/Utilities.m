//
//  Utilities.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Utilities.h"
#import "Reachability.h"

BOOL isIPad(void)
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

BOOL isIPhone(void)
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

BOOL isSimulator(void)
{
#if TARGET_IPHONE_SIMULATOR
    return YES;
#endif
    return NO;
}

BOOL isWiFiReachable(void)
{
    return (ReachableViaWiFi == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]);
}

BOOL isInternetReachable(void)
{
    return (NotReachable != [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]);
}

BOOL isDevicePortrait(UIDeviceOrientation orientation)
{
    return UIDeviceOrientationIsPortrait(orientation);
}

BOOL isInterfacePortrait(UIInterfaceOrientation orientation)
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

NSString *applicationName(void)
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

NSString *applicationVersion(void)
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@implementation Utilities

@end
