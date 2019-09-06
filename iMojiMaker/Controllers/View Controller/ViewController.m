//
//  ViewController.m
//  iMojiMaker
//
//  Created by Lucky on 4/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>

@interface ViewController () <SKStoreProductViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureAppearance];
}

- (void)configureAppearance
{
    self.view.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
}

- (void)presentMoreAppsController
{
    NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier : @(kItunesArtistId)};
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    storeViewController.delegate = self;
    [storeViewController loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error)
    {
        if (error)
        {
            NSLog(@"SKStoreProductViewController: %@", error);
        }
    }];
    
    [self presentViewController:storeViewController animated:YES completion:nil];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
