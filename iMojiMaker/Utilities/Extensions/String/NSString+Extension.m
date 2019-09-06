//
//  NSString+Extension.m
//  iMojiMaker
//
//  Created by Lucky on 5/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (ProductSize)

- (BOOL)containsProductSize:(kProductsSize)productSize;
{
    NSString *prefix = [self prefixForProductSize:productSize];
    
    if (!prefix) return NO;
    
    return [self.lastPathComponent hasPrefix:prefix];
}

- (NSString *)stringByDeletingProductSize
{
    NSString *resultString = self;
    
    resultString = [resultString stringByReplacingOccurrencesOfString:kSmallProductSizePrefix withString:@""];
    resultString = [resultString stringByReplacingOccurrencesOfString:kMediumProductSizePrefix withString:@""];
    resultString = [resultString stringByReplacingOccurrencesOfString:kBigProductSizePrefix withString:@""];
    
    return resultString;
}

- (NSString *)stringByAppendingProductSize:(kProductsSize)productSize
{
    if ([self containsProductSize:productSize]) return self;
    
    NSString *prefix = [self prefixForProductSize:productSize];
    NSString *productName = [self.lastPathComponent stringByDeletingProductSize];
    NSString *baseString = self.stringByDeletingLastPathComponent;
    NSString *lastPathComponent = [NSString stringWithFormat:@"%@%@",prefix, productName];
    
    return [baseString stringByAppendingPathComponent:lastPathComponent];
}

- (NSString *)prefixForProductSize:(kProductsSize)productSize
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
    
    return nil;
}

@end
