//
//  MMKeyboardViewController.m
//  Keyboard
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Utilities.h"
#import "MMKeyEvent.h"
#import "MMAudioManager.h"
#import "MMKeyboardSettings.h"
#import "MMContainerViewController.h"
#import "MMKeyboardViewController.h"
#import "MMBaseKeyboardViewControllerSubclass.h"

static CFTimeInterval const kMMKeyboardTapThreshold = 0.0f;
static CFTimeInterval const kMMKeyboardDoubleTapSpaceIntervalForDot = 1.0f;

static NSString *const kMMKeyboardReturnKeyGo = @"Go";
static NSString *const kMMKeyboardReturnKeyGoogle = @"Google";
static NSString *const kMMKeyboardReturnKeyJoin = @"Join";
static NSString *const kMMKeyboardReturnKeyNext = @"Next";
static NSString *const kMMKeyboardReturnKeyRoute = @"Route";
static NSString *const kMMKeyboardReturnKeySearch = @"Search";
static NSString *const kMMKeyboardReturnKeySend = @"Send";
static NSString *const kMMKeyboardReturnKeyYahoo = @"Yahoo";
static NSString *const kMMKeyboardReturnKeyDone = @"Done";
static NSString *const kMMKeyboardReturnKeyEmergencyCall = @"Emergency\nCall";
static NSString *const kMMKeyboardReturnKeyContinue = @"Continue";
static NSString *const kMMKeyboardReturnKeyDefault = @"Default";

static NSString *const kMMKeyboardSpaceCharacter = @" ";
static NSString *const kMMKeyboardReturnCharacter = @"\n";
static NSString *const kMMKeyboardTrimCharacterSet = @" \n";
static NSString *const kMMKeyboardDomainKeyIdentifier = @"domain";

static BOOL const kMMKeyboardDebugTouchArea = NO;

@interface MMKeyboardViewController ()
@property (nonatomic, strong) NSMutableArray *keyEvents;
@property (nonatomic, assign) CGPoint lastTouchLocation;
@property (nonatomic, assign) NSInteger spaceTouchCount;
@property (nonatomic, assign) CFTimeInterval repeatSpaceTouchTimeInterval;
@property (nonatomic, assign) kMMKeyboardKeyState keyboardKeyStateCurrent;
@property (nonatomic, assign) kMMKeyboardKeyState keyboardKeyStateLast;
@property (nonatomic, assign, getter=isCapitalized) BOOL capitalized;
@property (nonatomic, assign) BOOL suppressNextTouchUpDueToKeySwipe;
@property (nonatomic, assign) BOOL switchingKeyboardState;
@property (nonatomic, assign) BOOL didInputCharacter;
@property (nonatomic, assign) BOOL suppressHighlight;
@property (nonatomic, assign) BOOL shiftActive;
@property (nonatomic, assign) BOOL lockingCaps;
@property (nonatomic, assign) BOOL capsLocked;
@end

@implementation MMKeyboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self adjustKeyboardTypes];
    
    BOOL isNumbers = self.keyboardType == UIKeyboardTypeNumbersAndPunctuation;
    BOOL isNumberPad = self.keyboardType == UIKeyboardTypeNumberPad;
    BOOL isDecimalPad = self.keyboardType == UIKeyboardTypeDecimalPad;
    
    if (isNumbers || isNumberPad || isDecimalPad)
    {
        [self setKeyboardKeyState:kMMKeyboardKeyStateNumbers];
    }
    
    [self executeForShiftKeys:^(MMKeyView *shiftKey)
    {
        [shiftKey addDoubleTapTarget:self action:@selector(capsLockDoubleTap:)];
    }];
    
    if (kMMKeyboardDebugTouchArea)
    {
        self.widenedTouchAreaView = [[UIView alloc] init];
        self.widenedTouchAreaView.userInteractionEnabled = NO;
        self.widenedTouchAreaView.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.3];
        [self.view addSubview:self.widenedTouchAreaView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIInterfaceOrientation orientation = [MMContainerViewController currentOrientation];
    MMKeyboardDesign *keyboardDesign = [self.dataSource requestCurrentKeyboardDesign:self];
    [self.view adjustToNewInterfaceOrientation:orientation keyboardDesign:keyboardDesign];
}

