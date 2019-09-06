//
//  MMContainerViewController.h
//  Keyboard
//
//  Created by Lucky on 6/14/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMRootViewController;

typedef NS_ENUM(NSInteger, kMMKeyboardType)
{
    kMMKeyboardTypeiMoji    = 0,
    kMMKeyboardTypeKeys     = 1,
    kMMKeyboardTypeNumbers  = 2
};

@interface MMContainerViewController : UIInputViewController

- (void)setKeyboardType:(kMMKeyboardType)keyboardType;
- (void)setRootViewController:(MMRootViewController *)rootViewController;
- (void)setTextInputDelegate:(id<UITextInputDelegate>)textInputDelegate;

+ (UIInterfaceOrientation)currentOrientation;
+ (CGFloat)heightForInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (CGFloat)correctionForInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
