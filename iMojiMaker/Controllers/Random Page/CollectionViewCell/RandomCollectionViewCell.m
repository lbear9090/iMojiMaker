//
//  RandomCollectionViewCell.m
//  iMojiMaker
//
//  Created by Lucky on 5/26/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "RandomCollectionViewCell.h"

@interface RandomCollectionViewCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) Product *product;
@end

@implementation RandomCollectionViewCell

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
    
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    [self.imageView setBackgroundColor:color];
}

- (void)configureWithProduct:(Product *)product selected:(BOOL)selected
{
    self.product = product;
    [self setSelected:selected];
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
    self.imageView = imageView;
}

@end
