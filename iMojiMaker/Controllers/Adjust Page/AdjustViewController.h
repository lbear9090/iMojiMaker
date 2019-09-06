//
//  AdjustViewController.h
//  iMojiMaker
//
//  Created by Lucky on 4/30/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ViewController.h"
#import "CreateContainerModelDetails.h"

@protocol AdjustViewControllerDelegate;

@interface AdjustViewController : ViewController

@property (nonatomic, weak) id<AdjustViewControllerDelegate> delegate;

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSArray<ProductData *> *productsData;
@property (nonatomic, strong) NSArray<CreateContainerModelDetails *> *productsDetails;

@end

@protocol AdjustViewControllerDelegate <NSObject>

- (void)configureWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails;

@end
