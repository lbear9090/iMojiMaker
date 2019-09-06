//
//  UIViewController+Extension.h
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"

@interface UIViewController (Storyboard)

+ (NSString *)storyboardIdentifier;
+ (instancetype)loadFromStoryboard;
+ (instancetype)loadFromStoryboardWithBlur;
+ (NavigationController *)loadEmbedInNavigationController;

@end
