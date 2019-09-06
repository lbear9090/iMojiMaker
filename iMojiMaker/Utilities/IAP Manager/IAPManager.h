//
//  IAPManager.h
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Configurations.h"
#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

extern NSString *const IAPManagerOpenShopNotification;
extern NSString *const IAPManagerPurchaseCompleteNotification;
extern NSString *const IAPManagerPurchaseCanceledNotification;
extern NSString *const IAPManagerPurchasesRestoredNotification;

@interface IAPManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
}

@property (nonatomic, readonly) BOOL hasBeenRestored;

+ (IAPManager *)sharedManager;

- (BOOL)isProductInstalledWithSKU:(NSString *)sku;
- (BOOL)isReadyForPurchasing;

- (void)installProductWithSKU:(NSString *)sku;
- (void)purchaseProductWithSKU:(NSString *)sku;
- (void)restorePurchases;

- (SKProduct *)productForSKU:(NSString *)sku;

@end
