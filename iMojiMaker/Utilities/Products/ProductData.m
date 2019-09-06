//
//  ProductData.m
//  iMojiMaker
//
//  Created by Lucky on 5/2/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ProductData.h"

static NSString *kProductDataAnimatedExtension = @"gif";

@implementation ProductData

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        _imagePath = path;
        _imageName = path.lastPathComponent;
        _isAnimated = [path.pathExtension.lowercaseString isEqualToString:kProductDataAnimatedExtension];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[ProductData class]])
    {
        ProductData *productData = (ProductData *)object;
        
        return ([productData.imageName isEqualToString:self.imageName] && [productData.imagePath isEqualToString:self.imagePath]);
    }
    
    return [super isEqual:object];
}

- (NSData *)loadImageData
{
    return [NSData dataWithContentsOfFile:self.imagePath];
}

@end
