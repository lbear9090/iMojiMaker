//
//  ShareViewController.m
//  iMojiMaker
//
//  Created by Lucky on 5/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "LoadingView.h"
#import "AnimatedImage.h"
#import "ContentManager.h"
#import "ShareViewController.h"

@interface ShareViewController ()
@property (nonatomic, weak) IBOutlet AnimatedImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer)
    {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    }
    
    return _tapGestureRecognizer;
}

- (void)setProductData:(ProductData *)productData
{
    _productData = [ContentLoader loadProductDataWithSize:kProductsSizeBig productData:productData];
    
    [self loadProductContent];
}

- (void)loadProductContent
{
    if (!self.productData.isAnimated)
    {
        [self loadStaticImage];
    }
    else
    {
        [self loadAnimatedImage];
    }
}

- (void)loadStaticImage
{
    __weak ShareViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSData *imageData = [weakSelf.productData loadImageData];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.imageView.image = image;
        });
    });
}

- (void)loadAnimatedImage
{
    __weak ShareViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSData *imageData = [weakSelf.productData loadImageData];
        AnimatedImage *image = [AnimatedImage animatedImageWithGIFData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.imageView.animatedImage = image;
        });
    });
}

- (void)dismissController
{
    [self.presentingViewController viewWillAppear:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonAction:(id)sender
{
    [LoadingView show];
    
    NSData *contentData = [self.productData loadImageData];
    NSArray *activityItems = @[contentData];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:^
    {
        [LoadingView hide];
    }];
}

- (IBAction)deleteButtonAction:(id)sender
{
    NSString *alertTitle = @"Delete?";
    NSString *alertMessage = @"Say goodbye to your little friend";
    NSString *alertCancelButtonTitle = @"Cancel";
    NSString *alertOKButtonTitle = @"Delete";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:alertCancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:alertOKButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        [ContentManager removeContentWithProductData:self.productData];
        [self dismissController];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
