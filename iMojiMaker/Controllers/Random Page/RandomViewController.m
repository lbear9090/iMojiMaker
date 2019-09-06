//
//  RandomViewController.m
//  iMojiMaker
//
//  Created by Lucky on 4/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "LoadingView.h"
#import "Configurations.h"
#import "ContentManager.h"
#import "RandomViewController.h"
#import "NotificationPresenter.h"
#import "ContainerBackgroundView.h"
#import "RandomCollectionViewCell.h"
#import <AdMobServices/AdMobServices.h>

CGFloat const kRandomCollectionViewCellWidth = 51.0;
CGFloat const kRandomCollectionViewCellHeight = 40.0;
CGSize const kRandomCollectionViewCellSize = {kRandomCollectionViewCellWidth, kRandomCollectionViewCellHeight};

CGFloat const kRandomCollectionViewCellMinInset = 20.0;
CGFloat const kRandomCollectionViewCellLineSpacing = 20.0;
CGFloat const kRandomCollectionViewCellInterItemSpacing = 20.0;

@interface RandomViewController () <ContainerBackgroundViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet ContainerBackgroundView *containerBackgroundView;
@property (nonatomic, weak) IBOutlet CreateContainerView *createContainerView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *actionsTopSeparatorView;
@property (nonatomic, weak) IBOutlet UIView *categoriesTopSeparatorView;
@property (nonatomic, weak) IBOutlet UIView *productActionsContainerView;
@property (nonatomic, strong) NSMutableArray<ProductData *> *usedProductsData;
@property (nonatomic, strong) NSArray<Product *> *defaultSelectedProducts;
@property (nonatomic, strong) NSArray<Product *> *requiredProducts;
@property (nonatomic, strong) NSArray<Product *> *excludedProducts;
@property (nonatomic, strong) NSArray<Product *> *productsData;
@property (nonatomic, assign) NSInteger numberOfCellsPerRow;
@end

@implementation RandomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Random";
    
    self.containerBackgroundView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    
    [self registerCellReuseIndentifier];
    [self configureSelectedIndexPaths];
    [self randomButtonAction:nil];

    [AdMobService presentInterstitial];
}

- (void)configureAppearance
{
    [super configureAppearance];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont odinRoundedRegularWithSize:20]}];
    
    self.actionsTopSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    self.categoriesTopSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    self.productActionsContainerView.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
}

- (UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
    item.tintColor = [UIColor redColor];
    
    return item;
}

- (void)leftItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)requiredProductsLayerIndex
{
    return @[@0];
}

- (NSArray *)excludedProductsLayerIndex
{
    return @[@1, @12];
}

- (NSArray *)defaultSelectedProductsLayerIndex
{
    return @[@0, @3, @4];
}

- (NSMutableArray<ProductData *> *)usedProductsData
{
    if (!_usedProductsData)
    {
        _usedProductsData = [[NSMutableArray alloc] init];
    }
    
    return _usedProductsData;
}

- (NSArray<Product *> *)defaultSelectedProducts
{
    if (!_defaultSelectedProducts)
    {
        NSArray *defaultSelectedIndexes = [self defaultSelectedProductsLayerIndex];
        _defaultSelectedProducts = [[NSArray alloc] initWithArray:[self loadProductsWithLayerIndexes:defaultSelectedIndexes]];
    }
    
    return _defaultSelectedProducts;
}

- (NSArray<Product *> *)requiredProducts
{
    if (!_requiredProducts)
    {
        NSArray *requiredIndexes = [self requiredProductsLayerIndex];
        _requiredProducts = [[NSArray alloc] initWithArray:[self loadProductsWithLayerIndexes:requiredIndexes]];
    }
    
    return _requiredProducts;
}

- (NSArray<Product *> *)excludedProducts
{
    if (!_excludedProducts)
    {
        NSArray *excludedIndexes = [self excludedProductsLayerIndex];
        _excludedProducts = [[NSArray alloc] initWithArray:[self loadProductsWithLayerIndexes:excludedIndexes]];
    }
    
    return _excludedProducts;
}

- (NSArray<Product *> *)productsData
{
    if (!_productsData)
    {
        NSMutableArray *productsArray = [NSMutableArray arrayWithArray:[Products products]];
        [productsArray removeObjectsInArray:self.excludedProducts];
        
        _numberOfCellsPerRow = NSNotFound;
        _productsData = [[NSArray alloc] initWithArray:productsArray];
    }
    
    return _productsData;
}

