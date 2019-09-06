//
//  Product.m
//  iMojiMaker
//
//  Created by Lucky on 4/30/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Product.h"
#import "IAPManager.h"

static NSString *kProductNormalIconNameKey = @"NormalIconName";
static NSString *kProductSelectedIconNameKey = @"SelectedIconName";
static NSString *kProductNameKey = @"DisplayName";
static NSString *kProductDescriptionKey = @"Description";
static NSString *kProductFolderNameKey = @"FolderName";
static NSString *kProductPriceKey = @"Price";
static NSString *kProductIAPKey = @"In-App";
static NSString *kProductLayerKey = @"Layer";
static NSString *kProductLayerIndexKey = @"LayerIndex";

@implementation Product

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _productNormalIcon = dictionary[kProductNormalIconNameKey];
        _productSelectedIcon = dictionary[kProductSelectedIconNameKey];
        _productName = dictionary[kProductNameKey];
        _productDescription = dictionary[kProductDescriptionKey];
        _productFolderName = dictionary[kProductFolderNameKey];
        _productPrice = dictionary[kProductPriceKey] ?: @"";
        _productIAP = dictionary[kProductIAPKey] ?: @"";
        _productLayer = dictionary[kProductLayerKey];
        _productLayerIndex = [dictionary[kProductLayerIndexKey] integerValue];
        _isLocked = _productIAP.length == 0 ? NO : ![[IAPManager sharedManager] isProductInstalledWithSKU:_productIAP];
    }
    
    return self;
}

- (NSMutableArray<ProductData *> *)productData
{
    if (!_productData)
    {
        _productData = [[NSMutableArray alloc] init];
    }
    
    return _productData;
}

- (void)loadProductData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *productFilePath = [bundle pathForResource:self.productFolderName ofType:nil inDirectory:kProductsFolderName];
    NSString *freeProductFilePath = [productFilePath stringByAppendingPathComponent:kProductsFreeFolderName];
    NSString *buyProductFilePath = [productFilePath stringByAppendingPathComponent:kProductsBuyFolderName];
    NSArray *freeProductContent = [NSBundle pathsForResourcesOfType:nil inDirectory:freeProductFilePath];
    NSArray *buyProductContent = [NSBundle pathsForResourcesOfType:nil inDirectory:buyProductFilePath];
    
    [self parseProductContent:freeProductContent isLocked:NO];
    [self parseProductContent:buyProductContent isLocked:self.isLocked];
}

- (void)parseProductContent:(NSArray *)productContent isLocked:(BOOL)isLocked
{
    NSArray *sortedProductContent = [productContent sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    for (NSInteger index = 0; index < sortedProductContent.count; index++)
    {
        NSString *productDataPath = sortedProductContent[index];
        ProductData *productData = [[ProductData alloc] initWithPath:productDataPath];
        productData.isLocked = isLocked;
        productData.product = self;
        
        [self.productData addObject:productData];
    }
}

@end
