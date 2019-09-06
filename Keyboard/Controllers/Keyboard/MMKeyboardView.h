//
//  MMKeyboardView.h
//  Keyboard
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyView.h"
#import "MMDesignableView.h"

@class MMGradient;
@class MMBackground;
@class MMKeyboardDesign;

@interface MMKeyboardView : MMDesignableView
@property (nonatomic, weak) IBOutlet MMKeyView *deleteKey;
@property (nonatomic, weak) IBOutlet MMKeyView *nextKey;
@property (nonatomic, weak) IBOutlet MMKeyView *returnKey;
@property (nonatomic, weak) IBOutlet MMKeyView *emojiKey;
@property (nonatomic, weak) IBOutlet MMKeyView *altKey;
@property (nonatomic, weak) IBOutlet MMKeyView *numbersKey;
@property (nonatomic, weak) IBOutlet MMKeyView *spaceKey;
@property (nonatomic, weak) IBOutlet MMKeyView *dismissKey;
@property (nonatomic, weak) IBOutlet MMKeyView *shiftKey;
@property (nonatomic, weak) IBOutlet MMKeyView *rightShiftKey;
@property (nonatomic, weak) id<MMKeyViewDelegate> delegate;
@property (nonatomic, strong) MMKeyboardDesign *keyboardDesign;
@property (nonatomic, strong) NSMutableArray *characterKeys;
@property (nonatomic, strong) NSMutableArray *specialKeys;
@property (nonatomic, assign) BOOL altKeyHidden;

- (MMKeyboardView *)initWithFrame:(CGRect)frame delegate:(id<MMKeyViewDelegate>)delegate;

- (void)adjustToNewInterfaceOrientation:(UIInterfaceOrientation)orientation keyboardDesign:(MMKeyboardDesign *)keyboardDesign;
- (void)adjustFramesToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
