//
//  Products.h
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Product.h"

@interface Products : NSObject

+ (void)loadProducts;
+ (NSArray *)productsIAP;
+ (NSArray<Product *> *)products;

@end
