//
//  MMGradient.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMGradient.h"

static NSString *const kMMGradientColorKey = @"Colors";

NSString *const kMMGradientColorRedKey = @"R";
NSString *const kMMGradientColorGreenKey = @"G";
NSString *const kMMGradientColorBlueKey = @"B";
NSString *const kMMGradientColorAlphaKey = @"A";

@implementation MMGradient

+ (MMGradient *)gradientWithInformation:(NSDictionary *)informationDictionary
{
    if (!informationDictionary) return nil;
    
    MMGradient *gradient = [[MMGradient alloc] init];
    
    NSArray *colorInformation = informationDictionary[kMMGradientColorKey];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:colorInformation.count];
    
    for (NSDictionary *information in colorInformation)
    {
        UIColor *color = [self colorFromDictionary:information];
        [colors addObject:color];
    }
    
    gradient.colors = [NSArray arrayWithArray:colors];
    [gradient setGradientStyle:kMMGradientStyleCustomKeyboardBackground];
    
    return gradient;
}

+ (UIColor *)colorFromDictionary:(NSDictionary *)dictionary
{
    NSNumber *red = dictionary[kMMGradientColorRedKey];
    NSNumber *green = dictionary[kMMGradientColorGreenKey];
    NSNumber *blue = dictionary[kMMGradientColorBlueKey];
    NSNumber *alpha = dictionary[kMMGradientColorAlphaKey];
    
    return [UIColor colorWithRed:red.floatValue / 255.0f green:green.floatValue / 255.0f  blue:blue.floatValue / 255.0f alpha:alpha.floatValue];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setGradientStyle:kMMGradientStyleVertical];
    }
    
    return self;
}

- (void)setGradientStyle:(kMMGradientStyle)style
{
    switch (style)
    {
        case kMMGradientStyleHorizontal:
        {
            self.startPoint = CGPointMake(0.0f, 0.0f);
            self.endPoint = CGPointMake(1.0f, 0.0f);
            break;
        }
        case kMMGradientStyleCustomKeyboardBackground:
        {
            self.startPoint = CGPointMake(0.4f, 0.0f);
            self.endPoint = CGPointMake(0.6f, 1.0f);
            break;
        }
        default:
        {
            self.startPoint = CGPointMake(0.0f, 0.0f);
            self.endPoint = CGPointMake(0.0f, 1.0f);
            break;
        }
    }
}

@end
