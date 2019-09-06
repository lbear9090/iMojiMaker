//
//  MMiMojiKeyboardViewController.m
//  Keyboard
//
//  Created by Lucky on 6/15/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMURLOpen.h"
#import "UIColor+Hex.h"
#import "MMDeleteTool.h"
#import "ContentLoader.h"
#import "MMAudioManager.h"
#import "Configurations.h"
#import "MMKeyboardState.h"
#import "MMDesignableView.h"
#import "MMToolbarRotator.h"
#import "MMKeyboardDesign.h"
#import "MMSharedContainer.h"
#import "NotificationPresenter.h"
#import "MMToolbarViewController.h"
#import "MMiMojiKeyboardViewController.h"
#import "MMiMojiKeyboardCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSString *const kMMiMojiKeyboardStoryboardName = @"MMStoryboard";

static CGFloat const kMMStickerCollectionViewCellWidth = 60.0;
static CGFloat const kMMStickerCollectionViewCellHeight = 60.0;
static CGSize const kMMStickerCollectionViewCellSize = {kMMStickerCollectionViewCellWidth, kMMStickerCollectionViewCellHeight};

@interface MMiMojiKeyboardViewController () <MMToolbarViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *openApplicationButton;
@property (nonatomic, weak) IBOutlet UIView *actionsContainerView;
@property (nonatomic, weak) IBOutlet UIView *actionsBottomSeparatorView;
@property (nonatomic, weak) MMToolbarViewController *toolbarController;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<ProductData *> *contentArray;
@property (nonatomic, strong) MMDeleteTool *deleteTool;
@property (nonatomic, strong) MMDesignableView *view;
@end

@implementation MMiMojiKeyboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerCellReuseIndentifier];
    
    [self performSelector:@selector(showFullAccessNotificationIfNeeded) withObject:nil afterDelay:.1f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureAppearance];
    [self reloadContent];
}

- (void)configureAppearance
{
    [self.toolbarController configureAppearance];
    
    MMToolbarButtonContentMap *toolbarButtonContentMap = [MMToolbarRotator buttonContentMapForToolbarWidth:self.view.frame.size.width];
    [self.toolbarController updateButtonContentWithContentMap:toolbarButtonContentMap];
    
    MMKeyboardDesign *keyboardDesign = [MMKeyboardDesign sharedDesign];
    
    [self.view setBackgroundColor:keyboardDesign.backgroundColor];
    [self.view setBackgroundImage:keyboardDesign.backgroundImage];
    [self.view setBackgroundGradient:keyboardDesign.backgroundGradient];
    
    self.actionsContainerView.backgroundColor = keyboardDesign.backgroundColor;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[MMToolbarViewController segueIdentifier]])
    {
        self.toolbarController = segue.destinationViewController;
        self.toolbarController.delegate = self;
    }
}

- (void)setView:(MMDesignableView *)view
{
    super.view = view;
}

- (MMDesignableView *)view
{
    return (MMDesignableView *)super.view;
}

- (NSMutableArray<ProductData *> *)contentArray
{
    if (!_contentArray)
    {
        _contentArray = [[NSMutableArray alloc] init];
    }
    
    return _contentArray;
}

- (MMDeleteTool *)deleteTool
{
    if (!_deleteTool)
    {
        _deleteTool = [[MMDeleteTool alloc] init];
    }
    
    return _deleteTool;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        [self.collectionView reloadData];
    }];
}

+ (NSString *)storyboardIdentifier
{
    return NSStringFromClass([MMiMojiKeyboardViewController class]);
}

+ (BOOL)canInstantiateFromStoryboard
{
    return YES;
}

