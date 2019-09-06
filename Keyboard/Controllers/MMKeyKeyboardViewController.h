//
//  MMKeyKeyboardViewController.h
//  Keyboard
//
//  Created by Lucky on 6/15/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMRootViewController.h"
#import "MMKeyboardViewController.h"

@interface MMKeyKeyboardViewController : MMRootViewController <MMKeyboardViewControllerDataSource, MMKeyboardViewControllerDelegate, MMShareDelegate, UITextInputDelegate>

@end
