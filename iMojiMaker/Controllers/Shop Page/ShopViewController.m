//
//  ShopViewController.m
//  iMojiMaker
//
//  Created by Lucky on 4/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import "IAPManager.h"
#import "ShopButton.h"
#import "ShopTableViewCell.h"
#import "ShopViewController.h"
#import <AdMobServices/AdMobServices.h>

@interface ShopViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet ShopButton *restoreButton;
@property (nonatomic, weak) IBOutlet UIView *restoreSeparatorView;
@property (nonatomic, strong) NSArray<Product *> *productsData;
@end

@implementation ShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Shop";
    
    [self registerForBuyNotifications];

    [AdMobService presentInterstitial];
}

- (void)dealloc
{
    [self unregisterForBuyNotifications];
}

- (void)configureAppearance
{
    [super configureAppearance];
    
    [self.restoreButton configureRestoreButton];
    
    self.restoreSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont odinRoundedRegularWithSize:20]}];
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

- (NSArray<Product *> *)productsData
{
    if (!_productsData)
    {
        _productsData = [[NSArray alloc] initWithArray:[Products products]];
    }
    
    return _productsData;
}

- (IBAction)restorePurchasesButtonAction:(id)sender
{
    [[IAPManager sharedManager] restorePurchases];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [ShopTableViewCell reuseIdentifier];
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Product *product = self.productsData[indexPath.row];
    [cell configureWithProduct:product];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ShopTableViewCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadProductsData
{
    _productsData = nil;
    [Products loadProducts];
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
    [self.tableView reloadData];
}

- (void)purchaseCanceled:(NSNotification *)notification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:kShopTableViewCellUpdateNotification object:nil];
}

@end
