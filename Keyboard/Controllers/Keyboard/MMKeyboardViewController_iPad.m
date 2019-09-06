//
//  MMKeyboardViewController_iPad.m
//  Keyboard
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyboardViewController_iPad.h"
#import "MMBaseKeyboardViewControllerSubclass.h"

@implementation MMKeyboardViewController_iPad

- (BOOL)checkIfKeyIsEqualToAShiftKey:(MMKeyView *)keyView
{
    return keyView == self.view.shiftKey || keyView == self.view.rightShiftKey;
}

- (void)executeForShiftKeys:(void (^)(MMKeyView *))block
{
    block(self.view.shiftKey);
    block(self.view.rightShiftKey);
}

- (void)keyViewDidTouchUpInside:(MMKeyView *)keyView
{
    [super keyViewDidTouchUpInside:keyView];
    
    if (keyView == self.view.dismissKey)
    {
        [self.delegate dismissKeyboardViewController:self];
    }
}

@end
