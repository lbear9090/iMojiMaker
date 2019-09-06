//
//  MMToolbarButtonContentMap.h
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyInfo.h"
#import <UIKit/UIKit.h>

extern NSString *const kMMToolbarSpaceButtonTitle;
extern NSString *const kMMToolbarReturnButtonTitle;
extern NSString *const kMMToolbarChangeContentButtonTitle;

extern NSString *const kMMToolbarSpaceButtonKey;
extern NSString *const kMMToolbarReturnButtonKey;
extern NSString *const kMMToolbarBackspaceButtonKey;
extern NSString *const kMMToolbarNextKeyboardButtonKey;

@interface MMToolbarButtonContentSet : NSObject
@property (nonatomic, strong) MMKeyInfo *keyInfo;
@property (nonatomic, strong) NSString *buttonText;
@property (nonatomic, assign) BOOL containsText;
@property (nonatomic, assign) CGFloat buttonFontSize;

+ (instancetype)buttonContentSetWithButtonText:(NSString *)text fontSize:(CGFloat)fontSize;
+ (instancetype)buttonContentSetWithDictionaryKey:(NSString *)dictionaryKey isSpecial:(BOOL)isSpecial;

@end

@interface MMToolbarButtonContentMap : NSObject

@property (nonatomic, strong) MMToolbarButtonContentSet *spaceButtonContentSet;
@property (nonatomic, strong) MMToolbarButtonContentSet *returnButtonContentSet;
@property (nonatomic, strong) MMToolbarButtonContentSet *backspaceButtonContentSet;
@property (nonatomic, strong) MMToolbarButtonContentSet *nextKeyboardButtonContentSet;
@property (nonatomic, strong) MMToolbarButtonContentSet *changeContentButtonContentSet;

@end
