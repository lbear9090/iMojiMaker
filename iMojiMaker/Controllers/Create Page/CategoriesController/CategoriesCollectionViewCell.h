//
//  CategoriesCollectionViewCell.h
//  iMojiMaker
//
//  Created by Lucky on 5/3/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Product.h"
#import "Configurations.h"

@interface CategoriesCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)configureWithProduct:(Product *)product selected:(BOOL)selected;
- (void)setUsed:(BOOL)used;

@end
