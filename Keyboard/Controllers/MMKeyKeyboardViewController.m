//
//  MMKeyKeyboardViewController.m
//  Keyboard
//
//  Created by Lucky on 6/15/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Utilities.h"
#import "MMUIHelper.h"
#import "MMKeyboardState.h"
#import "MMSharedContainer.h"
#import "MMKeyKeyboardViewController.h"
#import "MMKeyboardViewController_iPad.h"
#import "MMKeyboardKeyPadViewController.h"

static NSString *const kMMKeyKeyboardNumberPadNibName = @"MMNumberPad";

static NSString *const kMMKeyKeyboardLayoutFileExtension = @"plist";
static NSString *const kMMKeyKeyboardNumberPadLayoutFileName = @"MMNumberPadLayout";
static NSString *const kMMKeyKeyboardDefaultLayoutFileName = @"MMDefaultLayout";

static NSString *const kMMKeyKeyboardDotString = @".";
static NSString *const kMMKeyKeyboardSpaceString = @" ";
static NSString *const kMMKeyKeyboardEmptyString = @"";

@interface MMKeyKeyboardViewController ()
@property (nonatomic, strong) MMBaseKeyboardViewController *keyboardViewController;
@property (nonatomic, assign) UIReturnKeyType lastReturnKeyType;
@property (nonatomic, assign) UIKeyboardType lastKeyboardType;
@property (nonatomic, assign) BOOL keyboardTypeSet;
@end

@implementation MMKeyKeyboardViewController

+ (BOOL)canInstantiateFromStoryboard
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.containerController setTextInputDelegate:self];
    
    if (!self.keyboardTypeSet)
    {
        self.keyboardTypeSet = YES;
        [self configureKeyboard];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.keyboardTypeSet = NO;
}

- (void)switchToNumbers
{
    [self.keyboardViewController setKeyboardKeyState:kMMKeyboardKeyStateNumbers];
}

- (void)selectionWillChange:(id<UITextInput>)textInput
{
    
}

- (void)selectionDidChange:(id<UITextInput>)textInput
{
    
}

- (void)textWillChange:(id<UITextInput>)textInput
{
    
}

- (void)textDidChange:(id<UITextInput>)textInput
{
    NSObject <UITextDocumentProxy> *proxy = self.containerController.textDocumentProxy;
    
    if (self.lastKeyboardType != proxy.keyboardType)
    {
        [self removeKeyboardConfiguration];
        [self configureKeyboard];
    }
    
    [self.keyboardViewController textHasChanged];
    
    if (self.lastReturnKeyType != proxy.returnKeyType)
    {
        [self.keyboardViewController adjustReturnKey];
        self.lastReturnKeyType = proxy.returnKeyType;
    }
}

- (void)keyboardViewController:(MMBaseKeyboardViewController *)keyboardViewController deleteCharacters:(NSInteger)charactersCount
{
    for (NSInteger index = 0; index < charactersCount; index++)
    {
        [self.containerController.textDocumentProxy deleteBackward];
    }
}

- (void)keyboardViewController:(MMBaseKeyboardViewController *)keyboardViewController insertText:(NSString *)text
{
    if (!text) return;
    
    [self.containerController.textDocumentProxy insertText:text];
}

- (void)keyboardViewControllerAddDotAfterDoubleSpaceTap:(MMBaseKeyboardViewController *)keyboardViewController
{
    NSString *lastText = [self.containerController.textDocumentProxy documentContextBeforeInput];
    NSRange enumRange = {0, lastText.length};
    __block BOOL space = false;
    __block int index = 0;
    
    [lastText enumerateSubstringsInRange:enumRange options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationReverse usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {
        if (index == 0)
        {
            if ([substring isEqualToString:kMMKeyKeyboardSpaceString])
            {
                space = YES;
            }
            else
            {
                *stop = YES;
            }
        }
        else if (space && ![substring isEqualToString:kMMKeyKeyboardDotString] && ![substring isEqualToString:kMMKeyKeyboardSpaceString])
        {
            [self.containerController.textDocumentProxy deleteBackward];
            [self.containerController.textDocumentProxy insertText:kMMKeyKeyboardDotString];
            *stop = YES;
        }
        else
        {
            *stop = YES;
        }
        index++;
    }];
}

- (void)keyboardViewControllerRequestsiMojiKeyboard:(MMBaseKeyboardViewController *)keyboardViewController
{
    [self.containerController setKeyboardType:kMMKeyboardTypeiMoji];
}

- (void)keyboardViewControllerRequestsNextKeyboard:(MMBaseKeyboardViewController *)keyboardViewController
{
    [self.containerController advanceToNextInputMode];
}

- (void)keyboardViewControllerDeleteLastCharacter:(MMBaseKeyboardViewController *)keyboardViewController
{
    [self.containerController.textDocumentProxy deleteBackward];
}

- (void)keyboardViewControllerDeleteLastWord:(MMBaseKeyboardViewController *)keyboardViewController
{
    NSString *text = [self.containerController.textDocumentProxy documentContextBeforeInput];
    
    if (!text.length)
    {
        for (NSInteger index = 0; index < 5; index++)
        {
            [self.containerController.textDocumentProxy deleteBackward];
        }
        
        return;
    }
    else
    {
        __block NSInteger charactersCount = text.length;
        NSRange textRange = {0, text.length};
        
        [text enumerateSubstringsInRange:textRange options:NSStringEnumerationReverse | NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
        {
            charactersCount = enclosingRange.length;
            *stop = YES;
        }];
        
        [self keyboardViewController:keyboardViewController deleteCharacters:charactersCount];
    }
}

