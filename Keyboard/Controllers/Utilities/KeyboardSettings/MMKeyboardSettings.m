//
//  MMKeyboardSettings.m
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMSharedContainer.h"
#import "MMKeyboardSettings.h"

static NSString *const kMMKeyboardSettingsFileName = @"KeyboardSettings.plist";
static NSString *const kMMKeyboardSettingsDoubleSpacePunctuationKey = @"DoubleSpacePunctuation";
static NSString *const kMMKeyboardSettingsDoubleTapCapsLockKey = @"DoubleTapCapsLock";
static NSString *const kMMKeyboardSettingsAutosuggestionKey = @"Autosuggestion";
static NSString *const kMMKeyboardSettingsAutoCapitalizeKey = @"AutoCapitalize";
static NSString *const kMMKeyboardSettingsSoundsKey = @"Sounds";
static NSString *const kMMKeyboardSettingsVersionKey = @"Version";

@implementation MMKeyboardSettings

+ (instancetype)instance
{
    static dispatch_once_t predicate;
    static MMKeyboardSettings *instance = nil;
    dispatch_once(&predicate, ^
    {
        instance = [[self alloc] init];
        [instance loadSettings];
    });
    
    return instance;
}

- (void)loadSettings
{
    NSDictionary *settingsDictionary = [MMSharedContainer dictionaryWithFileName:kMMKeyboardSettingsFileName];
    
    if (settingsDictionary)
    {
        self.enableDoubleSpacePunctuation = [settingsDictionary[kMMKeyboardSettingsDoubleSpacePunctuationKey] boolValue];
        self.enableDoubleTapCapsLock = [settingsDictionary[kMMKeyboardSettingsDoubleTapCapsLockKey] boolValue];
        self.enableAutosuggestion = [settingsDictionary[kMMKeyboardSettingsAutosuggestionKey] boolValue];
        self.enableAutoCapitalize = [settingsDictionary[kMMKeyboardSettingsAutoCapitalizeKey] boolValue];
        self.enableSounds = [settingsDictionary[kMMKeyboardSettingsSoundsKey] boolValue];
        self.version = settingsDictionary[kMMKeyboardSettingsVersionKey];
    }
    else
    {
        self.enableDoubleSpacePunctuation = YES;
        self.enableDoubleTapCapsLock = YES;
        self.enableAutosuggestion = YES;
        self.enableAutoCapitalize = YES;
        self.enableSounds = YES;
        self.version = @"";
        
        [self saveSettings];
    }
}

- (void)saveSettings
{
    NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionary];
    settingsDictionary[kMMKeyboardSettingsDoubleSpacePunctuationKey] = @(self.enableDoubleSpacePunctuation);
    settingsDictionary[kMMKeyboardSettingsDoubleTapCapsLockKey] = @(self.enableDoubleTapCapsLock);
    settingsDictionary[kMMKeyboardSettingsAutosuggestionKey] = @(self.enableAutosuggestion);
    settingsDictionary[kMMKeyboardSettingsAutoCapitalizeKey] = @(self.enableAutoCapitalize);
    settingsDictionary[kMMKeyboardSettingsSoundsKey] = @(self.enableSounds);
    settingsDictionary[kMMKeyboardSettingsVersionKey] = self.version;
    
    [MMSharedContainer writeDictionary:settingsDictionary fileName:kMMKeyboardSettingsFileName];
}

@end
