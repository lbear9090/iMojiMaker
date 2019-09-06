//
//  IAPManager.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import "IAPManager.h"

#ifdef Application
#import "AppDelegate.h"
#import "LoadingView.h"
#import <AdMobServices/AdMobServices.h>
#endif

NSString *const IAPManagerOpenShopNotification = @"IAPManagerOpenShopNotification";
NSString *const IAPManagerPurchaseCompleteNotification = @"IAPManagerPurchaseCompleteNotification";
NSString *const IAPManagerPurchaseCanceledNotification = @"IAPManagerPurchaseCanceledNotification";
NSString *const IAPManagerPurchasesRestoredNotification = @"IAPManagerPurchasesRestoredNotification";

NSString *const IAPHasBeenRestoredKey = @"_NSUSERDEFAULTS_HasBeenRestored";
NSString *const ProductSKUKey = @"sku";

@interface IAPManager ()
@property (nonatomic, retain) NSMutableSet *skus;
@property (nonatomic, retain) SKProductsRequest *myProdRequest;
@property (nonatomic, retain) NSArray *purchasableProducts;
@property (nonatomic, readwrite) BOOL hasBeenRestored;
@property (nonatomic, retain) NSDictionary *producToBePurchased;
@end


@implementation IAPManager
@synthesize hasBeenRestored = _hasBeenRestored;

static IAPManager *sharedManager = nil;

+ (IAPManager *)sharedManager
{
    if (sharedManager == nil)
    {
        sharedManager = [[IAPManager alloc] init];
    }
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self prepareProducts];
    }
    return self;
}


- (void)dealloc
{
    _skus = nil;
    _myProdRequest = nil;
    _purchasableProducts = nil;
    _producToBePurchased = nil;
}

- (NSMutableSet *)skus
{
    if (nil != _skus)
    {
        return _skus;
    }
    
    NSArray *loadedSKUs = [[NSUserDefaults standardUserDefaults] arrayForKey:@"SKUs"];
    if (loadedSKUs)
    {
        _skus = [NSMutableSet setWithArray:loadedSKUs];
    }
    else
    {
        _skus = [[NSMutableSet alloc] init];
    }
    
    return _skus;
}

- (BOOL)hasBeenRestored
{
    if (YES == _hasBeenRestored)
    {
        return _hasBeenRestored;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _hasBeenRestored = [userDefaults boolForKey:IAPHasBeenRestoredKey];
    
    return _hasBeenRestored;
}

- (void)setHasBeenRestored:(BOOL)hasBeenRestored
{
    if (hasBeenRestored == _hasBeenRestored)
    {
        return;
    }
    
    _hasBeenRestored = hasBeenRestored;
    [[NSUserDefaults standardUserDefaults] setBool:_hasBeenRestored forKey:IAPHasBeenRestoredKey];
}


- (BOOL)isProductInstalledWithSKU:(NSString *)sku
{
    return [self.skus containsObject:sku];
}


- (BOOL)isReadyForPurchasing
{
    return [SKPaymentQueue canMakePayments] && self.purchasableProducts != nil;
}


- (void)installProductWithSKU:(NSString *)sku
{
    [self.skus addObject:sku];
    
    [[NSUserDefaults standardUserDefaults] setObject:[self.skus allObjects] forKey:@"SKUs"];
    
    sku = (nil == sku) ? @"" : sku;
    NSDictionary *userInfo = @{@"SKU" : sku};
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPManagerPurchaseCompleteNotification
                                                        object:nil
                                                      userInfo:userInfo];
    
#ifdef Application
    [AdMobService disableAds];
    [LoadingView hide];
#endif
}


- (void)purchaseProductWithSKU:(NSString *)sku
{
    if (!isInternetReachable())
    {
        [self showInternetRequiredPopup];
        return;
    }
    
    BOOL productsAreNotReady = (nil == self.purchasableProducts) || (0 == [self.purchasableProducts count]);
    if (productsAreNotReady)
    {
        self.producToBePurchased = @{ProductSKUKey:sku};
        return;
    }
    
#ifdef Application
    [LoadingView show];
#endif
    
    SKProduct *purchasedProduct = [self productForSKU:sku];
    if (nil == purchasedProduct)
    {
        NSLog(@"The product id was not found in plist file, or apple did not provide the products yet");
        return;
    }
    SKPayment *payment = [SKPayment paymentWithProduct:purchasedProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restorePurchases
{
    if (!isInternetReachable())
    {
        [self showInternetRequiredPopup];
        return;
    }
    
#ifdef Application
    [LoadingView show];
#endif
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (SKProduct *)productForSKU:(NSString *)sku
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productIdentifier = %@", sku];
    NSArray *productsFound = [self.purchasableProducts filteredArrayUsingPredicate:predicate];
    
    if ([productsFound count] == 1)
    {
        return [productsFound lastObject];
    }
    
    return nil;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.purchasableProducts = [response products];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPManagerOpenShopNotification object:nil];
    if (nil != self.producToBePurchased)
    {
        NSString *productSKU = self.producToBePurchased[ProductSKUKey];
        self.producToBePurchased = nil;
        [self purchaseProductWithSKU:productSKU];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"Purchasing");
                break;
            }
            case SKPaymentTransactionStatePurchased:
            {
                [self installProductWithSKU:transaction.payment.productIdentifier];
                [queue finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:
            {
                [self failedTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored:
            {
                [self installProductWithSKU:transaction.payment.productIdentifier];
                [queue finishTransaction:transaction];
                break;
            }
            default:
            {
                NSLog(@"%ld", (long)transaction.transactionState);
                break;
            }
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPManagerPurchaseCanceledNotification object:nil];
    
#ifdef Application
    [LoadingView hide];
#endif
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    self.hasBeenRestored = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPManagerPurchasesRestoredNotification object:nil];
    
#ifdef Application
    [LoadingView hide];
#endif
}

- (void)prepareProducts
{
    if ([SKPaymentQueue canMakePayments])
    {
        NSSet *possibleProducts = [NSSet setWithArray:[Products productsIAP]];
        self.myProdRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:possibleProducts];
        self.myProdRequest.delegate = self;
        [self.myProdRequest start];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"IAP transaction did fail with error: %@",[transaction.error userInfo]);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPManagerPurchaseCanceledNotification object:nil];
    
#ifdef Application
    [LoadingView hide];
#endif
}


- (void)showInternetRequiredPopup
{
#ifdef Application
    NSString *alertTitle = @"Warning";
    NSString *alertMessage = @"Internet connection is required !";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    UIViewController *topController = [AppDelegate topViewController];
    [topController presentViewController:alertController animated:YES completion:nil];
#endif
}

@end
