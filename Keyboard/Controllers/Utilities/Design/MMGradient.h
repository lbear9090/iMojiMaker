//
//  MMGradient.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kMMGradientColorRedKey;
extern NSString *const kMMGradientColorGreenKey;
extern NSString *const kMMGradientColorBlueKey;
extern NSString *const kMMGradientColorAlphaKey;

typedef NS_ENUM(NSInteger, kMMGradientStyle)
{
    kMMGradientStyleVertical                  = 0,
    kMMGradientStyleHorizontal                = 1,
    kMMGradientStyleCustomKeyboardBackground  = 2
};

@interface MMGradient : NSObject
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

+ (MMGradient *)gradientWithInformation:(NSDictionary *)informationDictionary;

- (void)setGradientStyle:(kMMGradientStyle)style;

@end
