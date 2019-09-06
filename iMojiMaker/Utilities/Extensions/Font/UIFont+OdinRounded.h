//
//  UIFont+OdinRounded.h
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (OdinRounded)

+ (UIFont *)odinRoundedBoldWithSize:(CGFloat)size;
+ (UIFont *)odinRoundedLightWithSize:(CGFloat)size;
+ (UIFont *)odinRoundedRegularWithSize:(CGFloat)size;

+ (UIFont *)odinRoundedBoldItalicWithSize:(CGFloat)size;
+ (UIFont *)odinRoundedLightItalicWithSize:(CGFloat)size;
+ (UIFont *)odinRoundedRegularItalicWithSize:(CGFloat)size;

@end