- (NSMutableArray *)keyEvents
{
    if (!_keyEvents)
    {
        _keyEvents = [[NSMutableArray alloc] init];
    }
    
    return _keyEvents;
}

- (void)capsLockDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    MMKeyboardSettings *keyboardSettings = [MMKeyboardSettings instance];
    
    if (keyboardSettings.enableDoubleTapCapsLock)
    {
        self.lockingCaps = YES;
    }
}

- (void)adjustReturnKey
{
    self.returnKeyType = [self.delegate returnKeyType];
    BOOL hideImage = self.returnKeyType != UIReturnKeyDefault;
    self.view.returnKey.foregroundImageView.hidden = hideImage;
    self.view.returnKey.characterLabel.hidden = !hideImage;
    
    if (!hideImage) return;
    
    self.view.returnKey.characterLabel.text = [self returnKeyText];
}

- (NSString *)returnKeyText
{
    switch (self.returnKeyType)
    {
        case UIReturnKeyGo: return kMMKeyboardReturnKeyGo;
        case UIReturnKeyGoogle: return kMMKeyboardReturnKeyGoogle;
        case UIReturnKeyJoin: return kMMKeyboardReturnKeyJoin;
        case UIReturnKeyNext: return kMMKeyboardReturnKeyNext;
        case UIReturnKeyRoute: return kMMKeyboardReturnKeyRoute;
        case UIReturnKeySearch: return kMMKeyboardReturnKeySearch;
        case UIReturnKeySend: return kMMKeyboardReturnKeySend;
        case UIReturnKeyYahoo: return kMMKeyboardReturnKeyYahoo;
        case UIReturnKeyDone: return kMMKeyboardReturnKeyDone;
        case UIReturnKeyEmergencyCall: return kMMKeyboardReturnKeyEmergencyCall;
        case UIReturnKeyContinue: return kMMKeyboardReturnKeyContinue;
        default: return kMMKeyboardReturnKeyDefault;
    }
}

