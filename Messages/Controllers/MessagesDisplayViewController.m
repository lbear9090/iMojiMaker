//
//  MessagesDisplayViewController.m
//  Messages
//
//  Created by Lucky on 5/27/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ContentLoader.h"
#import "MessagesDisplayViewController.h"
#import "MessagesDisplayCollectionViewCell.h"

CGFloat const kStickerCollectionViewCellWidth = 80.0;
CGFloat const kStickerCollectionViewCellHeight = 80.0;
CGSize const kStickerCollectionViewCellSize = {kStickerCollectionViewCellWidth, kStickerCollectionViewCellHeight};

@interface MessagesDisplayViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *openApplicationButton;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *actionsContainerView;
@property (nonatomic, weak) IBOutlet UIView *actionsBottomSeparatorView;
@property (nonatomic, strong) NSMutableArray<ProductData *> *contentArray;
@end

@implementation MessagesDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerCellReuseIndentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadContent];
}

- (void)configureAppearance
{
    [super configureAppearance];
    
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.actionsContainerView.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
    self.actionsBottomSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    
    [self configureAppearanceForShareButton];
    [self configureAppearanceForOpenApplicationButton];
}

- (void)configureAppearanceForShareButton
{
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.cornerRadius = self.shareButton.frame.size.height / 2.0;
    
    [self.shareButton setBackgroundColor:[UIColor colorWithHexString:kBlueColor]];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont odinRoundedRegularWithSize:self.shareButton.titleLabel.font.pointSize];
}

- (void)configureAppearanceForOpenApplicationButton
{
    self.openApplicationButton.layer.masksToBounds = YES;
    self.openApplicationButton.layer.cornerRadius = self.shareButton.frame.size.height / 2.0;
    self.openApplicationButton.layer.borderColor = [UIColor colorWithHexString:kBlueColor].CGColor;
    self.openApplicationButton.layer.borderWidth = 1.0;
    
    [self.openApplicationButton setBackgroundColor:[UIColor clearColor]];
    [self.openApplicationButton setTitleColor:[UIColor colorWithHexString:kBlueColor] forState:UIControlStateNormal];
    self.openApplicationButton.titleLabel.font = [UIFont odinRoundedRegularWithSize:self.openApplicationButton.titleLabel.font.pointSize];
}

- (NSMutableArray<ProductData *> *)contentArray
{
    if (!_contentArray)
    {
        _contentArray = [[NSMutableArray alloc] init];
    }
    
    return _contentArray;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self.collectionView reloadData];
}

- (void)registerCellReuseIndentifier
{
    [self.collectionView registerClass:[MessagesDisplayCollectionViewCell class] forCellWithReuseIdentifier:[MessagesDisplayCollectionViewCell reuseIdentifier]];
}

- (void)reloadContent
{
    [self.contentArray removeAllObjects];
    
    [self.contentArray addObjectsFromArray:[ContentLoader loadProductsWithSize:kProductsSizeMedium]];
    [self.collectionView reloadData];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat collectionViewWidth = collectionView.frame.size.width;
    NSInteger numberOfCellsPerRow = collectionViewWidth / kStickerCollectionViewCellSize.width;
    CGFloat totalCellWidth = kStickerCollectionViewCellSize.width * numberOfCellsPerRow;
    CGFloat inset = (collectionViewWidth - totalCellWidth) / (numberOfCellsPerRow + 1);
    
    return UIEdgeInsetsMake(0.0, inset, 0.0, inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return kStickerCollectionViewCellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [MessagesDisplayCollectionViewCell reuseIdentifier];
    MessagesDisplayCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ProductData *productData = self.contentArray[indexPath.row];
    [collectionViewCell configureWithProductData:productData];
    
    return collectionViewCell;
}

- (IBAction)shareButtonAction:(id)sender
{
    [self.delegate shareApplicationFromDisplayViewController:self];
}

- (IBAction)openApplicationButtonAction:(id)sender
{
    [self.delegate openApplicationFromDisplayViewController:self];
}

@end
