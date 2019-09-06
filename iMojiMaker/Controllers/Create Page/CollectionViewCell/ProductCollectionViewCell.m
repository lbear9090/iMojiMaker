//
//  ProductCollectionViewCell.m
//  iMojiMaker
//
//  Created by Lucky on 5/8/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ProductCollectionViewCell.h"

CGFloat const kProductLockImageInset = 10.0;
NSString *const kProductLockImageName = @"MainLock";

@interface ProductCollectionViewCell ()
@end

@implementation ProductCollectionViewCell

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

- (void)configureCell
{
    
}

- (void)configureWithProductData:(ProductData *)productData
{
    
}

- (void)configureBackgroundWithImagePath:(NSString *)backgroundImagePath;
{
    
}

@end
