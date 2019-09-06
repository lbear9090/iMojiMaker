//
//  FAQViewController.m
//  iMojiMaker
//
//  Created by Lucky on 4/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leftInsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightInsetConstraint;
@end

@implementation FAQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"F.A.Q.";
    
    [self loadFAQContent];
}

- (void)configureAppearance
{
    [super configureAppearance];
    
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:kGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:kBlueColor];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = round(scrollView.contentOffset.x / scrollView.frame.size.width);
}

- (void)changePage:(UIPageControl *)pageControl
{
    CGFloat origin = pageControl.currentPage * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(origin, 0) animated:YES];
}

- (void)loadFAQContent
{
    NSArray *filePaths = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:@"FAQ"];
    NSArray *sortedFilePaths = [filePaths sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    for (NSInteger pageIndex = 0; pageIndex < sortedFilePaths.count; pageIndex++)
    {
        [self createFAQPageWithIndex:pageIndex imageFilePath:sortedFilePaths[pageIndex]];
    }
    
    self.pageControl.numberOfPages = sortedFilePaths.count;
}

- (void)createFAQPageWithIndex:(NSInteger)pageIndex imageFilePath:(NSString *)imageFilePath
{
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    CGFloat insets = self.leftInsetConstraint.constant + self.rightInsetConstraint.constant;
    CGSize contentSize = self.scrollView.contentSize;
    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath];
    CGFloat imageWidth = viewSize.width - insets;
    CGFloat imageHeight = self.scrollView.frame.size.height;
    CGFloat imageOrigin = pageIndex * imageWidth;
    CGRect imageRect = CGRectMake(imageOrigin, 0, imageWidth, imageHeight);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageWithData:imageData];
    [self.scrollView addSubview:imageView];
    
    contentSize.width += imageWidth;
    [self.scrollView setContentSize:contentSize];
}

@end
