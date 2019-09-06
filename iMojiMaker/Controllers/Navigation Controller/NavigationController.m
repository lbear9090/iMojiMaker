//
//  NavigationController.m
//  iMojiMaker
//
//  Created by Lucky on 4/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureAppearance];
}

- (UIViewController *)rootViewController
{
    return self.viewControllers.firstObject;
}

- (void)configureAppearance
{
    self.navigationBar.tintColor = [UIColor colorWithHexString:kBlueColor];
    self.view.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
}

@end
