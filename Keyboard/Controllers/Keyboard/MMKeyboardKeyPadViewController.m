//
//  MMKeyboardKeyPadViewController.m
//  Keyboard
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMUIHelper.h"
#import "MMAudioManager.h"
#import "MMContainerViewController.h"
#import "MMKeyboardKeyPadViewController.h"
#import "MMBaseKeyboardViewControllerSubclass.h"

@interface MMKeyboardKeyPadViewController ()
@property (nonatomic, strong) IBOutlet MMKeyView *periodKey;
@end

@implementation MMKeyboardKeyPadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.showPeriodKey)
    {
        [self.periodKey removeFromSuperview];
        
        NSLayoutConstraint *constraintToRemove = [MMUIHelper findConstraintOnItem:self.view.nextKey attribute:NSLayoutAttributeWidth];
        [self.view.nextKey.superview removeConstraint:constraintToRemove];
        
        NSLayoutConstraint *trailingConstraint = [MMUIHelper snapRightConstraintInView:self.view.nextKey forView:self.view.nextKey.superview];
        [self.view.nextKey.superview addConstraint:trailingConstraint];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateKeyboardWithOrientation:[MMContainerViewController currentOrientation]];
}

- (void)setKeyboardDesign:(MMKeyboardDesign *)keyboardDesign
{
    self.view.backgroundColor = keyboardDesign.backgroundColor;
    [self.view setBackgroundGradient:keyboardDesign.backgroundGradient];
    [self.view setBackgroundImage:keyboardDesign.backgroundImage];
    
    for (MMKeyView *key in self.characterKeys)
    {
        [keyboardDesign adjustKeyView:key isSpecial:NO];
    }
    
    for (MMKeyView *special in self.specialKeys)
    {
        [keyboardDesign adjustKeyView:special isSpecial:YES];
    }
}

- (void)keyViewDidTouchUpInside:(MMKeyView *)keyView
{
    if (keyView == self.view.nextKey)
    {
        [self.delegate keyboardViewControllerRequestsNextKeyboard:self];
    }
}

- (MMKeyView *)handleTouch:(CGPoint)touchLocation
{
    if (!CGRectContainsPoint(self.widenedTouchArea, touchLocation))
    {
        MMKeyView *touchedKey = [self keyViewForTouchLocation:touchLocation];
        [self.activeKey highlight:NO];
        
        CGRect keyFrame = touchedKey.frame;
        keyFrame.origin = [self.view convertPoint:keyFrame.origin fromView:[touchedKey superview]];
        CGFloat resizeFactor = [self keyViewScaleOnTouchFactor];
        keyFrame = CGRectInset(keyFrame, - keyFrame.size.width * resizeFactor, - keyFrame.size.height * resizeFactor);
        self.widenedTouchArea = keyFrame;
        self.widenedTouchAreaView.frame = self.widenedTouchArea;
        
        [touchedKey highlight:YES];
        
        self.activeKey = touchedKey;
    }
    
    return self.activeKey;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
    MMKeyView *touchedKey = [self handleTouch:touchLocation];
    
    if (touchedKey)
    {
        [MMAudioManager playClickSound];
    }
    
    if (touchedKey == self.view.deleteKey)
    {
        [self.delegate keyboardViewControllerDeleteLastCharacter:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
    
    [self handleTouch:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
    MMKeyView *key = [self handleTouch:touchLocation];
    
    if (self.view.userInteractionEnabled)
    {
        [self.delegate keyboardViewController:self insertText:key.keyInfo.character];
    }
    
    [self.activeKey highlight:NO];
    
    CGRect keyFrame = CGRectZero;
    self.widenedTouchArea = keyFrame;
    self.widenedTouchAreaView.frame = keyFrame;
    
    self.activeKey = nil;
}

@end
