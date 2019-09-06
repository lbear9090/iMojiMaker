//
//  AnimatedImageView.m
//  iMojiMaker
//
//  Created by Lucky on 4/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "AnimatedImage.h"
#import "AnimatedImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimatedImageView ()

@property (nonatomic, strong, readwrite) UIImage *currentFrame;
@property (nonatomic, assign, readwrite) NSUInteger currentFrameIndex;

@property (nonatomic, assign) NSUInteger loopCountdown;
@property (nonatomic, assign) NSTimeInterval accumulator;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) BOOL shouldAnimate;
@property (nonatomic, assign) BOOL needsDisplayWhenImageBecomesAvailable;

@end

@implementation AnimatedImageView
@synthesize runLoopMode = _runLoopMode;

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.runLoopMode = [[self class] defaultRunLoopMode];
    
    if (@available(iOS 11.0, *))
    {
        self.accessibilityIgnoresInvertColors = YES;
    }
}

- (void)setAnimatedImage:(AnimatedImage *)animatedImage
{
    if (![_animatedImage isEqual:animatedImage])
    {
        if (animatedImage)
        {
            super.image = nil;
            super.highlighted = NO;
            [self invalidateIntrinsicContentSize];
        }
        else
        {
            [self stopAnimating];
        }
        
        _animatedImage = animatedImage;
        
        self.currentFrame = animatedImage.posterImage;
        self.currentFrameIndex = 0;
        
        if (animatedImage.loopCount > 0)
        {
            self.loopCountdown = animatedImage.loopCount;
        }
        else
        {
            self.loopCountdown = NSUIntegerMax;
        }
        
        self.accumulator = 0.0;
        
        [self updateShouldAnimate];
        
        if (self.shouldAnimate)
        {
            [self startAnimating];
        }
        
        [self.layer setNeedsDisplay];
    }
}

- (void)dealloc
{
    [_displayLink invalidate];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self updateShouldAnimate];
    
    if (self.shouldAnimate)
    {
        [self startAnimating];
    }
    else
    {
        [self stopAnimating];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self updateShouldAnimate];
    
    if (self.shouldAnimate)
    {
        [self startAnimating];
    }
    else
    {
        [self stopAnimating];
    }
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    
    [self updateShouldAnimate];
    
    if (self.shouldAnimate)
    {
        [self startAnimating];
    }
    else
    {
        [self stopAnimating];
    }
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    [self updateShouldAnimate];
    
    if (self.shouldAnimate)
    {
        [self startAnimating];
    }
    else
    {
        [self stopAnimating];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = [super intrinsicContentSize];
    
    if (self.animatedImage)
    {
        intrinsicContentSize = self.image.size;
    }
    
    return intrinsicContentSize;
}

- (UIImage *)image
{
    UIImage *image = nil;
    
    if (self.animatedImage)
    {
        image = self.currentFrame;
    }
    else
    {
        image = super.image;
    }
    
    return image;
}

- (void)setImage:(UIImage *)image
{
    if (image)
    {
        self.animatedImage = nil;
    }
    
    super.image = image;
}

- (NSTimeInterval)frameDelayGreatestCommonDivisor
{
    const NSTimeInterval kGreatestCommonDivisorPrecision = 2.0 / kAnimatedImageDelayTimeIntervalMinimum;
    NSArray *delays = self.animatedImage.delayTimesForIndexes.allValues;
    NSUInteger scaledGCD = lrint([delays.firstObject floatValue] * kGreatestCommonDivisorPrecision);
    
    for (NSNumber *value in delays)
    {
        scaledGCD = gcd(lrint([value floatValue] * kGreatestCommonDivisorPrecision), scaledGCD);
    }
    
    return scaledGCD / kGreatestCommonDivisorPrecision;
}


static NSUInteger gcd(NSUInteger a, NSUInteger b)
{
    if (a < b) return gcd(b, a);
    if (a == b) return b;
    
    while (true)
    {
        NSUInteger remainder = a % b;
        
        if (remainder == 0)
        {
            return b;
        }
        
        a = b;
        b = remainder;
    }
}

- (void)startAnimating
{
    if (self.animatedImage)
    {
        if (!self.displayLink)
        {
            WeakProxy *weakProxy = [WeakProxy weakProxyForObject:self];
            self.displayLink = [CADisplayLink displayLinkWithTarget:weakProxy selector:@selector(displayDidRefresh:)];
            [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopMode];
        }
        
        self.displayLink.paused = NO;
    }
    else
    {
        [super startAnimating];
    }
}

- (void)setRunLoopMode:(NSString *)runLoopMode
{
    if (![@[NSDefaultRunLoopMode, NSRunLoopCommonModes] containsObject:runLoopMode])
    {
        NSAssert(NO, @"Invalid run loop mode: %@", runLoopMode);
        _runLoopMode = [[self class] defaultRunLoopMode];
    }
    else
    {
        _runLoopMode = runLoopMode;
    }
}

- (void)stopAnimating
{
    if (self.animatedImage)
    {
        self.displayLink.paused = YES;
    }
    else
    {
        [super stopAnimating];
    }
}

- (BOOL)isAnimating
{
    BOOL isAnimating = NO;
    
    if (self.animatedImage)
    {
        isAnimating = self.displayLink && !self.displayLink.isPaused;
    }
    else
    {
        isAnimating = [super isAnimating];
    }
    
    return isAnimating;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (!self.animatedImage)
    {
        [super setHighlighted:highlighted];
    }
}

- (void)updateShouldAnimate
{
    BOOL isVisible = self.window && self.superview && ![self isHidden] && self.alpha > 0.0;
    self.shouldAnimate = self.animatedImage && isVisible;
}


- (void)displayDidRefresh:(CADisplayLink *)displayLink
{
    if (!self.shouldAnimate) return;
    
    NSNumber *delayTimeNumber = [self.animatedImage.delayTimesForIndexes objectForKey:@(self.currentFrameIndex)];
    
    if (delayTimeNumber)
    {
        NSTimeInterval delayTime = [delayTimeNumber floatValue];
        UIImage *image = [self.animatedImage imageLazilyCachedAtIndex:self.currentFrameIndex];
        
        if (image)
        {
            self.currentFrame = image;
            
            if (self.needsDisplayWhenImageBecomesAvailable)
            {
                [self.layer setNeedsDisplay];
                self.needsDisplayWhenImageBecomesAvailable = NO;
            }
            
            self.accumulator += displayLink.duration;
            
            while (self.accumulator >= delayTime)
            {
                self.accumulator -= delayTime;
                self.currentFrameIndex++;
                
                if (self.currentFrameIndex >= self.animatedImage.frameCount)
                {
                    self.loopCountdown--;
                    
                    if (self.loopCompletionBlock)
                    {
                        self.loopCompletionBlock(self.loopCountdown);
                    }
                    
                    if (self.loopCountdown == 0)
                    {
                        [self stopAnimating];
                        return;
                    }
                    
                    self.currentFrameIndex = 0;
                }
                
                self.needsDisplayWhenImageBecomesAvailable = YES;
            }
        }
    }
    else
    {
        self.currentFrameIndex++;
    }
}

+ (NSString *)defaultRunLoopMode
{
    return [NSProcessInfo processInfo].activeProcessorCount > 1 ? NSRunLoopCommonModes : NSDefaultRunLoopMode;
}

- (void)displayLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)self.image.CGImage;
}


@end
