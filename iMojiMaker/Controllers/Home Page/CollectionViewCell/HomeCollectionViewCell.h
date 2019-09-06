//
//  HomeCollectionViewCell.h
//  iMojiMaker
//
//  Created by Lucky on 5/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"

@interface HomeCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)configureWithProductData:(ProductData *)productData;

@end
