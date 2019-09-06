//
//  CreateContainerModel.h
//  iMojiMaker
//
//  Created by Lucky on 5/16/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Product.h"
#import "AnimatedImage.h"
#import "CreateContainerModelDetails.h"

typedef NS_ENUM(NSInteger, kMoveDirection)
{
    kMoveDirectionUp    = 0,
    kMoveDirectionDown  = 1,
    kMoveDirectionLeft  = 2,
    kMoveDirectionRight = 3
};

typedef NS_ENUM(NSInteger, kMoveType)
{
    kMoveTypeFront  = 0,
    kMoveTypeBack   = 1
};

typedef NS_ENUM(NSInteger, kScaleType)
{
    kScaleTypeIncrease  = 0,
    kScaleTypeDecrease  = 1
};

typedef NS_ENUM(NSInteger, kOpacityType)
{
    kOpacityTypeIncrease    = 0,
    kOpacityTypeDecrease    = 1
};

@interface CreateContainerModel : NSObject

@property (nonatomic, assign, readonly) NSInteger layerIndex;
@property (nonatomic, strong, readonly) ProductData *productData;
@property (nonatomic, strong, readonly) AnimatedImageView *animatedImageView;

- (instancetype)initWithProductData:(ProductData *)productData imageFrame:(CGRect)imageFrame;
- (void)configureWithProductData:(ProductData *)productData;

- (CreateContainerModelDetails *)detailsForProductData:(ProductData *)productData;
- (void)configureWithDetails:(CreateContainerModelDetails *)details;

- (void)moveWithDirection:(kMoveDirection)moveDirection moveStep:(CGFloat)moveStep;
- (void)moveWithType:(kMoveType)moveType;
- (void)scaleWithType:(kScaleType)scaleType scaleStep:(CGFloat)scaleStep;
- (void)opacityWithType:(kOpacityType)opacityType opacityStep:(CGFloat)opacityStep;
- (void)flipHorizontal;
- (void)resetDetails;

@end
