//
//  ContentManager.h
//  iMojiMaker
//
//  Created by Lucky on 5/22/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ContentLoader.h"
#import "CreateContainerView.h"

typedef void (^ContentManagerCompletionBlock)(NSString *smallFilePath, NSString *mediumFilePath, NSString *bigFilePath);

@interface ContentManager : NSObject

+ (void)saveContentWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails completionBlock:(ContentManagerCompletionBlock)completionBlock;
+ (void)saveTemporaryContentWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails completionBlock:(ContentManagerCompletionBlock)completionBlock;

+ (void)removeContentWithProductData:(ProductData *)productData;

@end
