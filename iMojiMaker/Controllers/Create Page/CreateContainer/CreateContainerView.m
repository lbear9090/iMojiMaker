//
//  CreateContainerView.m
//  iMojiMaker
//
//  Created by Lucky on 5/9/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "CreateContainerView.h"

static NSString *kLayerIndexKeyPath = @"layerIndex";

@interface CreateContainerView ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, CreateContainerModel *> *contentDictionary;
@property (nonatomic, strong) NSArray<NSSortDescriptor *> *sortDescriptors;
@property (nonatomic, strong) GestureHandlerModel *handlerModel;
@end

@implementation CreateContainerView

- (GestureHandlerModel *)handlerModelWithProductData:(ProductData *)productData
{
    self.handlerModel.view = nil;
    self.handlerModel.isFlipped = NO;
    
    CreateContainerModel *containerModel = self.contentDictionary[productData.product.productLayer];
    
    if (!containerModel) return nil;
    if (containerModel.productData.product.productLayerIndex == 0) return nil;
    
    self.handlerModel.view = containerModel.animatedImageView;
    self.handlerModel.isFlipped = productData.product.isFlipped;
    
    return self.handlerModel;
}

- (void)addProductData:(ProductData *)productData
{
    [self addProductData:productData details:nil];
}

- (void)addProductData:(ProductData *)productData details:(CreateContainerModelDetails *)details
{
    CreateContainerModel *containerModel = [self containerModelWithProductData:productData details:details];
    [containerModel configureWithProductData:productData];
    
    [self reloadSubviews];
}

- (void)removeProductData:(ProductData *)productData
{
    CreateContainerModel *containerModel = [self containerModelForProductData:productData];
    [containerModel.animatedImageView removeFromSuperview];
    
    [self.contentDictionary removeObjectForKey:productData.product.productLayer];
}

- (CreateContainerModelDetails *)detailsForProductData:(ProductData *)productData
{
    CreateContainerModel *containerModel = self.contentDictionary[productData.product.productLayer];
    
    if (!containerModel) return nil;
    
    return [containerModel detailsForProductData:productData];
}

- (void)configureProductData:(ProductData *)productData details:(CreateContainerModelDetails *)details
{
    CreateContainerModel *containerModel = [self containerModelForProductData:productData];
    
    if (!containerModel) return;
    
    [containerModel configureWithDetails:details];
}

- (void)moveProductDataProductData:(ProductData *)productData moveDirection:(kMoveDirection)moveDirection moveStep:(CGFloat)moveStep
{
    CreateContainerModel *containerModel = [self containerModelForProductData:productData];
    
    if (!containerModel) return;
    
    [containerModel moveWithDirection:moveDirection moveStep:moveStep];
}

- (void)moveProductDataProductData:(ProductData *)productData moveType:(kMoveType)moveType
{
    CreateContainerModel *containerModel = [self containerModelForProductData:productData];
    
    if (!containerModel) return;
    
    [containerModel moveWithType:moveType];
    
    [self reloadSubviews];
}

- (void)scaleProductDataProductData:(ProductData *)productData scaleType:(kScaleType)scaleType scaleStep:(CGFloat)scaleStep
{
    CreateContainerModel *containerModel = [self containerModelForProductData:productData];
    
    if (!containerModel) return;
    
    [containerModel scaleWithType:scaleType scaleStep:scaleStep];
}

- (void)opacityProductDataProductData:(ProductData *)productData opacityType:(kOpacityType)opacityType opacityStep:(CGFloat)opacityStep
{
    CreateContainerModel *containerModel = [self containerModelForProductData:productData];
    
    if (!containerModel) return;
    
    [containerModel opacityWithType:opacityType opacityStep:opacityStep];
}

- (void)flipHorizontalForProductData:(ProductData *)productData
{
    CreateContainerModel *containerModel = [self containerModelForProductData:productData];
    
    if (!containerModel) return;
    
    [containerModel flipHorizontal];
    
    BOOL isFlipped = !self.handlerModel.isFlipped;
    self.handlerModel.isFlipped = isFlipped;
    productData.product.isFlipped = isFlipped;
}

- (void)resetDetailsForProductData:(ProductData *)productData
{
    CreateContainerModel *containerModel = [self containerModelForProductData:productData];
    
    if (!containerModel) return;
    
    [containerModel resetDetails];
    
    self.handlerModel.isFlipped = NO;
    productData.product.isFlipped = NO;
    
    [self reloadSubviews];
}

- (CreateContainerModel *)containerModelForProductData:(ProductData *)productData
{
    return [self containerModelWithProductData:productData details:nil];
}

- (void)reloadSubviews
{
    NSArray *containerModels = [self.contentDictionary.allValues sortedArrayUsingDescriptors:self.sortDescriptors];
    for (NSInteger containerModelIndex = 0; containerModelIndex < containerModels.count; containerModelIndex++)
    {
        CreateContainerModel *containerModel = containerModels[containerModelIndex];
        NSInteger currentLayerIndex = [self.subviews indexOfObject:containerModel.animatedImageView];
        
        if (containerModel.layerIndex == currentLayerIndex) continue;
        
        [containerModel.animatedImageView removeFromSuperview];
        [self insertSubview:containerModel.animatedImageView atIndex:containerModel.layerIndex];
    }
}

- (NSMutableDictionary<NSString *, CreateContainerModel *> *)contentDictionary
{
    if (!_contentDictionary)
    {
        _contentDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _contentDictionary;
}

- (NSArray<NSSortDescriptor *> *)sortDescriptors
{
    if (!_sortDescriptors)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kLayerIndexKeyPath ascending:YES];
        _sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    }
    
    return _sortDescriptors;
}

- (GestureHandlerModel *)handlerModel
{
    if (!_handlerModel)
    {
        _handlerModel = [[GestureHandlerModel alloc] init];
    }
    
    return _handlerModel;
}

- (CreateContainerModel *)containerModelWithProductData:(ProductData *)productData details:(CreateContainerModelDetails *)details
{
    CreateContainerModel *containerModel = self.contentDictionary[productData.product.productLayer];
    if (!containerModel)
    {
        containerModel = [[CreateContainerModel alloc] initWithProductData:productData imageFrame:self.bounds];
        
        [self.contentDictionary setObject:containerModel forKey:productData.product.productLayer];
        [self insertSubview:containerModel.animatedImageView atIndex:containerModel.layerIndex];
        
        [containerModel configureWithDetails:details];
    }
    
    return containerModel;
}

@end
