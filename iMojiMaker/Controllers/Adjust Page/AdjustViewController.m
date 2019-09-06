//
//  AdjustViewController.m
//  iMojiMaker
//
//  Created by Lucky on 4/30/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "GestureHandlerView.h"
#import "CreateContainerView.h"
#import "AdjustViewController.h"
#import "ContainerBackgroundView.h"
#import "CategoriesViewController.h"
#import <AdMobServices/AdMobServices.h>

CGFloat const kDelayInterval = 0.25;
CGFloat const kRepeatInterval = 1.0/60.0;

CGFloat const kMoveStep = 1.0;
CGFloat const kScaleStep = 0.01;
CGFloat const kOpacityStep = 0.05;

@interface AdjustViewController () <CategoriesViewControllerDelegate, ContainerBackgroundViewDelegate>
@property (nonatomic, weak) CategoriesViewController *categoriesViewController;
@property (nonatomic, weak) IBOutlet ContainerBackgroundView *containerBackgroundView;
@property (nonatomic, weak) IBOutlet CreateContainerView *createContainerView;
@property (nonatomic, weak) IBOutlet GestureHandlerView *gestureHandlerView;
@property (nonatomic, weak) IBOutlet UIImageView *placeholderImageView;
@property (nonatomic, weak) IBOutlet UIView *categoriesTopSeparatorView;
@property (nonatomic, weak) IBOutlet UIView *categoriesBottomSeparatorView;
@property (nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *moveUpButton;
@property (nonatomic, weak) IBOutlet UIButton *moveDownButton;
@property (nonatomic, weak) IBOutlet UIButton *moveLeftButton;
@property (nonatomic, weak) IBOutlet UIButton *moveRightButton;
@property (nonatomic, weak) IBOutlet UIButton *forwardButton;
@property (nonatomic, weak) IBOutlet UIButton *backwardButton;
@property (nonatomic, weak) IBOutlet UIButton *increaseSizeButton;
@property (nonatomic, weak) IBOutlet UIButton *decreaseSizeButton;
@property (nonatomic, weak) IBOutlet UIButton *increaseOpacityButton;
@property (nonatomic, weak) IBOutlet UIButton *decreaseOpacityButton;
@property (nonatomic, weak) IBOutlet UIButton *flipButton;
@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) ProductData *currentProductData;
@property (nonatomic, strong) NSArray<Product *> *products;
@property (nonatomic, assign) SEL adjustMovingSelector;
@property (nonatomic, assign) SEL adjustScaleSelector;
@property (nonatomic, assign) SEL adjustOpacitySelector;
@property (nonatomic, assign) kMoveDirection moveDirection;
@property (nonatomic, assign) kScaleType scaleType;
@property (nonatomic, assign) kOpacityType opacityType;
@end

@implementation AdjustViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Adjust";
    self.containerBackgroundView.delegate = self;
    self.placeholderImageView.image = self.placeholderImage;
    
    [self configureButtonsActions];
    
    self.products = [self convertProductsData:self.productsData];
    [self.categoriesViewController configureWithProducts:self.products];
    [self.categoriesViewController selectRow:self.products.count animated:NO];

    [AdMobService presentInterstitial];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.gestureHandlerView setFrame:self.createContainerView.frame];
    [self addProductsData:self.productsData productsDetails:self.productsDetails];
    
    NSInteger selectedIndex = self.categoriesViewController.selectedIndex;
    ProductData *productData = self.productsData[selectedIndex];
    [self configureGestureHandlerViewWithProductData:productData];
    
    [self.placeholderImageView setHidden:YES];
}

- (void)configureAppearance
{
    [super configureAppearance];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonItem];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont odinRoundedRegularWithSize:20]}];
    
    self.categoriesTopSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    self.categoriesBottomSeparatorView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    
    self.categoryTitleLabel.textColor = [UIColor colorWithHexString:kGrayColor];
    self.categoryTitleLabel.font = [UIFont odinRoundedBoldWithSize:self.categoryTitleLabel.font.pointSize];
}

