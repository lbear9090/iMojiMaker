//
//  UIImage+ProductSize.m
//  iMojiMaker
//
//  Created by Lucky on 5/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "UIImage+ProductSize.h"

CGFloat const kImageSizeSmall = 50.0;
CGFloat const kImageSizeMedium = 100.0;
CGFloat const kImageSizeBig = 200.0;

@implementation UIImage (ProductSize)

- (UIImage *)imageWithProductSize:(kProductsSize)productSize
{
    CGSize imageSize = [self imageSizeForProductSize:productSize];
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [self drawInRect:CGRectMake(0.0, 0.0, imageSize.width, imageSize.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (CGSize)imageSizeForProductSize:(kProductsSize)productSize
{
    switch (productSize)
    {
        case kProductsSizeSmall:
        {
            return CGSizeMake(kImageSizeSmall, kImageSizeSmall);
        }
        case kProductsSizeMedium:
        {
            return CGSizeMake(kImageSizeMedium, kImageSizeMedium);
        }
        case kProductsSizeBig:
        {
            return CGSizeMake(kImageSizeBig, kImageSizeBig);
        }
    }
    
    return self.size;
}

@end
