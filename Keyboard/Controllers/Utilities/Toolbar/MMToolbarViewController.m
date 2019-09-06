//
//  MMToolbarViewController.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//


#import "MMToolbarButton.h"
#import "MMKeyboardDesign.h"
#import "MMToolbarLayoutMap.h"
#import "MMToolbarViewController.h"
#import "MMToolbarButtonContentMap.h"

@interface MMToolbarViewController ()
@property (nonatomic, weak) IBOutlet MMToolbarButton *spaceButton;
@property (nonatomic, weak) IBOutlet MMToolbarButton *returnButton;
@property (nonatomic, weak) IBOutlet MMToolbarButton *backspaceButton;
@property (nonatomic, weak) IBOutlet MMToolbarButton *nextKeyboardButton;
@property (nonatomic, weak) IBOutlet MMToolbarButton *changeContentButton;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *edgeConstraints;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *interitemSpaceConstraints;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *specialSpaceConstraints;
@property (nonatomic, assign) CGFloat lastContentUpdateViewWidth;
@end

@implementation MMToolbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.delegate toolbarViewController:self willLayoutViewWithSize:self.view.bounds.size];
}

- (void)configureAppearance
{
    MMKeyboardDesign *keyboardDesign = [MMKeyboardDesign sharedDesign];
    [self.view setBackgroundColor:keyboardDesign.backgroundColor];
    
    [keyboardDesign adjustButton:self.spaceButton isSpecial:NO];
    [keyboardDesign adjustButton:self.returnButton isSpecial:YES];
    [keyboardDesign adjustButton:self.backspaceButton isSpecial:YES];
    [keyboardDesign adjustButton:self.nextKeyboardButton isSpecial:YES];
    [keyboardDesign adjustButton:self.changeContentButton isSpecial:YES];
}

+ (NSString *)segueIdentifier
{
    return NSStringFromClass([MMToolbarViewController class]);
}

- (void)updateButtonContentWithContentMap:(MMToolbarButtonContentMap *)contentMap
{
    self.lastContentUpdateViewWidth = self.view.bounds.size.width;
    
    [self updateButton:self.spaceButton withContentSet:contentMap.spaceButtonContentSet];
    [self updateButton:self.returnButton withContentSet:contentMap.returnButtonContentSet];
    [self updateButton:self.changeContentButton withContentSet:contentMap.changeContentButtonContentSet];
    [self updateButton:self.backspaceButton withContentSet:contentMap.backspaceButtonContentSet];
    [self updateButton:self.nextKeyboardButton withContentSet:contentMap.nextKeyboardButtonContentSet];
}

- (void)adaptConstraintsForSpacingMap:(MMToolbarLayoutMap *)spacingMap
{
    if (![self isViewLoaded]) return;
    
    [self adaptButtonConstraintsWithSpacingMap:spacingMap];
    
    for (NSLayoutConstraint *edgeConstraint in self.edgeConstraints)
    {
        edgeConstraint.constant = spacingMap.edgeOffset;
    }
    
    for (NSLayoutConstraint *interitemSpaceConstraint in self.interitemSpaceConstraints)
    {
        interitemSpaceConstraint.constant = spacingMap.interitemSpace;
    }
    
    for (NSLayoutConstraint *specialSpaceConstraint in self.specialSpaceConstraints)
    {
        specialSpaceConstraint.constant = spacingMap.specialSpace;
    }
    
    [self.view setNeedsUpdateConstraints];
}

- (BOOL)shouldUpdateButtonContentMapForViewSize:(CGSize)viewSize
{
    return (self.lastContentUpdateViewWidth != viewSize.width);
}

- (IBAction)moveToNextKeyboard:(UIButton *)sender
{
    [self.delegate toolbarViewController:self touchUpButtonWithType:kMMToolbarButtonTypeNextKeyboard];
}

- (IBAction)insertSpace:(UIButton *)sender
{
    [self.delegate toolbarViewController:self touchUpButtonWithType:kMMToolbarButtonTypeSpace];
}

- (IBAction)insertNewLine:(UIButton *)sender
{
    [self.delegate toolbarViewController:self touchUpButtonWithType:kMMToolbarButtonTypeReturn];
}

- (IBAction)touchDownBackspaceButton:(UIButton *)sender
{
    [self.delegate toolbarViewController:self touchDownButtonWithType:kMMToolbarButtonTypeBackspace];
}

- (IBAction)touchUpBackspaceButton:(UIButton *)sender
{
    [self.delegate toolbarViewController:self touchUpButtonWithType:kMMToolbarButtonTypeBackspace];
}

- (IBAction)leftButtonAction:(UIButton *)sender
{
    [self.delegate toolbarViewController:self touchUpButtonWithType:kMMToolbarButtonTypeChangeContent];
}

- (void)adaptButtonConstraintsWithSpacingMap:(MMToolbarLayoutMap *)spacingMap
{
    [self.changeContentButton adaptConstraintsForSize:spacingMap.changeContentButtonSize];
    [self.nextKeyboardButton adaptConstraintsForSize:spacingMap.nextKeyboardButtonSize];
    [self.spaceButton adaptConstraintsForSize:spacingMap.spaceButtonSize];
    [self.backspaceButton adaptConstraintsForSize:spacingMap.backspaceButtonSize];
    [self.returnButton adaptConstraintsForSize:spacingMap.returnButtonSize];
}

- (void)updateButton:(UIButton *)button withContentSet:(MMToolbarButtonContentSet *)contentSet
{
    if ([contentSet containsText])
    {
        [self updateButton:button withButtonName:contentSet.buttonText fontSize:contentSet.buttonFontSize];
    }
    else
    {
        if (button != self.changeContentButton)
        {
            MMKeyboardDesign *keyboardDesign = [MMKeyboardDesign sharedDesign];
            [keyboardDesign adjustButton:button keyInfo:contentSet.keyInfo];
        }
    }
}

- (void)updateButton:(UIButton *)button withButtonName:(NSString *)buttonName fontSize:(CGFloat)fontSize
{
    [button setTitle:buttonName forState:UIControlStateNormal];
    UIFont *titleFont = [button.titleLabel.font fontWithSize:fontSize];
    [button.titleLabel setFont:titleFont];
    [button setImage:nil forState:UIControlStateNormal];
    
    MMKeyboardDesign *keyboardDesign = [MMKeyboardDesign sharedDesign];
    [button setTitleColor:keyboardDesign.designProperties.buttonLabelTextColor forState:UIControlStateNormal];
}

@end
