//
//  MMiMojiKeyboardCollectionViewCell.m
//  Keyboard
//
//  Created by Lucky on 6/27/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Utilities.h"
#import "AnimatedImage.h"
#import "MMiMojiKeyboardCollectionViewCell.h"

@interface MMiMojiKeyboardCollectionViewCell ()
@property (nonatomic, weak) AnimatedImageView *imageView;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation MMiMojiKeyboardCollectionViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureCell];
    }
    
    return self;
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue)
    {
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return _operationQueue;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.operationQueue cancelAllOperations];
}

- (void)configureCell
{
    AnimatedImageView *imageView = [[AnimatedImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
}

- (void)configureWithProductData:(ProductData *)productData
{
    [self.operationQueue cancelAllOperations];
    
    self.imageView.animatedImage = nil;
    self.imageView.image = nil;
    
    [self loadProductDataImageWithProductData:productData];
}

- (void)loadProductDataImageWithProductData:(ProductData *)productData
{
    if (!productData) return;
    
    if (!productData.isAnimated)
    {
        [self loadStaticImageWithProductData:productData];
    }
    else
    {
        [self loadAnimatedImageWithProductData:productData];
    }
}

- (void)loadStaticImageWithProductData:(ProductData *)productData
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^
    {
        NSData *imageData = [productData loadImageData];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.imageView.image = image;
        });
    }];
    
    [self.operationQueue addOperation:operation];
}

- (void)loadAnimatedImageWithProductData:(ProductData *)productData
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^
    {
        NSData *imageData = [productData loadImageData];
        AnimatedImage *image = [AnimatedImage animatedImageWithGIFData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.imageView.animatedImage = image;
        });
    }];
    
    [self.operationQueue addOperation:operation];
}

@end
