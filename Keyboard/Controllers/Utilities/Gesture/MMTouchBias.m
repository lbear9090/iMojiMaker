//
//  MMTouchBias.m
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyView.h"
#import "MMTouchBias.h"

static const int kTouchRepeatThreshold = 4;
static const CGFloat kTouchOffsetStep = .01f;
static const CGPoint kMaxTouchOffsetBias = {0.07f, 0.03f};

static NSString *const kTouchOffsetBiasLeftKey = @"TouchOffsetBiasLeftKey";
static NSString *const kTouchOffsetBiasRightKey = @"TouchOffsetBiasRightKey";

@interface MMTouchBias ()
@property (nonatomic, assign) CGPoint leftTouchBias;
@property (nonatomic, assign) CGPoint leftTouchRepeatCount;
@property (nonatomic, assign) CGPoint rightTouchBias;
@property (nonatomic, assign) CGPoint rightTouchRepeatCount;
@end

@implementation MMTouchBias

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.leftTouchRepeatCount = CGPointZero;
        self.rightTouchRepeatCount = CGPointZero;
        self.leftTouchBias = [self pointForKey:kTouchOffsetBiasLeftKey];
        self.rightTouchBias = [self pointForKey:kTouchOffsetBiasRightKey];
    }
    
    return self;
}

- (void)registerTouchAtLocation:(CGPoint)touchLocation forKey:(MMKeyView *)keyView relativeView:(UIView *)relativeView
{
    CGRect keyFrame = keyView.frame;
    BOOL isLeftTouch = touchLocation.x < relativeView.frame.size.width / 2.0 ? YES : NO;
    
    CGPoint touchRepeatCount;
    CGPoint touchOffsetBias;
    
    if (isLeftTouch)
    {
        touchRepeatCount = self.leftTouchRepeatCount;
        touchOffsetBias = self.leftTouchBias;
    }
    else
    {
        touchRepeatCount = self.rightTouchRepeatCount;
        touchOffsetBias = self.rightTouchBias;
    }
    
    if (touchLocation.x - keyFrame.origin.x > keyFrame.size.width * 0.66f)
    {
        touchRepeatCount.x += 1.0;
        
        if (touchRepeatCount.x >= kTouchRepeatThreshold)
        {
            touchOffsetBias.x += kTouchOffsetStep;
            touchRepeatCount.x = 0.0;
        }
        
        if (touchOffsetBias.x > kMaxTouchOffsetBias.x)
        {
            touchOffsetBias.x = kMaxTouchOffsetBias.x;
        }
    }
    else if (touchLocation.x - keyFrame.origin.x < keyFrame.size.width * 0.33f)
    {
        touchRepeatCount.x -= 1.0;
        
        if (touchRepeatCount.x <= -kTouchRepeatThreshold)
        {
            touchOffsetBias.x -= kTouchOffsetStep;
            touchRepeatCount.x = 0.0;
        }
        
        if (touchOffsetBias.x < -kMaxTouchOffsetBias.x)
        {
            touchOffsetBias.x = -kMaxTouchOffsetBias.x;
        }
    }
    if (touchLocation.y - keyFrame.origin.y > keyFrame.size.height * 0.6f)
    {
        touchRepeatCount.y += 1.0;
        
        if (touchRepeatCount.y >= kTouchRepeatThreshold)
        {
            touchOffsetBias.y += kTouchOffsetStep;
            touchRepeatCount.y = 0.0;
        }
        
        if (touchOffsetBias.y > kMaxTouchOffsetBias.y)
        {
            touchOffsetBias.y = kMaxTouchOffsetBias.y;
        }
    }
    else if (touchLocation.y - keyFrame.origin.y < keyFrame.size.height * 0.4f)
    {
        touchRepeatCount.y -= 1.0;
        
        if (touchRepeatCount.y <= -kTouchRepeatThreshold)
        {
            touchOffsetBias.y -= kTouchOffsetStep;
            touchRepeatCount.y = 0.0;
        }
        
        if (touchOffsetBias.y < -kMaxTouchOffsetBias.y)
        {
            touchOffsetBias.y = -kMaxTouchOffsetBias.y;
        }
    }
    
    if (isLeftTouch)
    {
        self.leftTouchBias = touchOffsetBias;
        self.leftTouchRepeatCount = touchRepeatCount;
    }
    else
    {
        self.rightTouchBias = touchOffsetBias;
        self.rightTouchRepeatCount = touchRepeatCount;
    }
}

- (CGPoint)offsetForLocation:(CGPoint)location relativeView:(UIView *)relativeView
{
    CGFloat touchFactorX = location.x / relativeView.frame.size.width;
    CGFloat xOffset = self.rightTouchBias.x * touchFactorX + self.leftTouchBias.x * (1.0 - touchFactorX);
    CGFloat yOffset = self.rightTouchBias.y * touchFactorX + self.leftTouchBias.y * (1.0 - touchFactorX);
    
    return CGPointMake(xOffset, yOffset);
}

- (void)save
{
    [self setPoint:self.leftTouchBias forKey:kTouchOffsetBiasLeftKey];
    [self setPoint:self.rightTouchBias forKey:kTouchOffsetBiasRightKey];
}

- (CGPoint)pointForKey:(NSString *)key
{
    NSString *stringPoint = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (!stringPoint) return CGPointZero;
    
    return CGPointFromString(stringPoint);
}

- (void)setPoint:(CGPoint)point forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:NSStringFromCGPoint(point) forKey:key];
    [defaults synchronize];
}

@end
