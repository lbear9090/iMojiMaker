//
//  ContentLoader.m
//  iMojiMaker
//
//  Created by Lucky on 5/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ContentLoader.h"
#import "Configurations.h"
#import "NSURL+Extension.h"
#import "NSString+Extension.h"

@implementation ContentLoader

+ (NSArray<ProductData *> *)loadProductsWithSize:(kProductsSize)productSize;
{
    NSMutableArray *productsArray = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *properties = [self propertiesForKeys];
    NSDirectoryEnumerationOptions options = [self directoryEnumerationOptions];
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:kAppGroupId];
    NSArray *contentArray = [fileManager contentsOfDirectoryAtURL:containerURL includingPropertiesForKeys:properties options:options error:nil];
    NSArray *sortedContentArray = [self sortContentArray:contentArray withOptions:NSNumericSearch];
    
    for (NSInteger contentIndex = 0; contentIndex < sortedContentArray.count; contentIndex++)
    {
        NSURL *productURL = sortedContentArray[contentIndex];
        
        if ([productURL isDirectory]) continue;
        if (![productURL containsProductSize:productSize]) continue;
        
        ProductData *productData = [[ProductData alloc] initWithPath:productURL.path];
        [productsArray addObject:productData];
    }
    
    return productsArray;
}

+ (ProductData *)loadProductDataWithSize:(kProductsSize)productsSize productData:(ProductData *)productData
{
    if (!productData) return nil;
    if ([productData.imagePath containsProductSize:productsSize]) return productData;
    
    NSString *productPath = [productData.imagePath stringByAppendingProductSize:productsSize];
    return [[ProductData alloc] initWithPath:productPath];
}

+ (NSArray *)propertiesForKeys
{
    return @[NSURLNameKey, NSURLIsDirectoryKey];
}

+ (NSDirectoryEnumerationOptions)directoryEnumerationOptions
{
    return NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants;
}

+ (NSArray *)sortContentArray:(NSArray<NSURL *> *)contentArray withOptions:(NSStringCompareOptions)options
{
    NSArray *sortedArray = [contentArray sortedArrayUsingComparator:^NSComparisonResult(NSURL *lhsURL, NSURL *rhsURL)
    {
        return [lhsURL.lastPathComponent compare:rhsURL.lastPathComponent options:options];
    }];
    
    return sortedArray;
}

@end
