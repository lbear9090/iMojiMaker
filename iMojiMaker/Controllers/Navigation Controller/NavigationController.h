//
//  NavigationController.h
//  iMojiMaker
//
//  Created by Lucky on 4/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"

@interface NavigationController : UINavigationController

@property (nonatomic, weak) UIViewController *rootViewController;

- (void)configureAppearance;

@end
