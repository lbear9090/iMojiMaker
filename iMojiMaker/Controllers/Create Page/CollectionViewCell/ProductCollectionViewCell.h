//
//  ProductCollectionViewCell.h
//  iMojiMaker
//
//  Created by Lucky on 5/8/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import "Configurations.h"

extern CGFloat const kProductLockImageInset;
extern NSString *const kProductLockImageName;

@interface ProductCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)configureCell;
- (void)configureWithProductData:(ProductData *)productData;
- (void)configureBackgroundWithImagePath:(NSString *)backgroundImagePath;

@end
