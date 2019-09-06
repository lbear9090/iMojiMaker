//
//  UIFont+OdinRounded.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "UIFont+OdinRounded.h"

@implementation UIFont (OdinRounded)

+ (UIFont *)odinRoundedBoldWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Odin-Bold" size:size];
}

+ (UIFont *)odinRoundedLightWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OdinRounded-Light" size:size];
}

+ (UIFont *)odinRoundedRegularWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OdinRounded" size:size];
}

+ (UIFont *)odinRoundedBoldItalicWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OdinRounded-BoldItalic" size:size];
}

+ (UIFont *)odinRoundedLightItalicWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OdinRounded-LightItalic" size:size];
}

+ (UIFont *)odinRoundedRegularItalicWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OdinRounded-RegularItalic" size:size];
}

@end
