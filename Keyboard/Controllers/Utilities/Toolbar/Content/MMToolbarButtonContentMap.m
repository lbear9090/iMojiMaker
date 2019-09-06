//
//  MMToolbarButtonContentMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbarButtonContentMap.h"

NSString *const kMMToolbarSpaceButtonTitle = @"space";
NSString *const kMMToolbarReturnButtonTitle = @"return";
NSString *const kMMToolbarChangeContentButtonTitle = @"ABC";

NSString *const kMMToolbarSpaceButtonKey = @"space";
NSString *const kMMToolbarReturnButtonKey = @"return";
NSString *const kMMToolbarBackspaceButtonKey = @"delete";
NSString *const kMMToolbarNextKeyboardButtonKey = @"next";

static NSString *const kMMKeyboardLayoutFileExtension = @"plist";
static NSString *const kMMKeyboardDefaultLayoutFileName = @"MMDefaultLayout";

@implementation MMToolbarButtonContentSet

+ (instancetype)buttonContentSetWithButtonText:(NSString *)text fontSize:(CGFloat)fontSize
{
    MMToolbarButtonContentSet *contentSet = [[MMToolbarButtonContentSet alloc] init];
    [contentSet setContainsText:YES];
    [contentSet setButtonText:text];
    [contentSet setButtonFontSize:fontSize];
    
    return contentSet;
}

+ (instancetype)buttonContentSetWithDictionaryKey:(NSString *)dictionaryKey isSpecial:(BOOL)isSpecial
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *layoutFilePath = [bundle pathForResource:kMMKeyboardDefaultLayoutFileName ofType:kMMKeyboardLayoutFileExtension];
    NSDictionary *layoutDictionary = [NSDictionary dictionaryWithContentsOfFile:layoutFilePath];
    
    MMToolbarButtonContentSet *contentSet = [[MMToolbarButtonContentSet alloc] init];
    MMKeyInfo *keyInfo = [MMKeyInfo keyInfoWithDictionary:layoutDictionary[dictionaryKey]];
    [keyInfo setIsSpecialKey:isSpecial];
    [contentSet setKeyInfo:keyInfo];
    
    return contentSet;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _buttonFontSize = 12.0;
        _containsText = NO;
        _buttonText = @"";
    }
    
    return self;
}

@end

@implementation MMToolbarButtonContentMap

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _changeContentButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarChangeContentButtonTitle fontSize:14];
        _nextKeyboardButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithDictionaryKey:kMMToolbarNextKeyboardButtonKey isSpecial:YES];
        _backspaceButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithDictionaryKey:kMMToolbarBackspaceButtonKey isSpecial:YES];
    }
    
    return self;
}

@end
