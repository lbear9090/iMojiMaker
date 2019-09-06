//
//  ContentLoader.h
//  iMojiMaker
//
//  Created by Lucky on 5/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"

typedef NS_ENUM(NSInteger, kProductsSize)
{
    kProductsSizeSmall  = 0,
    kProductsSizeMedium = 1,
    kProductsSizeBig    = 2
};

@interface ContentLoader : NSObject

+ (NSArray<ProductData *> *)loadProductsWithSize:(kProductsSize)productsSize;
+ (ProductData *)loadProductDataWithSize:(kProductsSize)productsSize productData:(ProductData *)productData;

@end
