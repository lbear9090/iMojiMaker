//
//  CreateContainerModel.m
//  iMojiMaker
//
//  Created by Lucky on 5/16/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "CreateContainerModel.h"

CGFloat const kLayerIndexMaxValue = NSIntegerMax;
CGFloat const kLayerIndexMinValue = 0;

CGFloat const kScaleDefaultValue = 1.0;

CGFloat const kOpacityMaxValue = 1.0;
CGFloat const kOpacityMinValue = 0.1;

@interface CreateContainerModel ()
@property (nonatomic, assign, readwrite) CGRect imageFrame;
@property (nonatomic, assign, readwrite) NSInteger layerIndex;
@property (nonatomic, strong, readwrite) ProductData *productData;
@property (nonatomic, strong, readwrite) AnimatedImageView *animatedImageView;
@end

@implementation CreateContainerModel

- (instancetype)initWithProductData:(ProductData *)productData imageFrame:(CGRect)imageFrame
{
    self = [super init];
    if (self)
    {
        _imageFrame = imageFrame;
        _productData = productData;
        _layerIndex = productData.product.productLayerIndex;
    }
    
    return self;
}

- (void)configureWithProductData:(ProductData *)productData
{
    self.productData = productData;
    self.animatedImageView.image = nil;
    self.animatedImageView.animatedImage = nil;
    
    [self loadProductImage];
}

- (CreateContainerModelDetails *)detailsForProductData:(ProductData *)productData
{
    CGAffineTransform transform = self.animatedImageView.transform;
    self.animatedImageView.transform = CGAffineTransformIdentity;
    
    CGRect frame = self.animatedImageView.frame;
    self.animatedImageView.transform = transform;
    
    return [[CreateContainerModelDetails alloc] initWithFrame:frame alpha:self.animatedImageView.alpha layerIndex:self.layerIndex transform:transform];
}

- (void)configureWithDetails:(CreateContainerModelDetails *)details
{
    if (!details) return;
    
    self.animatedImageView.transform = CGAffineTransformIdentity;
    
    self.layerIndex = details.layerIndex;
    self.animatedImageView.alpha = details.alpha;
    self.animatedImageView.frame = details.frame;
    self.animatedImageView.transform = details.transform;
}

- (void)moveWithDirection:(kMoveDirection)moveDirection moveStep:(CGFloat)moveStep
{
    CGPoint center = self.animatedImageView.center;
    
    switch (moveDirection)
    {
        case kMoveDirectionUp:
        {
            center.y -= moveStep;
            break;
        }
        case kMoveDirectionDown:
        {
            center.y += moveStep;
            break;
        }
        case kMoveDirectionLeft:
        {
            center.x -= moveStep;
            break;
        }
        case kMoveDirectionRight:
        {
            center.x += moveStep;
            break;
        }
    }
    
    self.animatedImageView.center = center;
}

- (void)moveWithType:(kMoveType)moveType
{
    NSInteger index = self.layerIndex;
    
    switch (moveType)
    {
        case kMoveTypeFront:
        {
            index += 1;
            break;
        }
        case kMoveTypeBack:
        {
            index -= 1;
            break;
        }
    }
    
    self.layerIndex = MAX(MIN(index, kLayerIndexMaxValue), kLayerIndexMinValue);
}

- (void)scaleWithType:(kScaleType)scaleType scaleStep:(CGFloat)scaleStep
{
    CGFloat scaleValue = kScaleDefaultValue;
    
    switch (scaleType)
    {
        case kScaleTypeIncrease:
        {
            scaleValue += scaleStep;
            break;
        }
        case kScaleTypeDecrease:
        {
            scaleValue -= scaleStep;
            break;
        }
    }
    
    self.animatedImageView.transform = CGAffineTransformScale(self.animatedImageView.transform, scaleValue, scaleValue);
}

- (void)opacityWithType:(kOpacityType)opacityType opacityStep:(CGFloat)opacityStep
{
    CGFloat opacity = self.animatedImageView.alpha;

    switch (opacityType)
    {
        case kOpacityTypeIncrease:
        {
            opacity += opacityStep;
            break;
        }
        case kOpacityTypeDecrease:
        {
            opacity -= opacityStep;
            break;
        }
    }

    self.animatedImageView.alpha = MAX(MIN(opacity, kOpacityMaxValue), kOpacityMinValue);
}

- (void)flipHorizontal
{
    CGAffineTransform transform = self.animatedImageView.transform;
    CGAffineTransform flipTransform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.animatedImageView.transform = CGAffineTransformConcat(transform, flipTransform);
}

- (void)resetDetails
{
    self.layerIndex = self.productData.product.productLayerIndex;
    
    self.animatedImageView.transform = CGAffineTransformIdentity;
    self.animatedImageView.frame = self.imageFrame;
    self.animatedImageView.alpha = 1.0;
}

- (AnimatedImageView *)animatedImageView
{
    if (!_animatedImageView)
    {
        _animatedImageView = [[AnimatedImageView alloc] initWithFrame:self.imageFrame];
        _animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
        _animatedImageView.autoresizingMask = [self autoresizingMask];
        _animatedImageView.backgroundColor = [UIColor clearColor];
        
        [self loadProductImage];
    }
    
    return _animatedImageView;
}

- (UIViewAutoresizing)autoresizingMask
{
    return UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)loadProductImage
{
    NSData *imageData = [self.productData loadImageData];
    
    if (self.productData.isAnimated)
    {
        AnimatedImage *image = [AnimatedImage animatedImageWithGIFData:imageData];
        self.animatedImageView.animatedImage = image;
    }
    else
    {
        self.animatedImageView.image = [UIImage imageWithData:imageData];
    }
}

@end
