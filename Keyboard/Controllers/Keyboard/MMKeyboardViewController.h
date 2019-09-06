//
//  MMKeyboardViewController.h
//  Keyboard
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMBaseKeyboardViewController.h"

@interface MMKeyboardViewController : MMBaseKeyboardViewController <MMKeyViewDelegate>

- (BOOL)checkIfKeyIsEqualToAShiftKey:(MMKeyView *)keyView;
- (void)executeForShiftKeys:(void(^)(MMKeyView *shiftKey))block;

@end
