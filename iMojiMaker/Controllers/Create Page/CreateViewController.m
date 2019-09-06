//
//  CreateViewController.m
//  iMojiMaker
//
//  Created by Lucky on 4/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import "IAPManager.h"
#import "LoadingView.h"
#import "ShareButton.h"
#import "ContentManager.h"
#import "UIView+Snapshot.h"
#import "GestureHandlerView.h"
#import "CreateContainerView.h"
#import "AdjustViewController.h"
#import "CreateViewController.h"
#import "NotificationPresenter.h"
#import "ContainerBackgroundView.h"
#import "CategoriesViewController.h"
#import "UIViewController+Extension.h"
#import <AdMobServices/AdMobServices.h>
#import "ProductStaticCollectionViewCell.h"
#import "ProductAnimatedCollectionViewCell.h"

@interface CreateViewController () <CategoriesViewControllerDelegate, ContainerBackgroundViewDelegate, AdjustViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) CategoriesViewController *categoriesViewController;
@property (nonatomic, weak) IBOutlet ContainerBackgroundView *containerBackgroundView;
@property (nonatomic, weak) IBOutlet CreateContainerView *createContainerView;
@property (nonatomic, weak) IBOutlet GestureHandlerView *gestureHandlerView;
@property (nonatomic, weak) IBOutlet UIView *categoriesTopSeparatorView;
@property (nonatomic, weak) IBOutlet UIView *categoriesBottomSeparatorView;
@property (nonatomic, weak) IBOutlet UIView *actionsTopSeparatorView;
@property (nonatomic, weak) IBOutlet UIView *productContentContainerView;
@property (nonatomic, weak) IBOutlet UIView *productActionsContainerView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet ShareButton *shareButton;
@property (nonatomic, strong) NSMutableDictionary *selectedProducts;
@property (nonatomic, strong) NSArray<Product *> *productsData;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) Product *product;
@end

@implementation CreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = applicationName();
    self.containerBackgroundView.delegate = self;
    
    [self registerForBuyNotifications];
    [self registerCellReuseIndentifier];
    
    [self.categoriesViewController configureWithProducts:self.productsData];
    [self.categoriesViewController selectRow:0 animated:NO];
    
    [self.createContainerView addProductData:self.productsData[0].productData[0]];

    [AdMobService presentInterstitial];
}

- (void)dealloc
{
    [self unregisterForBuyNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureNavigationAppearence];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.gestureHandlerView setFrame:self.createContainerView.frame];
}

- (void)configureAppearance
{
    [super configureAppearance];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonItem];
    
    [self.shareButton configureShare];
    
    self.actionsTopSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    self.categoriesTopSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    self.categoriesBottomSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    self.productActionsContainerView.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
    self.productContentContainerView.backgroundColor = [UIColor colorWithHexString:kProductNormalColor];
    
    self.categoryTitleLabel.textColor = [UIColor colorWithHexString:kGrayColor];
    self.categoryTitleLabel.font = [UIFont odinRoundedBoldWithSize:self.categoryTitleLabel.font.pointSize];
    
    [self configureNavigationAppearence];
}

- (void)configureNavigationAppearence
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont odinRoundedRegularWithSize:28],
                                                           NSForegroundColorAttributeName : [UIColor colorWithHexString:kBlueColor]}];
}

