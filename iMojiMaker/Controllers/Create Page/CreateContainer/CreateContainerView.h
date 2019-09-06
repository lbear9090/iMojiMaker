//
//  CreateContainerView.h
//  iMojiMaker
//
//  Created by Lucky on 5/9/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Product.h"
#import "GestureHandlerModel.h"
#import "CreateContainerModel.h"

@interface CreateContainerView : UIView

- (GestureHandlerModel *)handlerModelWithProductData:(ProductData *)productData;

- (void)addProductData:(ProductData *)productData;
- (void)addProductData:(ProductData *)productData details:(CreateContainerModelDetails *)details;
- (void)removeProductData:(ProductData *)productData;

- (CreateContainerModelDetails *)detailsForProductData:(ProductData *)productData;
- (void)configureProductData:(ProductData *)productData details:(CreateContainerModelDetails *)details;

- (void)moveProductDataProductData:(ProductData *)productData moveDirection:(kMoveDirection)moveDirection moveStep:(CGFloat)moveStep;
- (void)moveProductDataProductData:(ProductData *)productData moveType:(kMoveType)moveType;
- (void)scaleProductDataProductData:(ProductData *)productData scaleType:(kScaleType)scaleType scaleStep:(CGFloat)scaleStep;
- (void)opacityProductDataProductData:(ProductData *)productData opacityType:(kOpacityType)opacityType opacityStep:(CGFloat)opacityStep;
- (void)flipHorizontalForProductData:(ProductData *)productData;
- (void)resetDetailsForProductData:(ProductData *)productData;

- (CreateContainerModel *)containerModelForProductData:(ProductData *)productData;
- (void)reloadSubviews;

@end