- (void)adjustKeyboardTypes
{
    switch (self.keyboardType)
    {
        case UIKeyboardTypeURL:
        case UIKeyboardTypeEmailAddress:
        case UIKeyboardTypeWebSearch:
        {
            self.view.altKey.keyIdentifier = kMMKeyboardDomainKeyIdentifier;
            [self.characterKeys addObject:self.view.altKey];
            [self.specialKeys removeObject:self.view.altKey];
            break;
        }
        case UIKeyboardTypeASCIICapable:
        {
            self.view.emojiKey.hidden = YES;
            self.view.altKey.hidden = YES;
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)textHasChanged
{
    if ([self.delegate enablesReturnKeyAutomatically])
    {
        NSString *lastText = [self.delegate keyboardViewControllerLastText:self];
        BOOL textEmpty = (lastText == nil) || [lastText isEqualToString:kMMKeyboardReturnCharacter];
        self.view.returnKey.enabled = !textEmpty;
    }
    else
    {
        self.view.returnKey.enabled = YES;
    }
    
    [self checkForCapitalization];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled)
    {
        self.suppressHighlight = NO;
    }
}

- (void)setKeyboardDesign:(MMKeyboardDesign *)keyboardDesign
{
    self.view.backgroundColor = keyboardDesign.backgroundColor;
    [self.view setBackgroundGradient:keyboardDesign.backgroundGradient];
    [self.view setBackgroundImage:keyboardDesign.backgroundImage];
    
    UIInterfaceOrientation orientation = [MMContainerViewController currentOrientation];
    
    if ((self.view.keyboardDesign != nil) && (self.view.keyboardDesign != keyboardDesign))
    {
        self.view.keyboardDesign = keyboardDesign;
        [self.view adjustFramesToInterfaceOrientation:orientation];
    }
    
    for (MMKeyView *key in self.characterKeys)
    {
        [keyboardDesign adjustKeyView:key isSpecial:NO];
    }
    
    for (MMKeyView *special in self.specialKeys)
    {
        [keyboardDesign adjustKeyView:special isSpecial:YES];
    }
    
    self.view.spaceKey.keyInfo.isSpecialKey = YES;
    [self updateKeyboardWithOrientation:orientation];
    [self setKeyboardKeyState:self.keyboardKeyStateCurrent];
}

- (BOOL)checkIfKeyIsEqualToAShiftKey:(MMKeyView *)keyview
{
    return self.view.shiftKey == keyview;
}

- (void)executeForShiftKeys:(void (^)(MMKeyView *))block
{
    block(self.view.shiftKey);
}

- (void)keyDidTouchAndHold:(MMKeyView *)keyView
{
    
}

- (void)checkForCapitalization
{
    if (self.capsLocked) return;
    
    BOOL capitalize = NO;
    MMKeyboardSettings *keyboardSettings = [MMKeyboardSettings instance];
    
    if ((keyboardSettings.enableAutoCapitalize) && (self.keyboardKeyStateCurrent == kMMKeyboardKeyStateNormal))
    {
        UITextAutocapitalizationType autocapitalizationType = [self.delegate autocapitalizationType];
        NSString *lastText = [self.delegate keyboardViewControllerLastText:self];
        
        switch (autocapitalizationType)
        {
            case UITextAutocapitalizationTypeNone: return;
            case UITextAutocapitalizationTypeWords:
            {
                if (lastText == nil || [lastText hasSuffix:kMMKeyboardSpaceCharacter] || [lastText hasSuffix:kMMKeyboardReturnCharacter])
                {
                    capitalize = YES;
                }
                break;
            }
            case UITextAutocapitalizationTypeSentences:
            {
                if (lastText == nil)
                {
                    capitalize = YES;
                }
                else if ([lastText hasSuffix:kMMKeyboardSpaceCharacter] || [lastText hasSuffix:kMMKeyboardReturnCharacter])
                {
                    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:kMMKeyboardTrimCharacterSet];
                    NSString *trimmedLastText = [lastText stringByTrimmingCharactersInSet:characterSet];
                    unichar lastChar = [trimmedLastText characterAtIndex:trimmedLastText.length - 1];
                    
                    if ([self isSentenceTerminator:lastChar])
                    {
                        capitalize = YES;
                    }
                }
                break;
            }
            case UITextAutocapitalizationTypeAllCharacters:
            {
                capitalize = YES;
                break;
            }
        }
    }
    
    self.shiftActive = capitalize;
    
    if (self.capitalized != capitalize)
    {
        [self setCapitalization:capitalize];
    }
}

- (BOOL)isSentenceTerminator:(unichar)character
{
    return (character == '.' || character == '!' || character == '?' || character == '0');
}

- (void)animateLabel:(UILabel *)label toString:(NSString *)string
{
    if ([label.text isEqualToString:string]) return;
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [label.layer addAnimation:animation forKey:@"kCATransitionFade"];
    label.text = string;
}

- (void)setCapitalization:(BOOL)capitalize
{
    self.capitalized = capitalize;
    [self executeForShiftKeys:^(MMKeyView *shiftKey)
    {
        [shiftKey highlight:capitalize];
    }];
    
    for (MMKeyView *keyView in self.characterKeys)
    {
        keyView.characterLabel.text = capitalize ? keyView.keyInfo.capitalizedCharacter : keyView.keyInfo.capitalizedCharacter.lowercaseString;
    }
}

- (NSString *)currentCharacterFromKeyView:(MMKeyInfo *)keyInfo
{
    if (keyInfo.isSpecialKey) return keyInfo.specialCharacter;
    
    switch (self.keyboardKeyStateCurrent)
    {
        case kMMKeyboardKeyStateNormal:
        {
            if (self.isCapitalized) return keyInfo.capitalizedCharacter;
            
            return keyInfo.character;
        }
        case kMMKeyboardKeyStateNumbers:
        {
            return keyInfo.numberCharacter;
        }
        case kMMKeyboardKeyStateAdditionals:
        {
            return keyInfo.additionalCharacter;
        }
    }
    
    return nil;
}