- (UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
    item.tintColor = [UIColor redColor];
    
    return item;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"MainAdjust"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"MainAdjustX"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemAction
{
    NSArray<ProductData *> *usedProductsData = [self usedProductsData];
    NSArray<CreateContainerModelDetails *> *usedProductsDetails = [self productsDetailsForProductsData:usedProductsData];
    
    NavigationController *navigationController = [AdjustViewController loadEmbedInNavigationController];
    AdjustViewController *adjustViewController = (AdjustViewController *)navigationController.rootViewController;
    adjustViewController.placeholderImage = [self.createContainerView snapshot];
    adjustViewController.productsDetails = usedProductsDetails;
    adjustViewController.productsData = usedProductsData;
    adjustViewController.delegate = self;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (NSArray<Product *> *)productsData
{
    if (!_productsData)
    {
        _productsData = [[NSArray alloc] initWithArray:[Products products]];
    }
    
    return _productsData;
}

- (NSMutableDictionary *)selectedProducts
{
    if (!_selectedProducts)
    {
        _selectedProducts = [[NSMutableDictionary alloc] init];
        [_selectedProducts setObject:self.productsData[0].productData[0] forKey:@(0)];
    }
    
    return _selectedProducts;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.categoriesViewController = segue.destinationViewController;
    self.categoriesViewController.delegate = self;
}

- (void)registerCellReuseIndentifier
{
    [self.collectionView registerClass:[ProductStaticCollectionViewCell class] forCellWithReuseIdentifier:[ProductStaticCollectionViewCell reuseIdentifier]];
    [self.collectionView registerClass:[ProductAnimatedCollectionViewCell class] forCellWithReuseIdentifier:[ProductAnimatedCollectionViewCell reuseIdentifier]];
}

- (void)categoriesViewController:(CategoriesViewController *)controller didSelectCategoryAtIndex:(NSInteger)index
{
    self.product = self.productsData[index];
    self.categoryTitleLabel.text = self.product.productName.uppercaseString;
    
    [self loadProductDataWithScrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.product.productData.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductData *productData = self.product.productData[indexPath.row];
    if (productData.isLocked)
    {
        [[IAPManager sharedManager] purchaseProductWithSKU:self.product.productIAP];
    }
    
    return !productData.isLocked;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductData *productData = self.product.productData[indexPath.row];
    NSString *reuseIdentifier = productData.isAnimated ? [ProductAnimatedCollectionViewCell reuseIdentifier] : [ProductStaticCollectionViewCell reuseIdentifier];
    ProductCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [collectionViewCell configureWithProductData:productData];
    
    if (self.product.productLayerIndex != 0)
    {
        ProductData *backgroundProductData = self.selectedProducts[@(0)];
        [collectionViewCell configureBackgroundWithImagePath:backgroundProductData.imagePath];
    }
    
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    ProductData *productData = self.product.productData[self.selectedIndex];
    
    [self.selectedProducts setObject:productData forKey:@(self.product.productLayerIndex)];
    [self.createContainerView addProductData:productData];
    
    [self configureGestureHandlerViewWithProductData:productData];
    
    [self reloadCategoriesData];
    [self reloadDeleteButtonState];
    [self reloadAdjustButtonState];
    [self reloadNavigationButtonsState];
}

- (void)configureWithProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails
{
    [self configureProductsWithProductsData:productsData];
    
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        ProductData *productData = productsData[productIndex];
        CreateContainerModelDetails *productDetails = productsDetails[productIndex];
        [self.createContainerView configureProductData:productData details:productDetails];
    }
    
    [self.createContainerView reloadSubviews];
}

- (void)configureProductsWithProductsData:(NSArray<ProductData *> *)productsData
{
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        Product *product = productsData[productIndex].product;
        NSInteger index = [self.productsData indexOfObject:product];
        
        if (index == NSNotFound) continue;

        self.productsData[index].isFlipped = product.isFlipped;
        
        if (index == self.categoriesViewController.selectedIndex)
        {
            [self loadProductDataWithScrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}

- (void)configureGestureHandlerViewWithProductData:(ProductData *)productData;
{
    GestureHandlerModel *handlerModel = [self.createContainerView handlerModelWithProductData:productData];
    [self.gestureHandlerView setHandlerModel:handlerModel];
}

- (NSArray<ProductData *> *)usedProductsData
{
    NSMutableArray *usedProducts = [NSMutableArray array];
    
    for (NSInteger productIndex = 0; productIndex < self.productsData.count; productIndex++)
    {
        Product *product = self.productsData[productIndex];
        ProductData *productData = self.selectedProducts[@(product.productLayerIndex)];
        
        if (!productData) continue;
        if (productData.product != product) continue;
        
        [usedProducts addObject:productData];
    }
    
    return usedProducts;
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

- (void)reloadProductsData
{
    _productsData = nil;
    [Products loadProducts];
}

- (void)loadProductDataWithScrollPosition:(UICollectionViewScrollPosition)scrollPosition
{
    self.selectedIndex = NSNotFound;
    
    [self reloadCategoriesData];
    [self reloadDeleteButtonState];
    [self reloadAdjustButtonState];
    [self reloadNavigationButtonsState];
    
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero];
    
    if (![self.selectedProducts.allKeys containsObject:@(self.product.productLayerIndex)]) return;
    
    ProductData *productData = self.selectedProducts[@(self.product.productLayerIndex)];
    
    if (![self.product.productData containsObject:productData]) return;
    
    [self configureGestureHandlerViewWithProductData:productData];

    self.selectedIndex = [self.product.productData indexOfObject:productData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectedIndex inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:scrollPosition];
    
    [self reloadNavigationButtonsState];
}

- (void)reloadCategoriesData
{
    NSMutableArray *usedCategories = [NSMutableArray array];
    NSArray *selectedProductsKeys = self.selectedProducts.allKeys;
    
    for (NSInteger keyIndex = 0; keyIndex < selectedProductsKeys.count; keyIndex++)
    {
        NSInteger key = [selectedProductsKeys[keyIndex] integerValue];
        
        if (key == 0) continue;
        
        ProductData *productData = self.selectedProducts[@(key)];
        [usedCategories addObject:productData.product.productName];
    }
    
    [self.categoriesViewController reloadContentDataWithUsedCategories:usedCategories];
}

- (void)reloadAdjustButtonState
{
    self.navigationItem.rightBarButtonItem.enabled = (self.selectedProducts.allKeys.count > 1);
}

- (void)reloadDeleteButtonState
{
    NSInteger layerIndex = self.product.productLayerIndex;
    
    if ([self.selectedProducts.allKeys containsObject:@(layerIndex)] && layerIndex != 0)
    {
        self.deleteButton.enabled = [self.product.productData containsObject:self.selectedProducts[@(layerIndex)]];
    }
    else
    {
        self.deleteButton.enabled = NO;
    }
}

- (void)reloadNavigationButtonsState
{
    NSInteger productsCount = self.product.productData.count - 1;
    self.previousButton.hidden = ((self.selectedIndex == NSNotFound) || (self.selectedIndex == 0));
    self.nextButton.hidden = ((self.selectedIndex == NSNotFound) || (self.selectedIndex == productsCount));
}

- (IBAction)previousButtonAction:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex - 1 inSection:0];
    
    if (![self collectionView:self.collectionView shouldSelectItemAtIndexPath:indexPath]) return;
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

- (IBAction)nextButtonAction:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex + 1 inSection:0];
    
    if (![self collectionView:self.collectionView shouldSelectItemAtIndexPath:indexPath]) return;
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

- (IBAction)saveButtonAction:(id)sender
{
    [LoadingView show];
    
    [self performSelector:@selector(performSaveContent) withObject:nil afterDelay:0.25];
}

- (IBAction)shareButtonAction:(id)sender
{
    [LoadingView show];
    
    [self performSelector:@selector(performSaveTemporaryContent) withObject:nil afterDelay:0.25];
}

- (IBAction)deleteButtonAction:(id)sender
{
    ProductData *productData = self.selectedProducts[@(self.product.productLayerIndex)];
    NSInteger productIndex = [self.product.productData indexOfObject:productData];
    
    [self.createContainerView removeProductData:productData];
    [self.selectedProducts removeObjectForKey:@(self.product.productLayerIndex)];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:productIndex inSection:0];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.selectedIndex = NSNotFound;
    
    [self reloadCategoriesData];
    [self reloadAdjustButtonState];
    [self reloadDeleteButtonState];
    [self reloadNavigationButtonsState];
}

- (void)registerForBuyNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(purchaseCompleted:) name:IAPManagerPurchaseCompleteNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(purchaseCompleted:) name:IAPManagerPurchasesRestoredNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(purchaseCanceled:) name:IAPManagerPurchaseCanceledNotification object:nil];
}