- (void)toolbarViewController:(MMToolbarViewController *)controller touchDownButtonWithType:(kMMToolbarButtonType)type
{
    switch (type)
    {
        case kMMToolbarButtonTypeBackspace:
        {
            [self.deleteTool deleteBeginHoldDown:self.containerController];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)toolbarViewController:(MMToolbarViewController *)controller touchUpButtonWithType:(kMMToolbarButtonType)type
{
    [MMAudioManager playClickSound];
    
    switch (type)
    {
        case kMMToolbarButtonTypeSpace:
        {
            [self.containerController.textDocumentProxy insertText:@" "];
            break;
        }
        case kMMToolbarButtonTypeReturn:
        {
            [self.containerController.textDocumentProxy insertText:@"\n"];
            break;
        }
        case kMMToolbarButtonTypeBackspace:
        {
            [self.deleteTool deleteEndHoldDown:self.containerController];
            break;
        }
        case kMMToolbarButtonTypeNextKeyboard:
        {
            [self.containerController advanceToNextInputMode];
            break;
        }
        case kMMToolbarButtonTypeChangeContent:
        {
            [self.containerController setKeyboardType:kMMKeyboardTypeKeys];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)toolbarViewController:(MMToolbarViewController *)controller willLayoutViewWithSize:(CGSize)viewSize
{
    self.toolbarHeightConstraint.constant = [MMToolbarRotator toolbarHeightForToolbarWith:viewSize.width];
    
    if ([self.toolbarController shouldUpdateButtonContentMapForViewSize:viewSize])
    {
        [self.toolbarController updateButtonContentWithContentMap:[MMToolbarRotator buttonContentMapForToolbarWidth:viewSize.width]];
        MMToolbarLayoutMap *spacingMap = [MMToolbarRotator spacingMapForToolbarWith:viewSize.width];
        [self.toolbarController adaptConstraintsForSpacingMap:spacingMap];
        
        [self.view setNeedsUpdateConstraints];
    }
}

- (void)registerCellReuseIndentifier
{
    [self.collectionView registerClass:[MMiMojiKeyboardCollectionViewCell class] forCellWithReuseIdentifier:[MMiMojiKeyboardCollectionViewCell reuseIdentifier]];
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
    NSInteger numberOfCellsPerRow = collectionViewWidth / kMMStickerCollectionViewCellSize.width;
    CGFloat totalCellWidth = kMMStickerCollectionViewCellSize.width * numberOfCellsPerRow;
    CGFloat inset = (collectionViewWidth - totalCellWidth) / (numberOfCellsPerRow + 1);
    
    return UIEdgeInsetsMake(0.0, inset, 0.0, inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return kMMStickerCollectionViewCellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [MMiMojiKeyboardCollectionViewCell reuseIdentifier];
    MMiMojiKeyboardCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ProductData *productData = self.contentArray[indexPath.row];
    [collectionViewCell configureWithProductData:productData];
    
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([MMSharedContainer isAllowedAccessToSharedContainer])
    {
        ProductData *productData = self.contentArray[indexPath.row];
        CFStringRef type = productData.isAnimated ? kUTTypeGIF : kUTTypePNG;

        [self copyData:[productData loadImageData] type:type];
    }
    else
    {
        [self showFullAccessNotificationWithCompletionHandler:nil];
    }
}

- (void)copyData:(NSData *)data type:(CFStringRef)type
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:data forPasteboardType:(__bridge NSString *)type];
    
    [NotificationPresenter showNotificationInView:self.view
                                             type:kNotificationTypeSuccess
                                            title:kNotificationTitleCopied
                                          message:kNotificationMessageCopied
                                     dismissDelay:2.0
                                  completionBlock:nil];
}

- (IBAction)shareButtonAction:(id)sender
{
    [self.containerController.textDocumentProxy insertText:kApplicationUrl];
}

- (IBAction)openApplicationButtonAction:(id)sender
{
    NSURL *containerApplicationURL = [NSURL URLWithString:kApplicationDeepLink];
    [MMURLOpen openURLWithResponder:self url:containerApplicationURL];
}

- (void)showFullAccessNotificationWithCompletionHandler:(dispatch_block_t)completionBlock
{
    [NotificationPresenter showNotificationInView:self.view
                                             type:kNotificationTypeInfo
                                            title:kNotificationTitleRequest
                                          message:kNotificationMessageRequest
                                     dismissDelay:2.0
                                  completionBlock:completionBlock];
}

- (void)showFullAccessNotificationIfNeeded
{
    MMKeyboardState *keyboardState = [MMKeyboardState instance];
    
    if (![MMSharedContainer isAllowedAccessToSharedContainer])
    {
        if (!keyboardState.didShowLimitedAccessNotification)
        {
            [self showFullAccessNotificationWithCompletionHandler:^
            {
                keyboardState.didShowLimitedAccessNotification = YES;
                [keyboardState saveState];
            }];
        }
    }
}

@end
