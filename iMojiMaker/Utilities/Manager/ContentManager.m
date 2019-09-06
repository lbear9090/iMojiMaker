//
//  ContentManager.m
//  iMojiMaker
//
//  Created by Lucky on 5/22/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Configurations.h"
#import "ContentManager.h"
#import "UIView+Snapshot.h"
#import "NSString+Extension.h"
#import "CreateContainerView.h"
#import "UIImage+ProductSize.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSInteger const kAnimatedContentLoopCount = 0;
CGFloat const kAnimatedContentDelayTime = 0.04;

NSString *const kStaticContentExtension = @"png";
NSString *const kAnimatedContentExtension = @"gif";

@implementation ContentManager

+ (void)saveContentWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails completionBlock:(ContentManagerCompletionBlock)completionBlock
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:kAppGroupId];
    [self saveContentWithProductsData:productsData productsDetails:productsDetails directory:containerURL.path completionBlock:completionBlock];
}

+ (void)saveTemporaryContentWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails completionBlock:(ContentManagerCompletionBlock)completionBlock
{
    [self saveContentWithProductsData:productsData productsDetails:productsDetails directory:NSTemporaryDirectory() completionBlock:completionBlock];
}

+ (void)removeContentWithProductData:(ProductData *)productData
{
    if (!productData) return;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *smallFilePath = [productData.imagePath stringByAppendingProductSize:kProductsSizeSmall];
    NSString *mediumFilePath = [productData.imagePath stringByAppendingProductSize:kProductsSizeMedium];
    NSString *bigFilePath = [productData.imagePath stringByAppendingProductSize:kProductsSizeBig];
    
    [fileManager removeItemAtPath:smallFilePath error:nil];
    [fileManager removeItemAtPath:mediumFilePath error:nil];
    [fileManager removeItemAtPath:bigFilePath error:nil];
}

+ (void)saveContentWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails directory:(NSString *)directory completionBlock:(ContentManagerCompletionBlock)completionBlock
{
    if ([self isContentAnimatedWithProductsData:productsData])
    {
        [self saveAnimatedContentWithProductsData:productsData productsDetails:productsDetails directory:directory completionBlock:completionBlock];
    }
    else
    {
        [self saveStaticContentWithProductsData:productsData productsDetails:productsDetails directory:directory completionBlock:completionBlock];
    }
}

+ (BOOL)isContentAnimatedWithProductsData:(NSArray<ProductData *> *)productsData
{
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        ProductData *productData = productsData[productIndex];
        
        if (productData.isAnimated) return YES;
    }
    
    return NO;
}

+ (NSString *)computeFileNameWithTimestamp:(NSNumber *)timeStamp productSize:(kProductsSize)productSize isAnimated:(BOOL)isAnimated
{
    NSString *filePrefix = [self prefixForProductSize:productSize];
    NSString *fileExtension = isAnimated ? kAnimatedContentExtension : kStaticContentExtension;
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@",filePrefix, timeStamp.stringValue, fileExtension];
    
    return fileName;
}

+ (NSString *)computeFileNameWithTimestamp:(NSNumber *)timeStamp productSize:(kProductsSize)productSize
{
    return [self computeFileNameWithTimestamp:timeStamp productSize:productSize isAnimated:NO];
}

+ (NSString *)prefixForProductSize:(kProductsSize)productSize
{
    switch (productSize)
    {
        case kProductsSizeSmall:
        {
            return kSmallProductSizePrefix;
        }
        case kProductsSizeMedium:
        {
            return kMediumProductSizePrefix;
        }
        case kProductsSizeBig:
        {
            return kBigProductSizePrefix;
        }
    }
    
    return @"";
}

+ (NSNumber *)currentTimeStamp
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    return [NSNumber numberWithDouble:timeStamp];
}

+ (void)saveStaticContentWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails directory:(NSString *)directory completionBlock:(ContentManagerCompletionBlock)completionBlock
{
    NSNumber *timeStamp = [self currentTimeStamp];
    NSString *smallFilePath = [directory stringByAppendingPathComponent:[self computeFileNameWithTimestamp:timeStamp productSize:kProductsSizeSmall]];
    NSString *mediumFilePath = [directory stringByAppendingPathComponent:[self computeFileNameWithTimestamp:timeStamp productSize:kProductsSizeMedium]];
    NSString *bigFilePath = [directory stringByAppendingPathComponent:[self computeFileNameWithTimestamp:timeStamp productSize:kProductsSizeBig]];
    
    CreateContainerModelDetails *productDetails = productsDetails.firstObject;
    CreateContainerView *containerView = [[CreateContainerView alloc] initWithFrame:productDetails.frame];
    [self addProductsData:productsData productsDetails:productsDetails containerView:containerView];

    UIImage *bigImage = [containerView snapshot];
    UIImage *mediumImage = [bigImage imageWithProductSize:kProductsSizeMedium];
    UIImage *smallImage = [bigImage imageWithProductSize:kProductsSizeSmall];
    
    [UIImagePNGRepresentation(smallImage) writeToFile:smallFilePath atomically:YES];
    [UIImagePNGRepresentation(mediumImage) writeToFile:mediumFilePath atomically:YES];
    [UIImagePNGRepresentation(bigImage) writeToFile:bigFilePath atomically:YES];
    
    if (completionBlock)
    {
        completionBlock(smallFilePath, mediumFilePath, bigFilePath);
    }
}

