//
//  Products.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import "Configurations.h"

@interface Products ()
@property (nonatomic, strong) NSMutableArray<Product *> *productsData;
@property (nonatomic, strong) NSMutableArray<NSString *> *productsIAP;
@end

@implementation Products

+ (void)loadProducts
{
    [[Products sharedProducts] loadProducts];
}

+ (NSArray *)productsIAP
{
    return [[Products sharedProducts] productsIAP];
}

+ (NSArray<Product *> *)products
{
    Products *products = [Products sharedProducts];
    return products.productsData;
}

+ (instancetype)sharedProducts
{
    static dispatch_once_t predicate;
    static Products *instance = nil;
    dispatch_once(&predicate, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (NSMutableArray<Product *> *)productsData
{
    if (!_productsData)
    {
        _productsData = [[NSMutableArray alloc] init];
    }
    
    return _productsData;
}

- (NSMutableArray<NSString *> *)productsIAP
{
    if (!_productsIAP)
    {
        _productsIAP = [[NSMutableArray alloc] init];
    }
    
    return _productsIAP;
}

- (void)loadProducts
{
    [self.productsIAP removeAllObjects];
    [self.productsData removeAllObjects];
    
    NSString *productsFilePath = [[NSBundle mainBundle] pathForResource:kProductsFileName ofType:nil];
    NSArray *productsContent = [NSArray arrayWithContentsOfFile:productsFilePath];
    
    for (NSInteger index = 0; index < productsContent.count; index++)
    {
        NSDictionary *dictionary = productsContent[index];
        
        Product *product = [[Product alloc] initWithDictionary:dictionary];
        [product loadProductData];
        
        [self.productsData addObject:product];
        
        if (product.isLocked)
        {
            [self.productsIAP addObject:product.productIAP];
        }
    }
}

@end