- (void)setCharacterKeysWithInfoBlock:(NSString *(^)(MMKeyInfo * info))keyInfoBlock
{
    MMKeyboardDesign *design = [self.dataSource requestCurrentKeyboardDesign:self];
    
    for (MMKeyView *keyView in self.allKeys)
    {
        NSString *character = keyInfoBlock(keyView.keyInfo);
        
        if (character)
        {
            keyView.characterLabel.text = character;
            keyView.labelMargins = design.designProperties.ButtonLabelMargins;
        }
    }
}

- (void)setKeyboardKeyState:(kMMKeyboardKeyState)keyboardKeyState
{
    self.capsLocked = NO;
    self.didInputCharacter = NO;
    self.keyboardKeyStateLast = self.keyboardKeyStateCurrent;
    self.keyboardKeyStateCurrent = keyboardKeyState;
    
    [self executeForShiftKeys:^(MMKeyView *shiftKey)
    {
        [shiftKey highlight:NO];
    }];
    
    switch (keyboardKeyState)
    {
        case kMMKeyboardKeyStateNormal:
        {
            NSString *(^characterBlock)(MMKeyInfo *) = ^NSString *(MMKeyInfo *info)
            {
                return info.capitalizedCharacter;
            };
            
            [self setCharacterKeysWithInfoBlock:characterBlock];
            [self executeForShiftKeys:^(MMKeyView *shiftKey)
            {
                shiftKey.foregroundImageView.hidden = NO;
                shiftKey.characterLabel.hidden = YES;
            }];
            
            [self textHasChanged];
            break;
        }
        case kMMKeyboardKeyStateNumbers:
        {
            [self setCharacterKeysWithInfoBlock:^NSString *(MMKeyInfo * info)
            {
                return info.numberCharacter;
            }];
            
            [self executeForShiftKeys:^(MMKeyView *shiftKey)
            {
                shiftKey.foregroundImageView.hidden = YES;
                shiftKey.characterLabel.hidden = NO;
            }];
            break;
        }
        case kMMKeyboardKeyStateAdditionals:
        {
            [self setCharacterKeysWithInfoBlock:^NSString *(MMKeyInfo * info)
            {
                return info.additionalCharacter;
            }];
            
            [self executeForShiftKeys:^(MMKeyView *shiftKey)
            {
                shiftKey.foregroundImageView.hidden = YES;
                shiftKey.characterLabel.hidden = NO;
            }];
            break;
        }
    }
}

- (void)writeCharacter:(NSString *)character
{
    if (character)
    {
        [self.delegate keyboardViewController:self insertText:character];

        if ((self.didInputCharacter) && ([character isEqualToString:kMMKeyboardSpaceCharacter]) && (self.keyboardKeyStateCurrent != kMMKeyboardKeyStateNormal))
        {
            [self setKeyboardKeyState:kMMKeyboardKeyStateNormal];
        }
        else if (![character isEqualToString:kMMKeyboardSpaceCharacter])
        {
            self.didInputCharacter = YES;
        }
        
        [self textHasChanged];
    }
}

- (void)writeKey:(MMKeyView *)key
{
    if (!key.enabled) return;
    
    if ((!self.suppressNextTouchUpDueToKeySwipe) && (self.view.userInteractionEnabled))
    {
        if (key != self.view.altKey)
        {
            NSString *character = [self currentCharacterFromKeyView:key.keyInfo];
            
            if (![character isEqualToString:kMMKeyboardSpaceCharacter])
            {
                self.spaceTouchCount = 0;
                self.repeatSpaceTouchTimeInterval = 0.0f;
            }
            
            [self writeCharacter:character];
        }
        
        [key highlightAnimation];
    }
    
    if (self.switchingKeyboardState)
    {
        if (key != [self.keyEvents.lastObject initialKey])
        {
            [self setKeyboardKeyState:self.keyboardKeyStateLast];
        }
    }
    
    self.suppressNextTouchUpDueToKeySwipe = NO;
}

- (void)keyViewDidSwipe:(MMKeyView *)keyView direction:(UISwipeGestureRecognizerDirection)direction
{
     if (keyView == self.view.spaceKey)
     {
         if (direction == UISwipeGestureRecognizerDirectionRight)
         {
             [self writeKey:keyView];
             self.suppressNextTouchUpDueToKeySwipe = YES;
             [self.delegate keyboardViewControllerDeleteLastCharacter:self];
         }
         else if (direction == UISwipeGestureRecognizerDirectionLeft)
         {
             self.suppressNextTouchUpDueToKeySwipe = YES;
         }
     }
}

