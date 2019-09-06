//
//  MMKeyboardState.m
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyboardState.h"

static NSString *const kMMKeyboardStateKey = @"KeyboardState";
static NSString *const kMMKeyboardStateDesignNameKey = @"DesignName";
static NSString *const kMMKeyboardStateDesignScrollPositionKey = @"DesignScrollPosition";
static NSString *const kMMKeyboardStateFontScrollPositionKey = @"FontScrollPosition";
static NSString *const kMMKeyboardStateDidShowLimitedAccessNotificationKey = @"DidShowLimitedAccessNotification";
static NSString *const kMMKeyboardStateDidShowOpenAppNotificationKey = @"DidShowOpenAppNotification";
static NSString *const kMMKeyboardStateSelectedFontIndexKey = @"SelectedFontIndex";

@implementation MMKeyboardState

+ (instancetype)instance
{
    static dispatch_once_t predicate;
    static MMKeyboardState *instance = nil;
    dispatch_once(&predicate, ^
    {
        instance = [[self alloc] init];
        [instance loadState];
    });
    
    return instance;
}

- (void)loadState
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *settingsDictionary = [userDefaults objectForKey:kMMKeyboardStateKey];
    
    self.selectedFontIndex = -1;
    
    if (settingsDictionary)
    {
        self.designName = settingsDictionary[kMMKeyboardStateDesignNameKey];
        self.designScrollPosition = [settingsDictionary[kMMKeyboardStateDesignScrollPositionKey] floatValue];
        self.fontsScrollPosition = [settingsDictionary[kMMKeyboardStateFontScrollPositionKey] floatValue];
        self.didShowLimitedAccessNotification = [settingsDictionary[kMMKeyboardStateDidShowLimitedAccessNotificationKey] boolValue];
        self.didShowOpenAppNotification = [settingsDictionary[kMMKeyboardStateDidShowOpenAppNotificationKey] boolValue];
        
        NSNumber *selectedIndex = settingsDictionary[kMMKeyboardStateSelectedFontIndexKey];
        if (selectedIndex)
        {
            self.selectedFontIndex = [settingsDictionary[kMMKeyboardStateSelectedFontIndexKey] integerValue];
        }
    }
    else
    {
        [self saveState];
    }
}

- (void)saveState
{
    NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionary];
    
    if (self.designName)
    {
        settingsDictionary[kMMKeyboardStateDesignNameKey] = self.designName;
    }
    
    settingsDictionary[kMMKeyboardStateDesignScrollPositionKey] = @(self.designScrollPosition);
    settingsDictionary[kMMKeyboardStateFontScrollPositionKey] = @(self.fontsScrollPosition);
    settingsDictionary[kMMKeyboardStateDidShowLimitedAccessNotificationKey] = @(self.didShowLimitedAccessNotification);
    settingsDictionary[kMMKeyboardStateDidShowOpenAppNotificationKey] = @(self.didShowOpenAppNotification);
    settingsDictionary[kMMKeyboardStateSelectedFontIndexKey] = @(self.selectedFontIndex);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:settingsDictionary forKey:kMMKeyboardStateKey];
}

@end
