//
//  MMKeyboardSettings.h
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMKeyboardSettings : NSObject

@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) BOOL enableSounds;
@property (nonatomic, assign) BOOL enableAutoCapitalize;
@property (nonatomic, assign) BOOL enableAutosuggestion;
@property (nonatomic, assign) BOOL enableDoubleTapCapsLock;
@property (nonatomic, assign) BOOL enableDoubleSpacePunctuation;

+ (instancetype)instance;

- (void)loadSettings;
- (void)saveSettings;

@end
