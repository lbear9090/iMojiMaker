//
//  ShopBuyBorderedButton.m
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ShopBuyBorderedView.h"
#import "ShopBuyBorderedButton.h"

CGFloat const kShopBuyBorderedButtonDefaultBorderWidth = 1.0;
CGFloat const kShopBuyBorderedButtonDefaultCornerRadius = 4.0;

@implementation ShopBuyBorderedButton
{
    ShopBuyBorderedView *_borderView;
    UIImageView *_fillView;
    UIView *_labelClipView;
    UIImageView *_accessoryImageView;
    UIView *_accessoryAndLabelView;
}

#pragma mark - Initialization

- (void)setup
{
    if (nil == _titleLabel)
    {
        // defaults for properties
        _cornerRadius = kShopBuyBorderedButtonDefaultCornerRadius;
        _borderWidth = kShopBuyBorderedButtonDefaultBorderWidth;
        
        // view defaults
        self.backgroundColor = [UIColor clearColor];
        
        // the border view
        _borderView = [[ShopBuyBorderedView alloc] initWithFrame:self.bounds];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.userInteractionEnabled = NO;
        _borderView.layer.cornerRadius = self.cornerRadius;
        _borderView.layer.borderWidth = self.borderWidth;
        [self addSubview:_borderView];
        
        // the title label is clipped inside this view
        _labelClipView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 2, 2)];
        _labelClipView.backgroundColor = [UIColor clearColor];
        _labelClipView.opaque = NO;
        _labelClipView.clipsToBounds = YES;
        _labelClipView.userInteractionEnabled = NO;
        [self addSubview:_labelClipView];
        
        _accessoryAndLabelView = [[UIView alloc] initWithFrame:_labelClipView.bounds];
        _accessoryAndLabelView.backgroundColor = [UIColor clearColor];
        _accessoryAndLabelView.opaque = NO;
        [_labelClipView addSubview:_accessoryAndLabelView];
        
        _accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_accessoryAndLabelView addSubview:_accessoryImageView];
        
        // the title label itself
        _titleLabel = [[UILabel alloc] initWithFrame:_accessoryImageView.bounds];
        _titleLabel.opaque = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_accessoryAndLabelView addSubview:_titleLabel];
        
        [self updateTintColors];
    }
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil)
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self setup];
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = [self.titleLabel sizeThatFits:size];
    if (self.image != nil)
    {
        newSize.width += newSize.height - 8;
    }
    
    newSize.width += 20; // add some spacing
    newSize.height += 8;
    newSize.width = ceilf(newSize.width);
    newSize.height = ceilf(newSize.height);
    
    return newSize;
}

#pragma mark - Properties

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (cornerRadius != _cornerRadius)
    {
        _cornerRadius = cornerRadius;
        _borderView.layer.cornerRadius = self.cornerRadius;
    }
}


- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (borderWidth != _borderWidth)
    {
        _borderWidth = borderWidth;
        _borderView.layer.borderWidth = self.borderWidth;
    }
}

- (BOOL)shouldShowFillView
{
    return self.highlighted;
}

#pragma mark - Layout code

- (void)layoutSubviews
{
    [super layoutSubviews];
    _borderView.frame = self.bounds;
    _fillView.frame = self.bounds;
    _labelClipView.frame = CGRectInset(_borderView.bounds, 2, 2);
    _accessoryAndLabelView.frame = UIEdgeInsetsInsetRect(_labelClipView.bounds, self.titleEdgeInsets);
    
    _accessoryImageView.frame = _accessoryImageView.image != nil ? CGRectInset(CGRectMake(0, 0, CGRectGetHeight(_accessoryAndLabelView.bounds), CGRectGetHeight(_accessoryAndLabelView.bounds)), 4, 4) : CGRectZero;
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_accessoryImageView.frame), 0, CGRectGetWidth(_accessoryAndLabelView.bounds) - CGRectGetMaxX(_accessoryImageView.frame), CGRectGetHeight(_accessoryAndLabelView.bounds));
}

#pragma mark - FillView

- (void)ensureFillView
{
    if (nil == _fillView)
    {
        _fillView = [[UIImageView alloc] initWithFrame:self.bounds];
        _fillView.userInteractionEnabled = NO;
        _fillView.alpha = 0;
        _fillView.layer.cornerRadius = self.cornerRadius;
        [self insertSubview:_fillView aboveSubview:_borderView];
    }
}

- (UIImage *)fillViewMaskImage
{
    CGFloat actualWidth = _fillView.bounds.size.width;
    CGFloat actualHeight = _fillView.bounds.size.height;
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, actualWidth * deviceScale, actualHeight * deviceScale, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CGContextScaleCTM(context, deviceScale, deviceScale);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, _fillView.bounds);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawImage(context, [_accessoryImageView convertRect:_accessoryImageView.bounds toView:_fillView], self.image.CGImage);
    
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return [UIImage imageWithCGImage:grayImage scale:deviceScale orientation:UIImageOrientationUp];
}

- (UIImage *)fillViewImage
{
    if (_fillView.bounds.size.width <= 0 || _fillView.bounds.size.height <= 0) return nil;
    
    UIGraphicsBeginImageContextWithOptions(_fillView.bounds.size, NO, 0.0);
    
    [self.compatibleTintColor setFill]; // This image won't get tinted on iOS6, so pre-fill it with the right color
    
    // fill the background with a rounded corner
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    [path fill];
    
    // cut out the title by drawing the title label with a 'clear' blend mode
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    [_titleLabel drawTextInRect:[self.titleLabel convertRect:self.titleLabel.bounds toView:_fillView]];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (self.image != nil)
    {
        CGImageRef cgImage = CGImageCreateWithMask(image.CGImage, self.fillViewMaskImage.CGImage);
        image = [UIImage imageWithCGImage:cgImage];
    }
    
    return [image respondsToSelector:@selector(imageWithRenderingMode:)] ? [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : image;
}

- (void)updateFillView
{
    [self ensureFillView];
    _fillView.image = [self fillViewImage];
}

- (void)updateFillViewWhenNeeded
{
    _fillView.image = nil;
    if (_fillView.alpha != 0)
    {
        [self updateFillView];
    }
}

#pragma mark - Highlighting

- (void)updateHighlightedStateAnimated
{
    [self updateFillView];
    
    _fillView.alpha = [self shouldShowFillView] ? 1 : 0;
    _accessoryAndLabelView.alpha = [self shouldShowFillView] ? 0 : 1;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateHighlightedStateAnimated];
}

#pragma mark - set Text

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self updateFillViewWhenNeeded];
}

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    self.titleLabel.attributedText = attributedTitle;
    [self updateFillViewWhenNeeded];
}

- (NSAttributedString *)attributedTitle
{
    return self.titleLabel.attributedText;
}

#pragma mark - Set Image

- (void)setImage:(UIImage *)image
{
    _accessoryImageView.image = image;
    [self updateFillViewWhenNeeded];
}

- (UIImage *)image
{
    return _accessoryImageView.image;
}

#pragma mark - Responding to updates

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanged = !CGSizeEqualToSize(frame.size, self.bounds.size);
    [super setFrame:frame];
    
    if (sizeChanged)
    {
        [self updateFillViewWhenNeeded];
    }
}

#pragma mark - set TintColor

- (UIColor *)compatibleTintColor
{
    return self.tintColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self updateTintColors];
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    [self updateTintColors];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self updateTintColors];
}

- (void)updateTintColors
{
    _borderView.layer.borderColor = self.compatibleTintColor.CGColor;
    _titleLabel.textColor = self.compatibleTintColor;
}

@end
