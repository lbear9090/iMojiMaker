//
//  ShopBuyButton.h
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShopBuyButtonState)
{
    ShopBuyButtonStateNormal         = 0,
    ShopBuyButtonStateConfirmation   = 1,
    ShopBuyButtonStateProgress       = 2
};

@interface ShopBuyButton : UIControl

@property (nonatomic, assign) IBInspectable ShopBuyButtonState buttonState;
@property (nonatomic, strong) IBInspectable UIImage *image;
@property (nonatomic, strong) IBInspectable UIFont *titleLabelFont;
@property (nonatomic, strong) IBInspectable UIColor *normalColor;
@property (nonatomic, strong) IBInspectable UIColor *confirmationColor;
@property (nonatomic, copy) IBInspectable NSString *normalTitle;
@property (nonatomic, copy) IBInspectable NSString *confirmationTitle;
@property (nonatomic, copy) IBInspectable NSAttributedString *attributedNormalTitle;
@property (nonatomic, copy) IBInspectable NSAttributedString *attributedConfirmationTitle;

- (void)setButtonState:(ShopBuyButtonState)buttonState animated:(BOOL)animated;

@end
