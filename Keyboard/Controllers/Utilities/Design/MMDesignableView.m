//
//  MMDesignableView.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMUIHelper.h"
#import "MMGradientView.h"
#import "MMDesignableView.h"
#import "MMBackgroundImageView.h"

@implementation MMDesignableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.useConstraints = NO;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.useConstraints = YES;
}

- (void)setBackgroundGradient:(MMGradient *)gradient
{
    if (self.useConstraints)
    {
        [self setBackgroundGradientWithConstraints:gradient];
    }
    else
    {
        [self setBackgroundGradientWithoutConstraints:gradient];
    }
}

- (void)setBackgroundGradientWithoutConstraints:(MMGradient *)gradient
{
    if (!gradient)
    {
        if (self.backgroundGradientView)
        {
            [self.backgroundGradientView removeFromSuperview];
            self.backgroundGradientView = nil;
        }
        
        return;
    }
    
    if (self.backgroundGradientView)
    {
        [self.backgroundGradientView removeFromSuperview];
    }
    
    self.backgroundGradientView = [MMGradientView gradientViewWithGradient:gradient];
    self.backgroundGradientView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundGradientView.frame = self.bounds;
    [self insertSubview:self.backgroundGradientView atIndex:0];
}

- (void)setBackgroundGradientWithConstraints:(MMGradient *)gradient
{
    if (!gradient)
    {
        if (self.backgroundGradientView)
        {
            [self.backgroundGradientView removeFromSuperview];
            self.backgroundGradientView = nil;
        }
        
        return;
    }
    
    if (self.backgroundGradientView)
    {
        [self.backgroundGradientView removeFromSuperview];
    }
    
    self.backgroundGradientView = [MMGradientView gradientViewWithGradient:gradient];
    self.backgroundGradientView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:self.backgroundGradientView atIndex:0];
    
    NSArray *constraints = [MMUIHelper snapAllSidesOfView:self.backgroundGradientView toView:self];
    [self addConstraints:constraints];
}

- (void)setBackgroundImage:(MMBackground *)backgroundImage
{
    if (self.useConstraints)
    {
        [self setBackgroundImageWithConstraints:backgroundImage];
    }
    else
    {
        [self setBackgroundImageWithoutConstraints:backgroundImage];
    }
}

- (void)setBackgroundImageWithoutConstraints:(MMBackground *)backgroundImage
{
    if (!backgroundImage)
    {
        if (self.backgroundImageView)
        {
            [self.backgroundImageView removeFromSuperview];
            self.backgroundImageView = nil;
        }
        
        return;
    }
    
    if (!self.backgroundImageView)
    {
        [self.backgroundImageView removeFromSuperview];
    }
    
    self.backgroundImageView = [MMBackgroundImageView backgroundImageViewWithBackground:backgroundImage];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundImageView.frame = self.bounds;
    [self insertSubview:self.backgroundImageView atIndex:0];
}

- (void)setBackgroundImageWithConstraints:(MMBackground *)backgroundImage
{
    if (!backgroundImage)
    {
        if (self.backgroundImageView)
        {
            [self.backgroundImageView removeFromSuperview];
            self.backgroundImageView = nil;
        }
        
        return;
    }
    
    if (!self.backgroundImageView)
    {
        [self.backgroundImageView removeFromSuperview];
    }
    
    self.backgroundImageView = [MMBackgroundImageView backgroundImageViewWithBackground:backgroundImage];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:self.backgroundImageView atIndex:0];
    
    NSArray *constraints = [MMUIHelper snapAllSidesOfView:self.backgroundImageView toView:self];
    [self addConstraints:constraints];
}

@end
