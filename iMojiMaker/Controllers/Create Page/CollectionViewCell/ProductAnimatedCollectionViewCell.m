//
//  ProductAnimatedCollectionViewCell.m
//  iMojiMaker
//
//  Created by Lucky on 5/8/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "AnimatedImage.h"
#import "ProductAnimatedCollectionViewCell.h"

@interface ProductAnimatedCollectionViewCell ()
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) AnimatedImageView *productImageView;
@property (nonatomic, weak) UIImageView *lockImageView;
@property (nonatomic, strong) ProductData *productData;
@end

@implementation ProductAnimatedCollectionViewCell

- (void)setSelected:(BOOL)selected
{
    self.backgroundImageView.hidden = selected;
    self.productImageView.hidden = selected;
}

- (void)configureCell
{
    [super configureCell];
    
    [self addBackgroundImageView];
    [self addProductImageView];
    [self addLockImageView];
}

- (void)configureWithProductData:(ProductData *)productData
{
    [super configureWithProductData:productData];
    
    self.productData = productData;
    [self loadProductDataImage];
}

- (void)configureBackgroundWithImagePath:(NSString *)backgroundImagePath;
{
    [super configureBackgroundWithImagePath:backgroundImagePath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSData *imageData = [NSData dataWithContentsOfFile:backgroundImagePath];
        UIImage *image = [UIImage imageWithData:imageData scale:10];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.backgroundImageView.image = image;
        });
    });
}

- (void)loadProductDataImage
{
    self.backgroundImageView.image = nil;
    self.productImageView.animatedImage = nil;
    self.productImageView.transform = CGAffineTransformIdentity;
    
    self.lockImageView.hidden = !self.productData.isLocked;
    
    __weak ProductAnimatedCollectionViewCell *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSData *imageData = [weakSelf.productData loadImageData];
        AnimatedImage *image = [AnimatedImage animatedImageWithGIFData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.productImageView.animatedImage = image;
            [self adjustFlip];
        });
    });
}

- (void)adjustFlip
{
    if (!self.productData.product.isFlipped) return;
    
    CGAffineTransform transform = self.productImageView.transform;
    CGAffineTransform flipTransform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.productImageView.transform = CGAffineTransformConcat(transform, flipTransform);
}

- (void)addBackgroundImageView
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    backgroundImageView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
}

- (void)addProductImageView
{
    AnimatedImageView *imageView = [[AnimatedImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:imageView];
    self.productImageView = imageView;
}

- (void)addLockImageView
{
    CGRect lockImageViewFrame = CGRectInset(self.bounds, kProductLockImageInset, kProductLockImageInset);
    UIImageView *lockImageView = [[UIImageView alloc] initWithFrame:lockImageViewFrame];
    lockImageView.image = [UIImage imageNamed:kProductLockImageName];
    lockImageView.contentMode = UIViewContentModeBottomRight;
    lockImageView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:lockImageView];
    self.lockImageView = lockImageView;
}

@end