- (void)configureButtonsActions
{
    self.adjustMovingSelector = @selector(adjustMoving);
    self.adjustScaleSelector = @selector(adjustScale);
    self.adjustOpacitySelector = @selector(adjustOpacity);
    
    [self.moveUpButton addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventTouchDown];
    [self.moveDownButton addTarget:self action:@selector(moveDown) forControlEvents:UIControlEventTouchDown];
    [self.moveLeftButton addTarget:self action:@selector(moveLeft) forControlEvents:UIControlEventTouchDown];
    [self.moveRightButton addTarget:self action:@selector(moveRight) forControlEvents:UIControlEventTouchDown];
    
    [self.forwardButton addTarget:self action:@selector(moveForward) forControlEvents:UIControlEventTouchUpInside];
    [self.backwardButton addTarget:self action:@selector(moveBackward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.increaseSizeButton addTarget:self action:@selector(increaseSize) forControlEvents:UIControlEventTouchDown];
    [self.decreaseSizeButton addTarget:self action:@selector(decreaseSize) forControlEvents:UIControlEventTouchDown];
    [self.increaseOpacityButton addTarget:self action:@selector(increaseOpacity) forControlEvents:UIControlEventTouchDown];
    [self.decreaseOpacityButton addTarget:self action:@selector(decreaseOpacity) forControlEvents:UIControlEventTouchDown];
    
    [self.flipButton addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    [self addCancelPerformSelectorToButton:self.moveUpButton];
    [self addCancelPerformSelectorToButton:self.moveDownButton];
    [self addCancelPerformSelectorToButton:self.moveLeftButton];
    [self addCancelPerformSelectorToButton:self.moveRightButton];
    [self addCancelPerformSelectorToButton:self.increaseSizeButton];
    [self addCancelPerformSelectorToButton:self.decreaseSizeButton];
    [self addCancelPerformSelectorToButton:self.increaseOpacityButton];
    [self addCancelPerformSelectorToButton:self.decreaseOpacityButton];
}

- (void)addCancelPerformSelectorToButton:(UIButton *)button
{
    [button addTarget:self action:@selector(cancelPerformSelector) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(cancelPerformSelector) forControlEvents:UIControlEventTouchUpOutside];
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
    [button setImage:[UIImage imageNamed:@"AdjustDone"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"AdjustDoneX"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemAction
{
    NSArray<CreateContainerModelDetails *> *productsDetails = [self productsDetailsForProductsData:self.productsData];
    [self.delegate configureWithProductsData:self.productsData productsDetails:productsDetails];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.categoriesViewController = segue.destinationViewController;
    self.categoriesViewController.delegate = self;
}

- (void)categoriesViewController:(CategoriesViewController *)controller didSelectCategoryAtIndex:(NSInteger)index
{
    self.currentProductData = self.productsData[index];
    [self configureGestureHandlerViewWithProductData:self.currentProductData];
    
    self.categoryTitleLabel.text = self.currentProductData.product.productName.uppercaseString;
}

- (CGFloat)containerBackgroundViewLineWidth
{
    return 1.0;
}

- (UIColor *)containerBackgroundViewDrawColor
{
    return [UIColor colorWithHexString:kLightGrayColor];
}

- (UIColor *)containerBackgroundViewBackgroundColor
{
    return [UIColor clearColor];
}

- (void)configureGestureHandlerViewWithProductData:(ProductData *)productData
{
    GestureHandlerModel *handlerModel = [self.createContainerView handlerModelWithProductData:productData];
    [self configureAdjustButtonsWithGestureHandlerModel:handlerModel];
    [self.gestureHandlerView setHandlerModel:handlerModel];
}

- (void)configureAdjustButtonsWithGestureHandlerModel:(GestureHandlerModel *)handlerModel
{
    BOOL isEnabled = handlerModel.view != nil;
    self.moveUpButton.enabled = isEnabled;
    self.moveDownButton.enabled = isEnabled;
    self.moveLeftButton.enabled = isEnabled;
    self.moveRightButton.enabled = isEnabled;
    self.forwardButton.enabled = isEnabled;
    self.backwardButton.enabled = isEnabled;
    self.increaseSizeButton.enabled = isEnabled;
    self.decreaseSizeButton.enabled = isEnabled;
    self.increaseOpacityButton.enabled = isEnabled;
    self.decreaseOpacityButton.enabled = isEnabled;
    self.flipButton.enabled = isEnabled;
    self.resetButton.enabled = isEnabled;
}

- (NSArray<Product *> *)convertProductsData:(NSArray<ProductData *> *)productsData
{
    NSMutableArray *productsArray = [NSMutableArray array];
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        ProductData *productData = productsData[productIndex];
        [productsArray addObject:productData.product];
    }
    
    return productsArray;
}

- (void)addProductsData:(NSArray<ProductData *> *)productsData productsDetails:(NSArray<CreateContainerModelDetails *> *)productsDetails
{
    for (NSInteger productIndex = 0; productIndex < productsData.count; productIndex++)
    {
        ProductData *productData = productsData[productIndex];
        CreateContainerModelDetails *productDetails = productsDetails[productIndex];
        [self.createContainerView addProductData:productData details:productDetails];
    }
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

- (void)cancelPerformSelector
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:self.adjustMovingSelector object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:self.adjustScaleSelector object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:self.adjustOpacitySelector object:nil];
}

- (void)adjustMoving
{
    [self cancelPerformSelector];
    
    [self.createContainerView moveProductDataProductData:self.currentProductData moveDirection:self.moveDirection moveStep:kMoveStep];
    [self performSelector:self.adjustMovingSelector withObject:nil afterDelay:kRepeatInterval];
}

- (void)adjustScale
{
    [self cancelPerformSelector];
    
    [self.createContainerView scaleProductDataProductData:self.currentProductData scaleType:self.scaleType scaleStep:kScaleStep];
    [self performSelector:self.adjustScaleSelector withObject:nil afterDelay:kRepeatInterval];
}

- (void)adjustOpacity
{
    [self cancelPerformSelector];
    
    [self.createContainerView opacityProductDataProductData:self.currentProductData opacityType:self.opacityType opacityStep:kOpacityStep];
    [self performSelector:self.adjustOpacitySelector withObject:nil afterDelay:kRepeatInterval];
}

- (void)moveUp
{
    self.moveDirection = kMoveDirectionUp;
    [self.createContainerView moveProductDataProductData:self.currentProductData moveDirection:self.moveDirection moveStep:kMoveStep];
    
    [self performSelector:self.adjustMovingSelector withObject:nil afterDelay:kDelayInterval];
}

- (void)moveDown
{
    self.moveDirection = kMoveDirectionDown;
    [self.createContainerView moveProductDataProductData:self.currentProductData moveDirection:self.moveDirection moveStep:kMoveStep];
    
    [self performSelector:self.adjustMovingSelector withObject:nil afterDelay:kDelayInterval];
}

- (void)moveLeft
{
    self.moveDirection = kMoveDirectionLeft;
    [self.createContainerView moveProductDataProductData:self.currentProductData moveDirection:self.moveDirection moveStep:kMoveStep];
    
    [self performSelector:self.adjustMovingSelector withObject:nil afterDelay:kDelayInterval];
}

- (void)moveRight
{
    self.moveDirection = kMoveDirectionRight;
    [self.createContainerView moveProductDataProductData:self.currentProductData moveDirection:self.moveDirection moveStep:kMoveStep];
    
    [self performSelector:self.adjustMovingSelector withObject:nil afterDelay:kDelayInterval];
}

- (void)moveForward
{
    [self.createContainerView moveProductDataProductData:self.currentProductData moveType:kMoveTypeFront];
}

- (void)moveBackward
{
    [self.createContainerView moveProductDataProductData:self.currentProductData moveType:kMoveTypeBack];
}

- (void)increaseSize
{
    self.scaleType = kScaleTypeIncrease;
    [self.createContainerView scaleProductDataProductData:self.currentProductData scaleType:self.scaleType scaleStep:kScaleStep];
    
    [self performSelector:self.adjustScaleSelector withObject:nil afterDelay:kDelayInterval];
}

- (void)decreaseSize
{
    self.scaleType = kScaleTypeDecrease;
    [self.createContainerView scaleProductDataProductData:self.currentProductData scaleType:self.scaleType scaleStep:kScaleStep];
    
    [self performSelector:self.adjustScaleSelector withObject:nil afterDelay:kDelayInterval];
}

- (void)increaseOpacity
{
    self.opacityType = kOpacityTypeIncrease;
    [self.createContainerView opacityProductDataProductData:self.currentProductData opacityType:self.opacityType opacityStep:kOpacityStep];
    
    [self performSelector:self.adjustOpacitySelector withObject:nil afterDelay:kDelayInterval];
}

- (void)decreaseOpacity
{
    self.opacityType = kOpacityTypeDecrease;
    [self.createContainerView opacityProductDataProductData:self.currentProductData opacityType:self.opacityType opacityStep:kOpacityStep];
    
    [self performSelector:self.adjustOpacitySelector withObject:nil afterDelay:kDelayInterval];
}

- (void)flip
{
    [self.createContainerView flipHorizontalForProductData:self.currentProductData];
}

- (void)reset
{
    NSString *alertTitle = @"Reset?";
    NSString *alertMessage = @"Move everything back to it's original position. Any changes you made will be lost.";
    NSString *alertCancelButtonTitle = @"Cancel";
    NSString *alertOKButtonTitle = @"OK";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:alertCancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:alertOKButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        [self.createContainerView resetDetailsForProductData:self.currentProductData];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
