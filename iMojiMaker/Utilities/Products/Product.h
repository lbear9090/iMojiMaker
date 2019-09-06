//
//  Product.h
//  iMojiMaker
//
//  Created by Lucky on 4/30/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductData.h"

@interface Product : NSObject

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) BOOL isFlipped;
@property (nonatomic, strong) NSString *productNormalIcon;
@property (nonatomic, strong) NSString *productSelectedIcon;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSString *productFolderName;
@property (nonatomic, strong) NSString *productPrice;
@property (nonatomic, strong) NSString *productIAP;
@property (nonatomic, strong) NSString *productLayer;
@property (nonatomic, assign) NSInteger productLayerIndex;
@property (nonatomic, strong) NSMutableArray<ProductData *> *productData;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)loadProductData;

@end
