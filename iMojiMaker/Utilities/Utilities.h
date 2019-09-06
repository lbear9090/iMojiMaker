//
//  Utilities.h
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL isIPad(void);
BOOL isIPhone(void);
BOOL isSimulator(void);
BOOL isWiFiReachable(void);
BOOL isInternetReachable(void);
BOOL isDevicePortrait(UIDeviceOrientation orientation);
BOOL isInterfacePortrait(UIInterfaceOrientation orientation);
NSString *applicationName(void);
NSString *applicationVersion(void);

@interface Utilities : NSObject

@end