- (void)keyViewDidTouchUpInside:(MMKeyView *)keyView
{
    if (keyView == self.view.nextKey)
    {
        [self.delegate keyboardViewControllerRequestsNextKeyboard:self];
    }
    else if ([self checkIfKeyIsEqualToAShiftKey:keyView])
    {
        if (self.keyboardKeyStateCurrent == kMMKeyboardKeyStateNormal)
        {
            if (self.lockingCaps)
            {
                self.capsLocked = YES;
                self.lockingCaps = NO;
                [self setCapitalization:YES];
                [self executeForShiftKeys:^(MMKeyView *shiftKey)
                {
                    [shiftKey setThirdState];
                }];
            }
            else
            {
                self.capsLocked = NO;
                
                if (self.shiftActive)
                {
                    [self setCapitalization:NO];
                }
                
                self.shiftActive = !self.shiftActive;
            }
        }
    }
    else if (keyView == self.view.emojiKey)
    {
        [self.delegate keyboardViewControllerRequestsiMojiKeyboard:self];
    }
    
    MMKeyboardSettings *keyboardSettings = [MMKeyboardSettings instance];
    
    if (keyboardSettings.enableDoubleSpacePunctuation)
    {
        if (keyView == self.view.spaceKey)
        {
            self.spaceTouchCount++;
            float currentInterval = CFAbsoluteTimeGetCurrent() - self.repeatSpaceTouchTimeInterval;
            
            if (self.spaceTouchCount == 1)
            {
                self.repeatSpaceTouchTimeInterval = CFAbsoluteTimeGetCurrent();
            }
            else if ((self.spaceTouchCount == 2) && (currentInterval <= kMMKeyboardDoubleTapSpaceIntervalForDot))
            {
                [self.delegate keyboardViewControllerAddDotAfterDoubleSpaceTap:self];
                
                self.spaceTouchCount = 0;
                self.repeatSpaceTouchTimeInterval = 0.0f;
            }
        }
        else
        {
            self.spaceTouchCount = 0;
            self.repeatSpaceTouchTimeInterval = 0.0f;
        }
    }
}

- (void)waitingForSwipe:(BOOL)waiting
{
    self.suppressHighlight = waiting;
    
    if (!waiting)
    {
        [self.activeKey highlight:YES];
    }
}

