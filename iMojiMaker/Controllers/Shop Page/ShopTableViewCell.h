//
//  ShopTableViewCell.h
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import <UIKit/UIKit.h>

extern NSString *const kShopTableViewCellUpdateNotification;

@interface ShopTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeight;

- (void)configureWithProduct:(Product *)product;

@end
