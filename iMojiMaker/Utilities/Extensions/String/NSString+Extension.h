//
//  NSString+Extension.h
//  iMojiMaker
//
//  Created by Lucky on 5/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ContentLoader.h"
#import "Configurations.h"

@interface NSString (ProductSize)

- (BOOL)containsProductSize:(kProductsSize)productSize;

- (NSString *)stringByDeletingProductSize;
- (NSString *)stringByAppendingProductSize:(kProductsSize)productSize;

@end
