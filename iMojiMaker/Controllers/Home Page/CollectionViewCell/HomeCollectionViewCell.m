//
//  HomeCollectionViewCell.m
//  iMojiMaker
//
//  Created by Lucky on 5/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "AnimatedImage.h"
#import "HomeCollectionViewCell.h"

NSString *const kPlaceholderImageName = @"HomeBlank";

@interface HomeCollectionViewCell ()
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) AnimatedImageView *imageView;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation HomeCollectionViewCell

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
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = [UIImage imageNamed:kPlaceholderImageName];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    backgroundImageView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
    AnimatedImageView *imageView = [[AnimatedImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
}

- (void)configureWithProductData:(ProductData *)productData
{
    [self.operationQueue cancelAllOperations];
    
    self.backgroundImageView.hidden = NO;
    
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
            self.backgroundImageView.hidden = YES;
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
            self.backgroundImageView.hidden = YES;
        });
    }];
    
    [self.operationQueue addOperation:operation];
}

@end
