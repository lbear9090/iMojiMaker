//
//  MMMargin.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMMargin.h"
#import "Utilities.h"

static NSString *const kMMMarginPortraitKey = @"Portrait";
static NSString *const kMMMarginLandscapeKey = @"Landscape";
static NSString *const kMMMarginPortraitIPadKey = @"Portrait-iPad";
static NSString *const kMMMarginLandscapeIPadKey = @"Landscape-iPad";

NSString *const kMMMarginTopEdgeKey = @"top";
NSString *const kMMMarginLeftEdgeKey = @"left";
NSString *const kMMMarginBottomEdgeKey = @"bottom";
NSString *const kMMMarginRightEdgeKey = @"right";

@interface MMMargin ()
@property (nonatomic, assign) UIEdgeInsets portraitIPhone;
@property (nonatomic, assign) UIEdgeInsets portraitIPad;
@property (nonatomic, assign) UIEdgeInsets landscapeIPhone;
@property (nonatomic, assign) UIEdgeInsets landscapeIPad;
@end

@implementation MMMargin

+ (MMMargin *)marginFromDictionary:(NSDictionary *)marginInformation
{
    return [[MMMargin alloc] initWithDictionary:marginInformation];
}

- (MMMargin *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.portraitIPhone = [self edgeInsetsWithDictionary:dictionary fromKey:kMMMarginPortraitKey];
        self.landscapeIPhone = [self edgeInsetsWithDictionary:dictionary fromKey:kMMMarginLandscapeKey];
        self.portraitIPad = [self edgeInsetsWithDictionary:dictionary fromKey:kMMMarginPortraitIPadKey];
        self.landscapeIPad = [self edgeInsetsWithDictionary:dictionary fromKey:kMMMarginLandscapeIPadKey];
    }
    
    return self;
}

- (UIEdgeInsets)portrait
{
    return isIPad() ? self.portraitIPad : self.portraitIPhone;
}

- (UIEdgeInsets)landscape
{
    return isIPad() ? self.landscapeIPad : self.landscapeIPhone;
}

- (UIEdgeInsets)current
{
    UIDevice *device = [UIDevice currentDevice];
    
    return isDevicePortrait(device.orientation) ? self.portrait : self.landscape;
}

- (UIEdgeInsets)edgeInsetsWithDictionary:(NSDictionary *)dictionary fromKey:(NSString *)dictionaryKey
{
    NSDictionary *insetsDictionary = dictionary[dictionaryKey];
    CGFloat topInset = [insetsDictionary[kMMMarginTopEdgeKey] floatValue];
    CGFloat leftInset = [insetsDictionary[kMMMarginLeftEdgeKey] floatValue];
    CGFloat bottomInset = [insetsDictionary[kMMMarginBottomEdgeKey] floatValue];
    CGFloat rightInset = [insetsDictionary[kMMMarginRightEdgeKey] floatValue];
    
    return UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);
}

@end
