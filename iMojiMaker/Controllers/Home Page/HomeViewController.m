//
//  HomeViewController.m
//  iMojiMaker
//
//  Created by Lucky on 4/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "HomeButton.h"
#import "AnimatedImage.h"
#import "ContentLoader.h"
#import "FAQViewController.h"
#import "HomeViewController.h"
#import "ShopViewController.h"
#import "ShareViewController.h"
#import "CreateViewController.h"
#import "RandomViewController.h"
#import "SettingsViewController.h"
#import "HomeCollectionViewCell.h"
#import "UIViewController+Extension.h"

NSInteger const kContentDefaultCount = 18;

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *logoLabel;
@property (nonatomic, weak) IBOutlet UIButton *settingsButton;
@property (nonatomic, weak) IBOutlet HomeButton *createButton;
@property (nonatomic, weak) IBOutlet HomeButton *randomButton;
@property (nonatomic, weak) IBOutlet HomeButton *shopButton;
@property (nonatomic, weak) IBOutlet HomeButton *moreButton;
@property (nonatomic, weak) IBOutlet HomeButton *enableKeyboardButton;
@property (nonatomic, weak) IBOutlet AnimatedImageView *randomGIF;
@property (nonatomic, strong) NSMutableArray<ProductData *> *contentArray;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.logoLabel.text = applicationName();
    
    [self registerCellReuseIndentifier];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HomeMoreGif.gif" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.randomGIF.animatedImage = [AnimatedImage animatedImageWithGIFData:data];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadContent];
}

- (void)configureAppearance
{
    [super configureAppearance];
    
    self.logoLabel.font = [UIFont odinRoundedRegularWithSize:40];
    self.logoLabel.textColor = [UIColor colorWithHexString:kBlueColor];
    
    [self.settingsButton setTintColor:[UIColor colorWithHexString:kLightGrayColor]];
    
    [self.createButton configureHomeNewButton];
    [self.randomButton configureHomeButton];
    [self.shopButton configureHomeButton];
    [self.moreButton configureHomeButton];
    
    [self.enableKeyboardButton configureHomeEnableKeyboardButton];
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:kProductNormalColor];
}

- (NSMutableArray<ProductData *> *)contentArray
{
    if (!_contentArray)
    {
        _contentArray = [[NSMutableArray alloc] init];
    }
    
    return _contentArray;
}

- (IBAction)settingsAction:(id)sender
{
    NavigationController *navigationController = [SettingsViewController loadEmbedInNavigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)createAction:(id)sender
{
    NavigationController *navigationController = [CreateViewController loadEmbedInNavigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)randomAction:(id)sender
{
    NavigationController *navigationController = [RandomViewController loadEmbedInNavigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)shopAction:(id)sender
{
    NavigationController *navigationController = [ShopViewController loadEmbedInNavigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)moreAction:(id)sender
{
    [self presentMoreAppsController];
}

- (IBAction)faqAction:(id)sender
{
    NavigationController *navigationController = [FAQViewController loadEmbedInNavigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)enableKeyboardAction:(id)sender
{
    NSURL *keyboardSettingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:keyboardSettingsURL options:@{} completionHandler:nil];
}

- (void)registerCellReuseIndentifier
{
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:[HomeCollectionViewCell reuseIdentifier]];
}

- (void)reloadContent
{
    [self.contentArray removeAllObjects];
    [self.contentArray addObjectsFromArray:[ContentLoader loadProductsWithSize:kProductsSizeSmall]];
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX(kContentDefaultCount, self.contentArray.count);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [HomeCollectionViewCell reuseIdentifier];
    HomeCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ProductData *productData = (indexPath.row < self.contentArray.count) ? self.contentArray[indexPath.row] : nil;
    [collectionViewCell configureWithProductData:productData];
    
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareViewController *shareViewController = [ShareViewController loadFromStoryboardWithBlur];
    shareViewController.productData = self.contentArray[indexPath.row];
    [self presentViewController:shareViewController animated:YES completion:nil];
}

@end
