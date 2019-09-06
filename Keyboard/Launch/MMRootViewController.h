//
//  MMRootViewController.h
//  Keyboard
//
//  Created by Lucky on 6/14/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMContainerViewController.h"

@interface MMRootViewController : UIViewController

@property (weak, nonatomic) MMContainerViewController *containerController;

+ (instancetype)instantiateFromStoryboard;

+ (NSString *)storyboardIdentifier;
+ (BOOL)canInstantiateFromStoryboard;

- (void)switchToNumbers;

@end
