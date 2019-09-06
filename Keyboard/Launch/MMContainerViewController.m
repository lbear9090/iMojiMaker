//
//  MMContainerViewController.m
//  Keyboard
//
//  Created by Lucky on 6/14/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Utilities.h"
#import "MMUIHelper.h"
#import "MMRootViewController.h"
#import "MMContainerViewController.h"
#import "MMLaunchingInfoPlistParser.h"
#import "MMiMojiKeyboardViewController.h"

static CGFloat const kMMKeyboardTopViewHeightiPadPortrait = 0.0;
static CGFloat const kMMKeyboardTopViewHeightiPadLandscape = 0.0;
static CGFloat const kMMKeyboardTopViewHeightiPhonePortrait = 0.0;
static CGFloat const kMMKeyboardTopViewHeightiPhoneLandscape = 0.0;

static CGFloat const kMMKeyboardHeightiPadPortrait = 265.0 + kMMKeyboardTopViewHeightiPadPortrait;
static CGFloat const kMMKeyboardHeightiPadLandscape = 353.0 + kMMKeyboardTopViewHeightiPadLandscape;
static CGFloat const kMMKeyboardHeightiPhonePortrait = 216.0 + kMMKeyboardTopViewHeightiPhonePortrait;
static CGFloat const kMMKeyboardHeightiPhoneLandscape = 216.0 + kMMKeyboardTopViewHeightiPhoneLandscape;

static NSString *const kMMWrongRootClassNameExceptionName = @"Wrong root class name";
static NSString *const kMMWrongRootClassNameReason = @"The class name indicated in plist file is not a subclass of MMRootViewController class";

@interface MMContainerViewController ()
@property (nonatomic, weak) id<UITextInputDelegate> inputDelegate;
@property (nonatomic, strong) MMRootViewController *rootController;
@property (nonatomic, strong) NSLayoutConstraint *keyboardHeightConstraint;
@end


@implementation MMContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIInterfaceOrientation orientation = [MMContainerViewController currentOrientation];
    self.keyboardHeightConstraint.constant = [MMContainerViewController heightForInterfaceOrientation:orientation];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (self.view.frame.size.width == 0 || self.view.frame.size.height == 0) return;
    
    UIInterfaceOrientation orientation = [MMContainerViewController currentOrientation];
    CGFloat height = [MMContainerViewController heightForInterfaceOrientation:orientation];
    
    if (!self.keyboardHeightConstraint)
    {
        self.keyboardHeightConstraint = [NSLayoutConstraint constraintWithItem:self.inputView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:0.0f
                                                                      constant:height];
    }
    else
    {
        [self.inputView removeConstraint:self.keyboardHeightConstraint];
        self.keyboardHeightConstraint.constant = height;
    }
    
    [self.inputView addConstraint:self.keyboardHeightConstraint];
}

- (void)setKeyboardType:(kMMKeyboardType)keyboardType
{
    switch (keyboardType)
    {
        case kMMKeyboardTypeKeys:
        {
            [self setKeyboardViewController];
            break;
        }
        case kMMKeyboardTypeNumbers:
        {
            [self setKeyboardViewControllerWithNumbers];
            break;
        }
        case kMMKeyboardTypeiMoji:
        {
            [self setiMojiViewController];
            break;
        }
    }
}

- (void)setRootViewController:(MMRootViewController *)rootViewController
{
    if (self.rootController)
    {
        [self.rootController willMoveToParentViewController:nil];
        [self.rootController.view removeFromSuperview];
        [self.rootController removeFromParentViewController];
    }
    
    self.rootController = rootViewController;
    self.rootController.containerController = self;
    
    [self addChildViewController:self.rootController];
    [self.view addSubview:self.rootController.view];
    [self.rootController didMoveToParentViewController:self];
    
    self.rootController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[MMUIHelper snapAllSidesOfView:self.view toView:self.rootController.view]];
}

- (void)setTextInputDelegate:(id<UITextInputDelegate>)textInputDelegate
{
    self.inputDelegate = textInputDelegate;
}

- (void)selectionWillChange:(id<UITextInput>)textInput
{
    [self.inputDelegate selectionWillChange:textInput];
}

- (void)selectionDidChange:(id<UITextInput>)textInput
{
    [self.inputDelegate selectionDidChange:textInput];
}

- (void)textWillChange:(id<UITextInput>)textInput
{
    [self.inputDelegate textWillChange:textInput];
}

- (void)textDidChange:(id<UITextInput>)textInput
{
    [self.inputDelegate textDidChange:textInput];
}

+ (CGFloat)heightForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (isInterfacePortrait(orientation))
    {
        return isIPad() ? kMMKeyboardHeightiPadPortrait : kMMKeyboardHeightiPhonePortrait;
    }
    
    return isIPad() ? kMMKeyboardHeightiPadLandscape : kMMKeyboardHeightiPhoneLandscape;
}

+ (CGFloat)correctionForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (isInterfacePortrait(orientation))
    {
        return isIPad() ? kMMKeyboardTopViewHeightiPadPortrait : kMMKeyboardTopViewHeightiPhonePortrait;
    }
    
    return isIPad() ? kMMKeyboardTopViewHeightiPadLandscape : kMMKeyboardTopViewHeightiPhoneLandscape;
}

+ (UIInterfaceOrientation)currentOrientation
{
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    
    return screenSize.height > screenSize.width ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft;
}

- (MMRootViewController *)rootViewControllerWithClassName:(NSString *)className
{
    Class firstViewControllerClass = NSClassFromString(className);
    if (![firstViewControllerClass isSubclassOfClass:[MMRootViewController class]])
    {
        [self raiseWrongClassNameException];
        return nil;
    }
    
    if ([firstViewControllerClass canInstantiateFromStoryboard]) return [firstViewControllerClass instantiateFromStoryboard];
    
    return [[firstViewControllerClass alloc] init];
}

- (void)initKeyboard
{
    [self setiMojiViewController];
}

- (void)setiMojiViewController
{
    NSString *className = [MMLaunchingInfoPlistParser iMojiViewControllerClassName];
    MMRootViewController *rootViewController = [self rootViewControllerWithClassName:className];
    [self setRootViewController:rootViewController];
}

- (void)setKeyboardViewController
{
    NSString *className = [MMLaunchingInfoPlistParser keyboardViewControllerClassName];
    MMRootViewController *rootViewController = [self rootViewControllerWithClassName:className];
    [self setRootViewController:rootViewController];
}

- (void)setKeyboardViewControllerWithNumbers
{
    [self setKeyboardViewController];
    [self.rootController switchToNumbers];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        UIInterfaceOrientation orientation = [MMContainerViewController currentOrientation];
        CGFloat height = [MMContainerViewController heightForInterfaceOrientation:orientation];
        self.keyboardHeightConstraint.constant = height;
    }];
}

- (void)raiseWrongClassNameException
{
    NSDictionary *userInfo = @{@"Exception name: " : kMMWrongRootClassNameExceptionName,
                               @"Exception reason: " : kMMWrongRootClassNameReason};
    NSException *exception = [[NSException alloc] initWithName:kMMWrongRootClassNameExceptionName
                                                        reason:kMMWrongRootClassNameReason
                                                      userInfo:userInfo];
    [exception raise];
}

@end