- (void)unregisterForBuyNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:IAPManagerPurchaseCompleteNotification object:nil];
    [notificationCenter removeObserver:self name:IAPManagerPurchaseCanceledNotification object:nil];
    [notificationCenter removeObserver:self name:IAPManagerPurchasesRestoredNotification object:nil];
}

- (void)purchaseCompleted:(NSNotification *)notification
{
    [self reloadProductsData];
    
    NSInteger index = self.categoriesViewController.selectedIndex;
    [self categoriesViewController:self.categoriesViewController didSelectCategoryAtIndex:index];
}

- (void)purchaseCanceled:(NSNotification *)notification
{
    NSLog(@"Purchase Canceled : %@",notification);
}

- (void)performSaveContent
{
    NSArray<ProductData *> *productsData = [self usedProductsData];
    NSArray<CreateContainerModelDetails *> *productsDetails = [self productsDetailsForProductsData:productsData];
    
    [ContentManager saveContentWithProductsData:productsData productsDetails:productsDetails completionBlock:^(NSString *smallFilePath, NSString *mediumFilePath, NSString *bigFilePath)
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
    NSArray<ProductData *> *productsData = [self usedProductsData];
    NSArray<CreateContainerModelDetails *> *productsDetails = [self productsDetailsForProductsData:productsData];
    
    [ContentManager saveTemporaryContentWithProductsData:productsData productsDetails:productsDetails completionBlock:^(NSString *smallFilePath, NSString *mediumFilePath, NSString *bigFilePath)
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