- (NSString *)keyboardViewControllerLastText:(MMBaseKeyboardViewController *)keyboardViewController
{
    return [self.containerController.textDocumentProxy documentContextBeforeInput];
}

- (NSString *)keyboardViewControllerNextText:(MMBaseKeyboardViewController *)keyboardViewController
{
    return [self.containerController.textDocumentProxy documentContextAfterInput];
}

- (void)dismissKeyboardViewController:(MMBaseKeyboardViewController *)keyboardViewController
{
    [self.containerController dismissKeyboard];
}

- (UITextAutocapitalizationType)autocapitalizationType
{
    return self.containerController.textDocumentProxy.autocapitalizationType;
}

- (UITextAutocorrectionType)autocorrectionType
{
    return self.containerController.textDocumentProxy.autocorrectionType;
}

- (UIReturnKeyType)returnKeyType
{
    return self.containerController.textDocumentProxy.returnKeyType;
}

- (UIKeyboardType)keyboardType
{
    return self.containerController.textDocumentProxy.keyboardType;
}

- (BOOL)enablesReturnKeyAutomatically
{
    return self.containerController.textDocumentProxy.enablesReturnKeyAutomatically;
}

- (void)doNotDisturb:(BOOL)disturb
{

}

- (void)shouldShare:(id<MMShareDelegate>)sender
{
    [self.containerController.textDocumentProxy insertText:kMMKeyKeyboardEmptyString];
}

- (void)shouldRate:(id<MMShareDelegate>)sender
{
    [self.keyboardViewController shouldRate:sender];
}

- (MMKeyboardDesign *)requestCurrentKeyboardDesign:(MMBaseKeyboardViewController *)keyboardViewController
{
    MMKeyboardDesign *keyboardDesign = [MMKeyboardDesign sharedDesign];
    
    return keyboardDesign;
}

- (void)configureKeyboard
{
    id<UITextInputTraits> proxy = self.containerController.textDocumentProxy;
    self.lastKeyboardType = proxy.keyboardType;
    
    if (isIPad())
    {
        [self addStandardKeyboardView];
    }
    else
    {
        switch (self.lastKeyboardType)
        {
            case UIKeyboardTypeDefault:
            case UIKeyboardTypeASCIICapable:
            case UIKeyboardTypeURL:
            case UIKeyboardTypeNumbersAndPunctuation:
            case UIKeyboardTypeEmailAddress:
            case UIKeyboardTypeTwitter:
            case UIKeyboardTypeWebSearch:
            {
                [self addStandardKeyboardView];
                break;
            }
            case UIKeyboardTypeNumberPad:
            {
                [self addNumberPadKeyboardView:NO];
                break;
            }
            case UIKeyboardTypeDecimalPad:
            {
                [self addNumberPadKeyboardView:YES];
                break;
            }
            case UIKeyboardTypePhonePad:
            case UIKeyboardTypeNamePhonePad:
            {
                break;
            }
            default:
            {
                break;
            }
        }
    }
    
    MMKeyboardDesign *keyboardDesign = [MMKeyboardDesign sharedDesign];
    [self.keyboardViewController setKeyboardDesign:keyboardDesign];
    [self.keyboardViewController setEnabled:YES];
}

- (void)removeKeyboardConfiguration
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    for (UIView *subview in self.view.subviews)
    {
        [subview removeFromSuperview];
    }
    
    [self.keyboardViewController removeFromParentViewController];
    self.keyboardViewController = nil;
}

- (void)addKeyboardViewController:(MMBaseKeyboardViewController *)keyboardViewController
{
    [self addChildViewController:self.keyboardViewController];
    
    UIView *keyboardView = self.keyboardViewController.view;
    keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:keyboardView];
    
    [self.view addConstraints:@[[MMUIHelper snapLeftConstraintInView:keyboardView forView:self.view],
                                [MMUIHelper snapRightConstraintInView:self.view forView:keyboardView],
                                [MMUIHelper snapTopConstraintInView:keyboardView forView:self.view],
                                [MMUIHelper snapBottomConstraintInView:self.view forView:keyboardView]]];
}

- (void)addStandardKeyboardView
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *layoutFilePath = [bundle pathForResource:kMMKeyKeyboardDefaultLayoutFileName ofType:kMMKeyKeyboardLayoutFileExtension];
    
    if (isIPad())
    {
        self.keyboardViewController = [[MMKeyboardViewController_iPad alloc] initWithFrame:self.view.bounds layoutFilePath:layoutFilePath];
    }
    else
    {
        self.keyboardViewController = [[MMKeyboardViewController alloc] initWithFrame:self.view.bounds layoutFilePath:layoutFilePath];
    }
    
    self.keyboardViewController.dataSource = self;
    self.keyboardViewController.delegate = self;
    [self addKeyboardViewController:self.keyboardViewController];
}

- (void)addNumberPadKeyboardView:(BOOL)withPeriod
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *layoutFilePath = [bundle pathForResource:kMMKeyKeyboardNumberPadLayoutFileName ofType:kMMKeyKeyboardLayoutFileExtension];
    MMKeyboardKeyPadViewController *keyboardViewController = [[MMKeyboardKeyPadViewController alloc] initWithNibName:kMMKeyKeyboardNumberPadNibName layoutFilePath:layoutFilePath];
    keyboardViewController.dataSource = self;
    keyboardViewController.delegate = self;
    keyboardViewController.showPeriodKey = withPeriod;
    self.keyboardViewController = keyboardViewController;
    [self addKeyboardViewController:keyboardViewController];
}

- (void)switchKeyboard:(UIButton *)sender
{
    [self.containerController advanceToNextInputMode];
}

@end
