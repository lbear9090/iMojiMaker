//
//  MMAudioManager.m
//  Keyboard
//
//  Created by Lucky on 6/6/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMAudioManager.h"
#import "MMSharedContainer.h"
#import "MMKeyboardSettings.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation MMAudioManager

+ (void)playClickSound
{
    if (![MMSharedContainer isAllowedAccessToSharedContainer]) return;
    
    MMKeyboardSettings *keyboardSettings = [MMKeyboardSettings instance];
    
    if (!keyboardSettings.enableSounds) return;
    
    AudioServicesPlaySystemSound(0x450);
}

@end
