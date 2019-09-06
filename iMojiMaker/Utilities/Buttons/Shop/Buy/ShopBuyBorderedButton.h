//
//  ShopBuyBorderedButton.h
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kShopBuyBorderedButtonDefaultBorderWidth;
extern CGFloat const kShopBuyBorderedButtonDefaultCornerRadius;

IB_DESIGNABLE
@interface ShopBuyBorderedButton : UIControl

@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, copy) IBInspectable NSAttributedString *attributedTitle;
@property (nonatomic, strong) IBInspectable UIImage *image;

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

@property (nonatomic, assign) IBInspectable CGFloat borderWidth; // defaults to kMNBorderedButtonDefaultBorderWidth
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius; // defaults to kMNBorderedButtonDefaultCornerRadius

@end
