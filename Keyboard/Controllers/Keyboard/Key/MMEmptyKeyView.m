//
//  MMEmptyKeyView.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMEmptyKeyView.h"

@implementation MMEmptyKeyView

- (instancetype)initWithFrame:(CGRect)frame keyIdentifier:(NSString *)keyIdentifier sizeMultiplier:(CGFloat)multiplier
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.sizeMultiplier = multiplier;
    }
    
    return self;
}

- (void)adjustFrame:(CGRect)newFrame
{
    self.frame = newFrame;
}

- (CGFloat)sizeMultiplier
{
    if (self.multiplierOverride) return self.multiplierOverride.floatValue;
    
    return _sizeMultiplier;
}

@end