- (MMKeyView *)handleTouch:(CGPoint)touchLocation touchPhase:(UITouchPhase)touchPhase
{
    self.lastTouchLocation = touchLocation;
    
    if (!CGRectContainsPoint(self.widenedTouchArea, touchLocation))
    {
        MMKeyView *touchedKey = [self keyViewForTouchLocation:touchLocation];
        
        if ((!self.capitalized) || (![self checkIfKeyIsEqualToAShiftKey:self.activeKey]))
        {
            [self.activeKey highlight:NO];
        }
        
        CGRect keyFrame = touchedKey.frame;
        keyFrame.origin = [self.view convertPoint:keyFrame.origin fromView:[touchedKey superview]];
        
        if ((!isIPad()) && (touchPhase == UITouchPhaseBegan))
        {
            CGPoint offset = [self.touchBias offsetForLocation:touchLocation relativeView:self.view];
            keyFrame.origin.x += touchedKey.unitWidth * offset.x;
            keyFrame.origin.y += keyFrame.size.height * offset.y;
            
            [self.touchBias registerTouchAtLocation:touchLocation forKey:touchedKey relativeView:self.view];
        }
        
        self.widenedTouchAreaView.frame = keyFrame;
        CGFloat resizeFactor = [self keyViewScaleOnTouchFactor];
        keyFrame = CGRectInset(keyFrame, - keyFrame.size.width * resizeFactor, - keyFrame.size.height * resizeFactor);
        self.widenedTouchArea = keyFrame;
        
        if (!self.suppressHighlight)
        {
            [touchedKey highlight:YES];
        }
        
        self.activeKey = touchedKey;
    }
    
    return self.activeKey;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = touches.allObjects.firstObject;
    self.suppressNextTouchUpDueToKeySwipe = NO;
    
    CGPoint touchLocation = [touch locationInView:self.view];
    MMKeyView *touchedKey = [self handleTouch:touchLocation touchPhase:touch.phase];
    
    MMKeyEvent *keyEvent = [MMKeyEvent keyEventWithTouch:touch initialKey:touchedKey];
    [self.keyEvents addObject:keyEvent];
    [self endPreviousKeyEvents];
    
    if (touchedKey)
    {
        [MMAudioManager playClickSound];
    }
    
    if (touchedKey == self.view.deleteKey)
    {
        [self.delegate doNotDisturb:NO];
        [self.delegate keyboardViewControllerDeleteLastCharacter:self];
        [self textHasChanged];
    }
    else if ([self checkIfKeyIsEqualToAShiftKey:touchedKey])
    {
        [self.delegate doNotDisturb:NO];
        
        if (self.keyboardKeyStateCurrent != kMMKeyboardKeyStateNormal)
        {
            BOOL isNumbers = self.keyboardKeyStateCurrent == kMMKeyboardKeyStateNumbers;
            kMMKeyboardKeyState keyboardKeyState = isNumbers ? kMMKeyboardKeyStateAdditionals : kMMKeyboardKeyStateNumbers;
            
            self.switchingKeyboardState = YES;
            [self setKeyboardKeyState:keyboardKeyState];
        }
        else
        {
            [self setCapitalization:YES];
        }
    }
    else if (touchedKey == self.view.numbersKey)
    {
        [self.delegate doNotDisturb:NO];
        
        BOOL isNormal = self.keyboardKeyStateCurrent == kMMKeyboardKeyStateNormal;
        kMMKeyboardKeyState keyboardKeyState = isNormal ? kMMKeyboardKeyStateNumbers : kMMKeyboardKeyStateNormal;
        
        self.switchingKeyboardState = YES;
        [self setKeyboardKeyState:keyboardKeyState];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    MMKeyEvent *keyEvent = self.keyEvents.lastObject;
    
    for (UITouch *touch in touches.allObjects)
    {
        if (touch == keyEvent.touch)
        {
            CFAbsoluteTime current = CFAbsoluteTimeGetCurrent() - keyEvent.began;
            CGPoint touchLocation = [touch locationInView:self.view];
            
            if (current > kMMKeyboardTapThreshold)
            {
                keyEvent.currentKey = [self handleTouch:touchLocation touchPhase:touch.phase];
            }
            
            break;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    MMKeyEvent *keyEvent = self.keyEvents.lastObject;
    
    for (UITouch *touch in touches.allObjects)
    {
        if (touch == keyEvent.touch)
        {
            [self endKeyEvent:keyEvent];
            self.activeKey = nil;
            break;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self.keyEvents removeAllObjects];
    self.activeKey = nil;
    
    CGRect keyFrame = CGRectZero;
    self.widenedTouchArea = keyFrame;
    self.widenedTouchAreaView.frame = keyFrame;
    
    self.switchingKeyboardState = NO;
    self.suppressNextTouchUpDueToKeySwipe = NO;
}

- (void)endPreviousKeyEvents
{
    while (self.keyEvents.count > 1)
    {
        [self endKeyEvent:self.keyEvents[0]];
    }
}

- (void)endKeyEvent:(MMKeyEvent *)keyEvent
{
    if (!self.suppressNextTouchUpDueToKeySwipe)
    {
         [self writeKey:keyEvent.currentKey];
     }
    
    if (![self checkIfKeyIsEqualToAShiftKey:keyEvent.currentKey] || (self.keyboardKeyStateCurrent != kMMKeyboardKeyStateNormal))
    {
        [keyEvent.currentKey highlight:NO];
    }
    
    self.switchingKeyboardState = NO;
    self.suppressNextTouchUpDueToKeySwipe = NO;
    
    CGRect keyFrame = CGRectZero;
    self.widenedTouchArea = keyFrame;
    self.widenedTouchAreaView.frame = keyFrame;
    
    [self.delegate doNotDisturb:YES];
    [self.keyEvents removeObject:keyEvent];
}

@end
