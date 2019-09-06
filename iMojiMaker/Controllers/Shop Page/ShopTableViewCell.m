//
//  ShopTableViewCell.m
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "IAPManager.h"
#import "ShopBuyButton.h"
#import "Configurations.h"
#import "ShopTableViewCell.h"

NSString *const kShopTableViewCellUpdateNotification = @"kShopTableViewCellUpdateNotification";

@interface ShopTableViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *productName;
@property (nonatomic, weak) IBOutlet UILabel *productDescription;
@property (nonatomic, strong) ShopBuyButton *buttonAccessoryView;
@property (nonatomic, strong) NSString *productIAP;
@end

@implementation ShopTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (CGFloat)rowHeight
{
    return 61.0;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureAppearance];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.accessoryView = nil;
    self.iconImageView.image = nil;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:kShopTableViewCellUpdateNotification object:nil];
}

- (void)configureAppearance
{
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView.layer.cornerRadius = 12.0;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = [UIColor colorWithHexString:kLightGrayColor].CGColor;
}

- (ShopBuyButton *)buttonAccessoryView
{
    if (!_buttonAccessoryView)
    {
        _buttonAccessoryView = [[ShopBuyButton alloc] initWithFrame:CGRectZero];
        _buttonAccessoryView.tintColor = [UIColor colorWithHexString:kBlueColor];
        _buttonAccessoryView.buttonState = ShopBuyButtonStateNormal;
        [_buttonAccessoryView addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buttonAccessoryView;
}

- (void)configureWithProduct:(Product *)product
{
    self.productIAP = product.productIAP;
    self.productName.text = product.productName;
    self.productDescription.text = product.productDescription;
    self.iconImageView.image = [UIImage imageNamed:product.productNormalIcon];
    
    if (!product.isLocked) return;
    
    self.accessoryView = self.buttonAccessoryView;
    self.buttonAccessoryView.normalTitle = product.productPrice;
    self.buttonAccessoryView.hidden = !product.isLocked;
    [self.buttonAccessoryView sizeToFit];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(reloadButtonStateNotification:) name:kShopTableViewCellUpdateNotification object:nil];
}

- (void)buyButtonAction
{
    [self.buttonAccessoryView setButtonState:ShopBuyButtonStateProgress animated:YES];
    
    [[IAPManager sharedManager] purchaseProductWithSKU:self.productIAP];
}

- (void)reloadButtonStateNotification:(NSNotification *)notification
{
    [self.buttonAccessoryView setButtonState:ShopBuyButtonStateNormal animated:YES];
}

@end