- (NSInteger)numberOfCellsPerRow
{
    if (_numberOfCellsPerRow != NSNotFound) return _numberOfCellsPerRow;
    
    _numberOfCellsPerRow = 0;
    
    CGFloat widthValue = kRandomCollectionViewCellMinInset;
    CGFloat cellWidth = kRandomCollectionViewCellSize.width;
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    while (widthValue <= collectionViewWidth)
    {
        widthValue += cellWidth;
        widthValue += kRandomCollectionViewCellInterItemSpacing;

        if (widthValue <= collectionViewWidth)
        {
            _numberOfCellsPerRow++;
        }
    }
    
    return _numberOfCellsPerRow;
}

- (NSArray<Product *> *)loadProductsWithLayerIndexes:(NSArray *)layerIndexes
{
    NSMutableArray *filteredProductsArray = [NSMutableArray array];
    NSArray *productsArray = [NSArray arrayWithArray:[Products products]];
    
    for (NSInteger productIndex = 0; productIndex < productsArray.count; productIndex++)
    {
        Product *product = productsArray[productIndex];
        
        if (![layerIndexes containsObject:@(product.productLayerIndex)]) continue;
        
        [filteredProductsArray addObject:product];
    }
    
    return filteredProductsArray;
}

- (void)registerCellReuseIndentifier
{
    [self.collectionView registerClass:[RandomCollectionViewCell class] forCellWithReuseIdentifier:[RandomCollectionViewCell reuseIdentifier]];
}

- (CGFloat)containerBackgroundViewLineWidth
{
    return 1.0;
}

- (UIColor *)containerBackgroundViewDrawColor
{
    UIColor *color = [UIColor colorWithHexString:kLightGrayColor];
    
    return [color colorWithAlphaComponent:0.5];
}

- (UIColor *)containerBackgroundViewBackgroundColor
{
    return [UIColor clearColor];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return kRandomCollectionViewCellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat cellWidth = kRandomCollectionViewCellSize.width;
    CGFloat collectionViewWidth = collectionView.frame.size.width;
    CGFloat totalCellWidth = cellWidth * self.numberOfCellsPerRow;
    CGFloat totalSpacingWidth = kRandomCollectionViewCellInterItemSpacing * (self.numberOfCellsPerRow - 1);
    CGFloat inset = (collectionViewWidth - (totalCellWidth + totalSpacingWidth)) / 2.0;

    return UIEdgeInsetsMake(kRandomCollectionViewCellLineSpacing, inset, kRandomCollectionViewCellLineSpacing, inset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kRandomCollectionViewCellLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kRandomCollectionViewCellInterItemSpacing;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productsData.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSSet *requiredProductsIndexPathSet = [self computeRequiredProductsIndexPathSet];
    NSSet *selectedItemsIndexPathSet = [self computeSelectedItemsIndexPathSetWithIndexPath:indexPath];

    return [requiredProductsIndexPathSet intersectsSet:selectedItemsIndexPathSet];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [RandomCollectionViewCell reuseIdentifier];
    RandomCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Product *product = self.productsData[indexPath.row];
    BOOL selected = [collectionView.indexPathsForSelectedItems containsObject:indexPath];
    [collectionViewCell configureWithProduct:product selected:selected];

    return collectionViewCell;
}

- (IBAction)saveButtonAction:(id)sender
{
    [LoadingView show];
    
    [self performSelector:@selector(performSaveContent) withObject:nil afterDelay:0.25];
}

- (IBAction)randomButtonAction:(id)sender
{
    [self removeAllUsedProductsData];
    
    NSArray *indexPaths = [self randomSelectedIndexPaths];
    
    for (NSInteger index = 0; index < indexPaths.count; index++)
    {
        NSIndexPath *indexPath = indexPaths[index];
        Product *product = self.productsData[indexPath.row];
        ProductData *productData = [self loadRandomProductDataForProduct:product];
        
        if (!productData) continue;
        
        [self.usedProductsData addObject:productData];
        [self.createContainerView addProductData:productData];
    }

    [AdMobService presentInterstitial];
}

- (IBAction)shareButtonAction:(id)sender
{
    [LoadingView show];
    
    [self performSelector:@selector(performSaveTemporaryContent) withObject:nil afterDelay:0.25];
}

- (void)configureSelectedIndexPaths
{
    if (self.collectionView.indexPathsForSelectedItems.count != 0) return;

    NSIndexSet *indexSet = [self.productsData indexesOfObjectsPassingTest:^BOOL(Product *product, NSUInteger index, BOOL *stop)
    {
        return [self.defaultSelectedProducts containsObject:product];
    }];

    [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }];
}

- (NSSet *)computeRequiredProductsIndexPathSet
{
    NSMutableSet *productsIndexPath = [NSMutableSet set];
    
    for (NSInteger index = 0; index < self.requiredProducts.count; index++)
    {
        Product *product = self.requiredProducts[index];
        NSInteger productIndex = [self.productsData indexOfObject:product];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:productIndex inSection:0];
        
        [productsIndexPath addObject:indexPath];
    }
    
    return productsIndexPath;
}

