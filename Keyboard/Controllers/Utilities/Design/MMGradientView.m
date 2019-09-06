//
//  MMGradientView.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMGradient.h"
#import "MMGradientView.h"

@interface MMGradientView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation MMGradientView

+ (MMGradientView *)gradientViewWithGradient:(MMGradient *)gradient
{
    MMGradientView *view = [[MMGradientView alloc] init];
    [view createGradientLayerWithGradient:gradient];
    
    return view;
}

- (void)layoutSubviews
{
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.gradientLayer.bounds = self.bounds;
    [CATransaction commit];
}

- (void)createGradientLayerWithGradient:(MMGradient *)gradient
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = gradient.startPoint;
    gradientLayer.endPoint = gradient.endPoint;
    NSNumber *gradTopStart = [NSNumber numberWithFloat:0.0f];
    NSNumber *gradTopEnd = [NSNumber numberWithFloat:1.0f];
    gradientLayer.locations = @[gradTopStart, gradTopEnd];
    gradientLayer.bounds = self.bounds;
    gradientLayer.anchorPoint = CGPointZero;
    
    [self.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
    
    UIColor *startColor = gradient.colors[0];
    UIColor *endColor = gradient.colors[1];
    self.gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
}

@end
