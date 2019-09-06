//
//  MMDesignProperties.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMMargin.h"
#import "Utilities.h"
#import "MMGradient.h"
#import "MMBackground.h"
#import "MMDesignProperties.h"

static NSString *const kBackgroundColorKey = @"BackgroundColor";
static NSString *const kBackgroundGradientKey = @"BackgroundGradient";
static NSString *const kBackgroundImageKey = @"BackgroundImage";
static NSString *const kButtonNinePatchInsetsKey = @"ButtonNinePatchInsets";
static NSString *const kKeyboardMarginsKey = @"KeyboardEdgeMargins";
static NSString *const kAlternateShareButtonKey = @"AlternateShareButton";
static NSString *const kButtonBackgroundImageMarginsKey = @"ButtonBackgroundImageMargins";
static NSString *const kButtonLabelFontKey = @"ButtonLabelFont";
static NSString *const kButtonLabelMultiCharacterFontKey = @"ButtonLabelMultiCharacterFont";
static NSString *const kButtonLabelTextColorKey = @"ButtonLabelTextColor";
static NSString *const kButtonLabelMarginsKey = @"ButtonLabelMargins";
static NSString *const kButtonLabelAlignmentKey = @"ButtonLabelAlignment";
static NSString *const kiPhoneKey = @"iPhone";
static NSString *const kiPadKey = @"iPad";
static NSString *const kFontSizeKey = @"FontSize";
static NSString *const kFontNameKey = @"FontName";
static NSString *const kTextAlignmentCenterKey = @"center";
static NSString *const kTextAlignmentRightKey = @"right";
static NSString *const kTextAlignmentLeftKey = @"left";

@implementation MMDesignProperties

+ (MMDesignProperties *)designPropertiesFromFile:(NSURL *)url
{
    if (![self isReachableResourceFromURL:url]) return nil;
    
    MMDesignProperties *properties = [[MMDesignProperties alloc] init];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    
    properties.buttonNinePatchInsets = [MMDesignProperties edgeInsetsWithDictionary:dictionary[kButtonNinePatchInsetsKey]];
    properties.backgroundColor = [MMDesignProperties backgroundColorFromDictionary:dictionary[kBackgroundColorKey]];
    properties.backgroundGradient = [MMGradient gradientWithInformation:dictionary[kBackgroundGradientKey]];
    properties.backgroundImage = [MMBackground backgroundWithInformation:dictionary[kBackgroundImageKey]];
    properties.keyboardMargins = [MMMargin marginFromDictionary:dictionary[kKeyboardMarginsKey]];
    properties.buttonBackgroundImageMargins = [MMMargin marginFromDictionary:dictionary[kButtonBackgroundImageMarginsKey]];
    properties.buttonLabelFont = [MMDesignProperties fontWithDictionary:dictionary[kButtonLabelFontKey]];
    properties.buttonLabelMultiCharacterFont = [MMDesignProperties fontWithDictionary:dictionary[kButtonLabelMultiCharacterFontKey]];
    properties.buttonLabelTextColor = [MMDesignProperties colorFromDictionary:dictionary[kButtonLabelTextColorKey]];
    properties.ButtonLabelMargins = [MMDesignProperties edgeInsetsWithDictionary:dictionary[kButtonLabelMarginsKey]];
    properties.buttonLabelAlignment = [MMDesignProperties alignmentFromString:dictionary[kButtonLabelAlignmentKey]];
    properties.alternateShareButtonImageName = dictionary[kAlternateShareButtonKey];
    
    return properties;
}

+ (BOOL)isReachableResourceFromURL:(NSURL *)url
{
    NSError *error;
    [url checkResourceIsReachableAndReturnError:&error];
    
    if (error) return NO;
    
    return YES;
}

+ (UIColor *)backgroundColorFromDictionary:(NSDictionary *)dictionary
{
    if (dictionary) return [MMDesignProperties colorFromDictionary:dictionary];
    
    return [UIColor clearColor];
}

+ (UIColor *)colorFromDictionary:(NSDictionary *)dictionary
{
    NSNumber *red = dictionary[kMMGradientColorRedKey];
    NSNumber *green = dictionary[kMMGradientColorGreenKey];
    NSNumber *blue = dictionary[kMMGradientColorBlueKey];
    NSNumber *alpha = dictionary[kMMGradientColorAlphaKey];
    
    return [UIColor colorWithRed:red.floatValue / 255.0f green:green.floatValue / 255.0f  blue:blue.floatValue / 255.0f alpha:alpha.floatValue];
}

+ (UIEdgeInsets)edgeInsetsWithDictionary:(NSDictionary *)insetsDictionary
{
    CGFloat topInset = [insetsDictionary[kMMMarginTopEdgeKey] floatValue];
    CGFloat leftInset = [insetsDictionary[kMMMarginLeftEdgeKey] floatValue];
    CGFloat bottomInset = [insetsDictionary[kMMMarginBottomEdgeKey] floatValue];
    CGFloat rightInset = [insetsDictionary[kMMMarginRightEdgeKey] floatValue];
    
    return UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);
}

+ (UIFont *)fontWithDictionary:(NSDictionary *)dictionary
{
    CGFloat fontSize = isIPad() ? [dictionary[kFontSizeKey][kiPadKey] floatValue] : [dictionary[kFontSizeKey][kiPhoneKey] floatValue];
    
    return [UIFont fontWithName:[dictionary objectForKey:kFontNameKey] size:fontSize];
}

+ (NSTextAlignment)alignmentFromString:(NSString *)alignmentString
{
    if ([alignmentString isEqualToString:kTextAlignmentCenterKey]) return NSTextAlignmentCenter;
    if ([alignmentString isEqualToString:kTextAlignmentRightKey]) return NSTextAlignmentRight;
    
    return NSTextAlignmentLeft;
}

@end
