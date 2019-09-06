//
//  ShopBuyBorderedView.m
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ShopBuyBorderedView.h"

@implementation ShopBuyBorderedView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil)
    {
        [self initDefaults];
        [self updateBorder];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self initDefaults];
        [self updateBorder];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        [self initDefaults];
        [self updateBorder];
    }
    
    return self;
}

- (void)initDefaults
{
    _cornerRadius = 4;
    _borderWidth = 1;
    _borderColor = [UIColor blueColor];
}

- (void)updateBorder
{
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.cornerRadius = self.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self updateBorder];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateBorder];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateBorder];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key
{
    if([key isEqualToString:@"borderColor"] || [key isEqualToString:@"cornerRadius"] || [key isEqualToString:@"borderWidth"])
    {
        // piggy back on the animation for opacity, which only will be non nil if we are in an animation block.
        // This way, we will only animate those properties when in an animation block.
        CABasicAnimation *animation = (CABasicAnimation *)[layer actionForKey:@"opacity"];
        if ([animation isKindOfClass:[CABasicAnimation class]])
        {
            animation.keyPath = key;
            animation.fromValue = [layer valueForKey:key];
            animation.toValue = nil;
            animation.byValue = nil;
            
            return animation;
        }
    }
    
    return [super actionForLayer:layer forKey:key];
}

@end
