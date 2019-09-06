//
//  MMKeyInfo.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyInfo.h"

NSString *const kMMKeyInfoCharacterKey = @"Character";
NSString *const kMMKeyInfoDisplayCharacterKey = @"DisplayCharacter";
NSString *const kMMKeyInfoDisplayImageKey = @"DisplayImage";
NSString *const kMMKeyInfoDisplayImageHighlightedKey = @"DisplayImageHighlighted";
NSString *const kMMKeyInfoDisplayImageThirdStateKey = @"DisplayImageThirdState";
NSString *const kMMKeyInfoNumberCharacterKey = @"NumberCharacter";
NSString *const kMMKeyInfoAdditionalCharacterKey = @"AdditionalCharacter";
NSString *const kMMKeyInfoSpecialCharacterKey = @"SpecialCharacter";
NSString *const kMMKeyInfoDontEnlargeOnHighlightKey = @"DontEnlargeOnHighlight";

@implementation MMKeyInfo

+ (instancetype)keyInfoWithDictionary:(NSDictionary *)dictionary
{
    MMKeyInfo *keyInfo = [[MMKeyInfo alloc] init];
    
    if (dictionary)
    {
        keyInfo.character = dictionary[kMMKeyInfoCharacterKey];
        keyInfo.displayCharacter = dictionary[kMMKeyInfoDisplayCharacterKey];
        keyInfo.capitalizedCharacter = [dictionary[kMMKeyInfoCharacterKey] uppercaseString];
        
        if (!keyInfo.capitalizedCharacter)
        {
            keyInfo.capitalizedCharacter = keyInfo.character;
        }
        
        keyInfo.displayImage = dictionary[kMMKeyInfoDisplayImageKey];
        keyInfo.displayImageHighlighted = dictionary[kMMKeyInfoDisplayImageHighlightedKey];
        keyInfo.displayImageThirdState = dictionary[kMMKeyInfoDisplayImageThirdStateKey];
        keyInfo.numberCharacter = dictionary[kMMKeyInfoNumberCharacterKey];
        keyInfo.additionalCharacter = dictionary[kMMKeyInfoAdditionalCharacterKey];
        keyInfo.specialCharacter = dictionary[kMMKeyInfoSpecialCharacterKey];
        keyInfo.dontEnlargeOnHighlight = [dictionary[kMMKeyInfoDontEnlargeOnHighlightKey] boolValue];
        
        if (!keyInfo.displayCharacter)
        {
            keyInfo.displayCharacter = keyInfo.capitalizedCharacter;
        }
    }
    
    return keyInfo;
}

@end
