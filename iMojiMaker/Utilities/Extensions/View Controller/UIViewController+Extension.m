//
//  UIViewController+Extension.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "UIViewController+Extension.h"

static NSString *const kMainStoryboardName = @"Main";

@implementation UIViewController (Storyboard)

+ (NSString *)storyboardIdentifier
{
    return NSStringFromClass([self class]);
}

+ (instancetype)loadFromStoryboard
{
    NSString *identifier = [self storyboardIdentifier];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainStoryboardName bundle:nil];
    
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

+ (instancetype)loadFromStoryboardWithBlur
{
    UIViewController *viewController = [self loadFromStoryboard];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    visualEffectView.frame = viewController.view.bounds;
    
    [viewController.view setBackgroundColor:[UIColor clearColor]];
    [viewController.view insertSubview:visualEffectView atIndex:0];
    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    return viewController;
}

+ (NavigationController *)loadEmbedInNavigationController
{
    return [[NavigationController alloc] initWithRootViewController:[self loadFromStoryboard]];
}

@end
