//
//  CategoriesViewController.m
//  iMojiMaker
//
//  Created by Lucky on 5/3/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import "CategoriesViewController.h"
#import "CategoriesCollectionViewCell.h"
#import <AdMobServices/AdMobServices.h>

@interface CategoriesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) NSArray<Product *> *productsData;
@property (nonatomic, strong) NSArray *usedCategories;
@end

@implementation CategoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureAppearance];
    
    self.selectedIndex = NSNotFound;
    [self registerCellReuseIndentifier];
}

- (void)configureAppearance
{
    [self.collectionView setBackgroundColor:[UIColor colorWithHexString:kProductNormalColor]];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated
{
    NSInteger numberOfRows = [self.collectionView numberOfItemsInSection:0];
    NSInteger targetRow = (row >= numberOfRows) ? numberOfRows - 1 : row;
    [self scrollToCategoryAtIndex:targetRow animated:animated];
}

- (void)configureWithProducts:(NSArray<Product *> *)products
{
    self.productsData = products;
}

- (void)reloadContentDataWithUsedCategories:(NSArray *)usedCategories;
{
    self.usedCategories = usedCategories;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.productsData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = self.productsData[indexPath.row];
    CategoriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CategoriesCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    [cell configureWithProduct:product selected:(indexPath.row == self.selectedIndex)];
    [cell setUsed:[self.usedCategories containsObject:product.productName]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedIndex) return;
    
    [self.delegate categoriesViewController:self didSelectCategoryAtIndex:indexPath.row];
    self.selectedIndex = indexPath.row;

    [AdMobService presentInterstitial];
}

- (void)registerCellReuseIndentifier
{
    [self.collectionView registerClass:[CategoriesCollectionViewCell class] forCellWithReuseIdentifier:[CategoriesCollectionViewCell reuseIdentifier]];
}

- (void)scrollToCategoryAtIndex:(NSInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

@end
