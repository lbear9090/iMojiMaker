//
//  NSURL+Extension.m
//  iMojiMaker
//
//  Created by Lucky on 5/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "NSURL+Extension.h"

@implementation NSURL (Directory)

- (BOOL)isDirectory
{
    NSNumber *isDirectory;
    [self getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
    
    return [isDirectory boolValue];
}

@end

@implementation NSURL (ProductSize)

- (BOOL)containsProductSize:(kProductsSize)productSize;
{
    NSString *prefix = [self prefixForProductSize:productSize];
    
    if (!prefix) return NO;
    
    return [self.lastPathComponent hasPrefix:prefix];
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
