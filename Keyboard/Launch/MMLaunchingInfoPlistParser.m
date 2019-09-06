//
//  MMLaunchingInfoPlistParser.m
//  Keyboard
//
//  Created by Lucky on 6/14/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMLaunchingInfoPlistParser.h"

static NSString *const kKeyboardLaunchingInfoPlistName = @"MMKeyboardLaunchingInfo";
static NSString *const kKeyboardLaunchingInfoPlistExtension = @"plist";

static NSString *const kStoryboardNameKey = @"Storyboard name";
static NSString *const kMMiMojiViewControllerClassNameKey = @"iMoji view controller class name";
static NSString *const kMMKeyboardViewControllerClassNameKey = @"Keyboard view controller class name";

@implementation MMLaunchingInfoPlistParser

+ (NSString *)storyboardName
{
    return [self stringForKey:kStoryboardNameKey];
}

+ (NSString *)iMojiViewControllerClassName
{
    return [self stringForKey:kMMiMojiViewControllerClassNameKey];
}

+ (NSString *)keyboardViewControllerClassName
{
    return [self stringForKey:kMMKeyboardViewControllerClassNameKey];
}

+ (NSString *)stringForKey:(NSString *)key
{
    NSDictionary *launchingInfo = [self launchingInfoDictionary];
    if (![[launchingInfo allKeys] containsObject:key])
    {
        [self raiseNoValidObjectExceptionForKey:key];
    }
    
    return [launchingInfo objectForKey:key];
}

+ (NSDictionary *)launchingInfoDictionary
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:kKeyboardLaunchingInfoPlistName ofType:kKeyboardLaunchingInfoPlistExtension];
    
    if (!plistPath) return nil;
    
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (void)raiseNoValidObjectExceptionForKey:(NSString *)key
{
    NSString *exceptionName = @"No valid value for key";
    NSString *reasonString = [NSString stringWithFormat:@"Could not load the value for %@ key from keyboard launching info plist", key];
    NSDictionary *userInfo = @{@"Exception name: " : exceptionName,
                               @"Exception reason: " : reasonString};
    
    NSException *exception = [[NSException alloc] initWithName:exceptionName reason:reasonString userInfo:userInfo];
    [exception raise];
}

@end
