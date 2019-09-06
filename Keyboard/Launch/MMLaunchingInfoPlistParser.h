//
//  MMLaunchingInfoPlistParser.h
//  Keyboard
//
//  Created by Lucky on 6/14/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMLaunchingInfoPlistParser : NSObject

+ (NSString *)storyboardName;
+ (NSString *)iMojiViewControllerClassName;
+ (NSString *)keyboardViewControllerClassName;

@end
