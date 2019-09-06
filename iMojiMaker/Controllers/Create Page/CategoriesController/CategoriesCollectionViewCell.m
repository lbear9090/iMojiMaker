//
//  CategoriesCollectionViewCell.m
//  iMojiMaker
//
//  Created by Lucky on 5/3/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "CategoriesCollectionViewCell.h"

@interface CategoriesCollectionViewCell ()
@property (nonatomic, weak) UIImageView *categoryImageView;
@property (nonatomic, strong) Product *product;
@end

@implementation CategoriesCollectionViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureCell];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    UIColor *color = selected ? [UIColor colorWithHexString:kProductSelectedColor] : [UIColor colorWithHexString:kProductNormalColor];
    NSString *imageName = selected ? self.product.productSelectedIcon : self.product.productNormalIcon;
    
    [self.categoryImageView setImage:[UIImage imageNamed:imageName]];
    [self.categoryImageView setBackgroundColor:color];
}

- (void)configureWithProduct:(Product *)product selected:(BOOL)selected
{
    self.product = product;
    [self setSelected:selected];
}

- (void)setUsed:(BOOL)used
{
    UIColor *borderColor = used ? [UIColor colorWithHexString:kGrayColor] : [UIColor colorWithHexString:kWhiteColor];
    self.categoryImageView.layer.borderColor = borderColor.CGColor;
}

- (void)configureCell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.layer.borderColor = [UIColor colorWithHexString:kWhiteColor].CGColor;
    imageView.layer.cornerRadius = self.bounds.size.height / 2.0;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1.0;
    imageView.clipsToBounds = YES;
    
    [self.contentView addSubview:imageView];
    self.categoryImageView = imageView;
}

@end