- (NSSet *)computeSelectedItemsIndexPathSetWithIndexPath:(NSIndexPath *)indexPath
{
    NSMutableSet *selectedItemsIndexPath = [NSMutableSet setWithArray:self.collectionView.indexPathsForSelectedItems];
    [selectedItemsIndexPath removeObject:indexPath];
    
    return selectedItemsIndexPath;
}

- (void)removeAllUsedProductsData
{
    if (self.usedProductsData.count == 0) return;
    
    for (NSInteger productIndex = 0; productIndex < self.usedProductsData.count; productIndex++)
    {
        ProductData *productData = self.usedProductsData[productIndex];
        [self.createContainerView removeProductData:productData];
    }
    
    [self.usedProductsData removeAllObjects];
}

- (NSArray<NSIndexPath *> *)randomSelectedIndexPaths
{
    NSMutableArray *selectedIndexPaths = [NSMutableArray array];
    NSMutableDictionary *indexPathsDictionary = [NSMutableDictionary dictionary];
    
    for (NSInteger index = 0; index < self.collectionView.indexPathsForSelectedItems.count; index++)
    {
        NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems[index];
        Product *product = self.productsData[indexPath.row];
        
        NSMutableArray *indexPathsArray = [NSMutableArray array];
        
        if ([indexPathsDictionary.allKeys containsObject:@(product.productLayerIndex)])
        {
            [indexPathsArray addObjectsFromArray:indexPathsDictionary[@(product.productLayerIndex)]];
        }
        
        [indexPathsArray addObject:indexPath];
        [indexPathsDictionary setObject:indexPathsArray forKey:@(product.productLayerIndex)];
    }
    
    for (NSInteger keyIndex = 0; keyIndex < indexPathsDictionary.allKeys.count; keyIndex++)
    {
        NSNumber *dictionaryKey = indexPathsDictionary.allKeys[keyIndex];
        NSMutableArray *indexPathsArray = [NSMutableArray arrayWithArray:indexPathsDictionary[dictionaryKey]];
        NSInteger randomProductIndex = arc4random() % indexPathsArray.count;
        [selectedIndexPaths addObject:indexPathsArray[randomProductIndex]];
    }
    
    return selectedIndexPaths;
}

- (ProductData *)loadRandomProductDataForProduct:(Product *)product
{
    NSInteger unlockedIndex = [self unlockedProductDataIndexForProduct:product];
    
    if (unlockedIndex == NSNotFound) return nil;
    
    return product.productData[unlockedIndex];
}

- (NSInteger)unlockedProductDataIndexForProduct:(Product *)product
{
    NSMutableArray *unlockedIndexes = [NSMutableArray array];
    
    for (NSInteger productIndex = 0; productIndex < product.productData.count; productIndex++)
    {
        ProductData *productData = product.productData[productIndex];
        
        if (productData.isLocked) continue;
        
        [unlockedIndexes addObject:@(productIndex)];
    }
    
    if (unlockedIndexes.count == 0) return NSNotFound;

    return arc4random() % unlockedIndexes.count;
}

- (NSArray<CreateContainerModelDetails *> *)productsDetailsForProductsData:(NSArray<ProductData *> *)productsData
{
    NSMutableArray *productsDetails = [NSMutableArray array];
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        ProductData *productData = productsData[productIndex];
        CreateContainerModelDetails *productDetails = [self.createContainerView detailsForProductData:productData];
        
        [productsDetails addObject:productDetails];
    }
    
    return productsDetails;
}

- (void)performSaveContent
{
    NSArray<CreateContainerModelDetails *> *productsDetails = [self productsDetailsForProductsData:self.usedProductsData];
    
    [ContentManager saveContentWithProductsData:self.usedProductsData productsDetails:productsDetails completionBlock:^(NSString *smallFilePath, NSString *mediumFilePath, NSString *bigFilePath)
    {
        [LoadingView hide];
        [NotificationPresenter showNotificationWithType:kNotificationTypeSuccess
                                                  title:kNotificationTitleSaved
                                                message:kNotificationMessageSaved
                                           dismissDelay:2.0
                                        completionBlock:nil];

        [AdMobService presentInterstitial];
    }];
}

- (void)performSaveTemporaryContent
{
    NSArray<CreateContainerModelDetails *> *productsDetails = [self productsDetailsForProductsData:self.usedProductsData];
    
    [ContentManager saveTemporaryContentWithProductsData:self.usedProductsData productsDetails:productsDetails completionBlock:^(NSString *smallFilePath, NSString *mediumFilePath, NSString *bigFilePath)
    {
        NSData *contentData = [NSData dataWithContentsOfFile:bigFilePath];
        NSArray *activityItems = @[contentData];
        
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:^
        {
            [LoadingView hide];
        }];
    }];
}

@end
