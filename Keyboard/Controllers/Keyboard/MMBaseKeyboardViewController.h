//
//  MMBaseKeyboardViewController.h
//  Keyboard
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMTouchBias.h"
#import "MMKeyboardView.h"
#import "MMShareDelegate.h"
#import "MMKeyboardDesign.h"

typedef NS_ENUM(NSInteger, kMMKeyboardKeyState)
{
    kMMKeyboardKeyStateNormal       = 0,
    kMMKeyboardKeyStateNumbers      = 1,
    kMMKeyboardKeyStateAdditionals  = 2
};

@protocol MMKeyboardViewControllerDelegate;
@protocol MMKeyboardViewControllerDataSource;

@interface MMBaseKeyboardViewController : UIViewController <MMKeyViewDelegate, MMShareDelegate>
@property (nonatomic, weak) id<MMKeyboardViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<MMKeyboardViewControllerDelegate> delegate;
@property (nonatomic, strong) MMTouchBias *touchBias;
@property (nonatomic, strong) MMKeyboardView *view;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
@property (nonatomic, assign) BOOL instantiatedFromNib;

- (instancetype)initWithFrame:(CGRect)frame layoutFilePath:(NSString *)layoutFilePath;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil layoutFilePath:(NSString *)layoutFilePath;

- (void)textHasChanged;
- (void)adjustReturnKey;
- (void)setEnabled:(BOOL)enabled;
- (void)setKeyboardDesign:(MMKeyboardDesign *)keyboardDesign;
- (void)setKeyboardKeyState:(kMMKeyboardKeyState)keyboardKeyState;
- (void)updateKeyboardWithOrientation:(UIInterfaceOrientation)orientation;

@end


@protocol MMKeyboardViewControllerDataSource <NSObject>

- (MMKeyboardDesign *)requestCurrentKeyboardDesign:(MMBaseKeyboardViewController *)keyboardViewController;

@end


@protocol MMKeyboardViewControllerDelegate <NSObject>

- (void)keyboardViewController:(MMBaseKeyboardViewController *)keyboardViewController deleteCharacters:(NSInteger)charactersCount;
- (void)keyboardViewController:(MMBaseKeyboardViewController *)keyboardViewController insertText:(NSString *)text;
- (void)keyboardViewControllerAddDotAfterDoubleSpaceTap:(MMBaseKeyboardViewController *)keyboardViewController;
- (void)keyboardViewControllerRequestsiMojiKeyboard:(MMBaseKeyboardViewController *)keyboardViewController;
- (void)keyboardViewControllerRequestsNextKeyboard:(MMBaseKeyboardViewController *)keyboardViewController;
- (void)keyboardViewControllerDeleteLastCharacter:(MMBaseKeyboardViewController *)keyboardViewController;
- (void)keyboardViewControllerDeleteLastWord:(MMBaseKeyboardViewController *)keyboardViewController;
- (NSString *)keyboardViewControllerLastText:(MMBaseKeyboardViewController *)keyboardViewController;
- (NSString *)keyboardViewControllerNextText:(MMBaseKeyboardViewController *)keyboardViewController;
- (void)dismissKeyboardViewController:(MMBaseKeyboardViewController *)keyboardViewController;
- (UITextAutocapitalizationType)autocapitalizationType;
- (UITextAutocorrectionType)autocorrectionType;
- (UIReturnKeyType)returnKeyType;
- (UIKeyboardType)keyboardType;
- (BOOL)enablesReturnKeyAutomatically;
- (void)doNotDisturb:(BOOL)disturb;

@end
