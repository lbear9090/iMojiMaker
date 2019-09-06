//
//  ShopBuyRoundedActivityIndicatorView.m
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ShopBuyRoundedActivityIndicatorView.h"

static NSString *const kShopBuyRoundedActivityIndicatorViewRotationAnimationKey = @"kShopBuyRoundedActivityIndicatorViewRotationAnimationKey";

@implementation ShopBuyRoundedActivityIndicatorView
{
    UIImageView *_imageView;
    BOOL _animating;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)ensureImageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_imageView];
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    _imageView.bounds = CGRectMake(0, 0, size.width, size.height);
    _imageView.center = CGPointMake(size.width * 0.5, size.height * 0.5);
}

#pragma mark - Animation

- (void)startAnimating
{
    if (!_animating)
    {
        _animating = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    [self ensureImageView];
    [self ensureImageViewImage];
    [self ensureRotationAnimation];
}

- (void)stopAnimating
{
    if (_animating)
    {
        _animating = NO;
        [_imageView.layer removeAnimationForKey:kShopBuyRoundedActivityIndicatorViewRotationAnimationKey];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

- (BOOL)isAnimating
{
    return _animating;
}

- (void)ensureRotationAnimation
{
    if ([_imageView.layer animationForKey:kShopBuyRoundedActivityIndicatorViewRotationAnimationKey] == nil)
    {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(M_PI * 2.0);
        rotationAnimation.duration = 1.0;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount =  HUGE_VALF;
        [_imageView.layer addAnimation:rotationAnimation forKey:kShopBuyRoundedActivityIndicatorViewRotationAnimationKey];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self ensureAnimatingWhenNeeded];
}

- (void)_applicationWillEnterForeground
{
    [self ensureAnimatingWhenNeeded];
}

- (void)ensureAnimatingWhenNeeded
{
    if (_animating && self.window != nil)
    {
        [self ensureImageViewImage];
        [self ensureRotationAnimation];
    }
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanged = !CGSizeEqualToSize(frame.size, self.bounds.size);
    [super setFrame:frame];
    
    if (sizeChanged)
    {
        [self resetImageViewImage];
    }
}

- (CGFloat)lineWidth
{
    return _lineWidth == 0 ? 1 : _lineWidth;
}

#pragma mark - Image

- (void)ensureImageViewImage
{
    if (_imageView.image == nil)
    {
        _imageView.image = [self imageForAnimation];
    }
}

- (void)resetImageViewImage
{
    _imageView.image = nil;
    if (_animating && self.window != nil)
    {
        [self ensureImageViewImage];
    }
}

- (UIImage *)imageForAnimation
{
    CGRect rect = self.bounds;
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) return nil;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    [self.tintColor setStroke];
    
    // create a circle
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    path.lineWidth = self.lineWidth * 2;
    [path addClip];
    [path stroke];
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    
    // cut-out a hole
    UIRectFillUsingBlendMode(CGRectMake(rect.size.width - 6, rect.size.height / 2.0 - 2, 6, 6), kCGBlendModeClear);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image respondsToSelector:@selector(imageWithRenderingMode:)] ? [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : image;
}

@end
