//
//  MMiMojiKeyboardCollectionViewCell.h
//  Keyboard
//
//  Created by Lucky on 6/27/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductData.h"

@interface MMiMojiKeyboardCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)configureWithProductData:(ProductData *)productData;

@end
