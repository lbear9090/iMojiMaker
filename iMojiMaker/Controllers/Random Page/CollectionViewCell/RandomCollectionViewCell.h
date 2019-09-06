//
//  RandomCollectionViewCell.h
//  iMojiMaker
//
//  Created by Lucky on 5/26/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Product.h"
#import "Configurations.h"

@interface RandomCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)configureWithProduct:(Product *)product selected:(BOOL)selected;

@end