+ (void)saveAnimatedContentWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails directory:(NSString *)directory completionBlock:(ContentManagerCompletionBlock)completionBlock
{
    NSNumber *timeStamp = [self currentTimeStamp];
    NSString *smallFilePath = [directory stringByAppendingPathComponent:[self computeFileNameWithTimestamp:timeStamp productSize:kProductsSizeSmall isAnimated:YES]];
    NSString *mediumFilePath = [directory stringByAppendingPathComponent:[self computeFileNameWithTimestamp:timeStamp productSize:kProductsSizeMedium isAnimated:YES]];
    NSString *bigFilePath = [directory stringByAppendingPathComponent:[self computeFileNameWithTimestamp:timeStamp productSize:kProductsSizeBig isAnimated:YES]];
    
    CreateContainerModelDetails *productDetails = productsDetails.firstObject;
    CreateContainerView *containerView = [[CreateContainerView alloc] initWithFrame:productDetails.frame];
    [self addProductsData:productsData productsDetails:productsDetails containerView:containerView];

    NSArray<UIImage *> *frames = [self createFramesWithProductsData:productsData containerView:containerView];
    [self saveAnimatedContentWithFrames:frames productSize:kProductsSizeSmall filePath:smallFilePath];
    [self saveAnimatedContentWithFrames:frames productSize:kProductsSizeMedium filePath:mediumFilePath];
    [self saveAnimatedContentWithFrames:frames productSize:kProductsSizeBig filePath:bigFilePath];
    
    if (completionBlock)
    {
        completionBlock(smallFilePath, mediumFilePath, bigFilePath);
    }
}

+ (void)addProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails containerView:(CreateContainerView *)containerView
{
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        ProductData *productData = productsData[productIndex];
        CreateContainerModelDetails *productDetails = productsDetails[productIndex];
        [containerView addProductData:productData details:productDetails];
    }
}

+ (NSArray<UIImage *> *)createFramesWithProductsData:(NSArray<ProductData *> *)productsData containerView:(CreateContainerView *)containerView
{
    NSMutableArray *framesArray = [NSMutableArray array];
    NSInteger numberOfFrames = [self numberOfFramesWithProductsData:productsData containerView:containerView];
    NSDictionary *imagesDictionary = [self animatedImagesWithProductsData:productsData containerView:containerView];
    
    for (NSInteger frameIndex = 0; frameIndex < numberOfFrames; frameIndex++)
    {
        for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
        {
            ProductData *productData = productsData[productIndex];
            
            if (!productData.isAnimated) continue;
            
            AnimatedImage *animatedImage = imagesDictionary[@(productIndex)];
            CreateContainerModel *containerModel = [containerView containerModelForProductData:productData];
            containerModel.animatedImageView.animatedImage = nil;
            
            if (frameIndex >= animatedImage.frameCount)
            {
                containerModel.animatedImageView.image = [animatedImage imageAtIndex:animatedImage.frameCount - 1];
            }
            else
            {
                containerModel.animatedImageView.image = [animatedImage imageAtIndex:frameIndex];
            }
        }
        
        [framesArray addObject:[containerView snapshotWithScale:1.0]];
    }
    
    return framesArray;
}

+ (NSDictionary *)animatedImagesWithProductsData:(NSArray<ProductData *> *)productsData containerView:(CreateContainerView *)containerView
{
    NSMutableDictionary *imagesDictionary = [NSMutableDictionary dictionary];
    
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        ProductData *productData = productsData[productIndex];
        
        if (!productData.isAnimated) continue;
        
        CreateContainerModel *containerModel = [containerView containerModelForProductData:productData];
        [imagesDictionary setObject:containerModel.animatedImageView.animatedImage forKey:@(productIndex)];
    }
    
    return imagesDictionary;
}

+ (NSInteger)numberOfFramesWithProductsData:(NSArray<ProductData *> *)productsData containerView:(CreateContainerView *)containerView
{
    NSInteger numberOfFrames = 1;
    
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        ProductData *productData = productsData[productIndex];
        
        if (!productData.isAnimated) continue;
        
        CreateContainerModel *containerModel = [containerView containerModelForProductData:productData];
        NSInteger productFramesCount = containerModel.animatedImageView.animatedImage.frameCount;
        
        if (productFramesCount > numberOfFrames)
        {
            numberOfFrames = productFramesCount;
        }
    }
    
    return numberOfFrames;
}

+ (void)saveAnimatedContentWithFrames:(NSArray<UIImage *> *)frames productSize:(kProductsSize)productSize filePath:(NSString *)filePath
{
    NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
    NSDictionary *fileProperties = @{ (id)kCGImagePropertyGIFDictionary : @{ (id)kCGImagePropertyGIFLoopCount : @(kAnimatedContentDelayTime) } };
    NSDictionary *frameProperties = @{ (id)kCGImagePropertyGIFDictionary : @{ (id)kCGImagePropertyGIFDelayTime : @(kAnimatedContentDelayTime) } };
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)filePathURL, kUTTypeGIF, frames.count, NULL);
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
    
    for (NSInteger frameIndex = 0; frameIndex < frames.count; frameIndex++)
    {
        @autoreleasepool
        {
            UIImage *frame = [frames[frameIndex] imageWithProductSize:productSize];
            CGImageDestinationAddImage(destination, frame.CGImage, (CFDictionaryRef)frameProperties);
        }
    }
    
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
}

@end
