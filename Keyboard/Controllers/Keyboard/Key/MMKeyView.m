//
//  MMKeyView.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyView.h"
#import "MMUIHelper.h"
#import "MMAudioManager.h"
#import "MMKeyboardDesign.h"

NSString *const kSpaceKeyName = @"space";

static const CFTimeInterval kMaxDurationForSwipeRecognition = 0.3f;
static const CGFloat kAnimationDistanceOnHighlightLabel = 5.0f;
static const CGFloat kAnimationDistanceOnHighlightBackgroundImage = 2.0f;

@interface MMKeyView ()

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL useConstraints;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backgroundImageTopMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backgroundImageLeftMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backgroundImageBottomMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backgroundImageRightMargin;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *leftMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *rightMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomMargin;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *backgroundImageHighlighted;

@property (nonatomic, strong) UIImage *foregroundImage;
@property (nonatomic, strong) UIImage *foregroundImageHighlighted;
@property (nonatomic, strong) UIImage *foregroundImageThirdState;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRightGestureRecognizer;
@property (nonatomic, assign) UISwipeGestureRecognizerDirection swipeGestureRegistered;

@property (nonatomic, strong) NSTimer *swipeTimer;
@property (nonatomic, assign) BOOL swipeTimerElapsed;

@property (nonatomic, assign) BOOL touchIsWithinView;
@property (nonatomic, assign) BOOL waitingForSwipe;

@end

@implementation MMKeyView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self additionalInitialisation];
    }
    
    return self;
}

- (MMKeyView *)initWithFrame:(CGRect)frame keyIdentifier:(NSString *)keyIdentifier sizeMultiplier:(CGFloat)multiplier
{
    self = [super initWithFrame:frame keyIdentifier:keyIdentifier sizeMultiplier:multiplier];
    if (self)
    {
        self.useConstraints = NO;
        self.keyIdentifier = keyIdentifier;
        [self additionalInitialisation];
        [self addBackgroundImageView];
    }
    
    return self;
}

- (void)additionalInitialisation
{
    self.enabled = YES;
    self.swipeGestureRegistered = -1;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.useConstraints = YES;
    
    for (NSLayoutConstraint *constraint in self.constraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeTop)
        {
            self.topMargin = constraint;
        }
        else if (constraint.firstAttribute == NSLayoutAttributeTrailing)
        {
            self.rightMargin = constraint;
        }
        else if (constraint.firstAttribute == NSLayoutAttributeBottom)
        {
            self.bottomMargin = constraint;
        }
        else if (constraint.firstAttribute == NSLayoutAttributeLeading)
        {
            self.leftMargin = constraint;
        }
    }
    
    [self addBackgroundImageView];
    
    self.backgroundImageTopMargin = [MMUIHelper snapTopConstraintInView:self.backgroundImageView forView:self];
    self.backgroundImageRightMargin = [MMUIHelper snapRightConstraintInView:self forView:self.backgroundImageView];
    self.backgroundImageLeftMargin = [MMUIHelper snapLeftConstraintInView:self.backgroundImageView forView:self];
    self.backgroundImageBottomMargin = [MMUIHelper snapBottomConstraintInView:self forView:self.backgroundImageView];
    
    [self addConstraints:@[self.backgroundImageTopMargin, self.backgroundImageRightMargin, self.backgroundImageLeftMargin, self.backgroundImageBottomMargin]];
    
    [self checkKeyIdentifier];
}

- (void)addBackgroundImageView
{
    self.backgroundImageView = [[UIImageView alloc] init];
    
    if (self.useConstraints)
    {
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self insertSubview:self.backgroundImageView atIndex:0];
    
}

- (void)setBackgroundImages:(UIImage *)image highlighted:(UIImage *)highlighted margins:(UIEdgeInsets)margins
{
    self.backgroundImage = image;
    self.backgroundImageHighlighted = highlighted;
    self.backgroundImageView.image = image;
    [self setBackgroundImageMargins:margins];
}

- (void)setButtonImage:(UIImage *)image highlighted:(UIImage *)highlighted thirdState:(UIImage *)thirdState
{
    if (!image)
    {
        [self.foregroundImageView removeFromSuperview];
        
        self.foregroundImageView = nil;
        self.foregroundImage = nil;
        self.foregroundImageHighlighted = nil;
        self.characterLabel.hidden = NO;
        
        return;
    }
    
    if (!self.foregroundImageView)
    {
        self.foregroundImageView = [[UIImageView alloc] init];
        
        if (self.useConstraints)
        {
            self.foregroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        [self addSubview:self.foregroundImageView];
        
        if (self.useConstraints)
        {
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.foregroundImageView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1.0f
                                                                        constant:0.0f];
            
            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.foregroundImageView
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1.0f
                                                                        constant:0.0f];
            
            [self addConstraints:@[centerX, centerY]];
            
            NSLayoutConstraint *width = [MMUIHelper widthConstraintForView:self.foregroundImageView width:0.0f];
            NSLayoutConstraint *height = [MMUIHelper heightConstraintForView:self.foregroundImageView height:0.0f];
            [self.foregroundImageView addConstraints:@[width, height]];
        }
        else
        {
            self.foregroundImageView.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
            self.foregroundImageView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        }
    }
    
    self.foregroundImage = image;
    self.foregroundImageHighlighted = highlighted ? highlighted : self.foregroundImage;
    self.foregroundImageThirdState = thirdState ? thirdState : self.foregroundImage;
    
    [self adjustForegroundImage:self.foregroundImage];
    
    self.characterLabel.hidden = YES;
}

- (void)addDoubleTapTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.delaysTouchesBegan = NO;
    doubleTapRecognizer.delaysTouchesEnded = NO;
    doubleTapRecognizer.cancelsTouchesInView = NO;
    
    [self addGestureRecognizer:doubleTapRecognizer];
}

- (void)deactivateConflictingConstraint:(BOOL)deactivate
{
    if (!self.useConstraints) return;
    
    [self.backgroundImageRightMargin setActive:!deactivate];
}

- (void)highlight:(BOOL)highlighted
{
    if (!self.enabled) return;
    
    if (highlighted)
    {
        self.backgroundImageView.image = self.backgroundImageHighlighted;
        
        if (self.foregroundImageView)
        {
            [self adjustForegroundImage:self.foregroundImageHighlighted];
        }
        
        if (!self.keyInfo.dontEnlargeOnHighlight)
        {
            if (self.useConstraints)
            {
                self.backgroundImageLeftMargin.constant = self.backgroundImageMargins.left - kAnimationDistanceOnHighlightBackgroundImage;
                self.backgroundImageRightMargin.constant = self.backgroundImageMargins.right - kAnimationDistanceOnHighlightBackgroundImage;
                self.backgroundImageTopMargin.constant = self.backgroundImageMargins.top - kAnimationDistanceOnHighlightBackgroundImage;
                self.backgroundImageBottomMargin.constant = self.backgroundImageMargins.bottom - kAnimationDistanceOnHighlightBackgroundImage;
            }
            else
            {
                CGFloat topInset = self.backgroundImageMargins.top - kAnimationDistanceOnHighlightBackgroundImage;
                CGFloat leftInset = self.backgroundImageMargins.left - kAnimationDistanceOnHighlightBackgroundImage;
                CGFloat bottomInset = self.backgroundImageMargins.bottom - kAnimationDistanceOnHighlightBackgroundImage;
                CGFloat rightInset = self.backgroundImageMargins.right - kAnimationDistanceOnHighlightBackgroundImage;
                UIEdgeInsets newMargins = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);
                
                [self setBackgroundImageFrames:newMargins];
            }
        }
    }
    else if (!highlighted && self.highlighted)
    {
        self.backgroundImageView.image = self.backgroundImage;
        
        if (self.foregroundImageView)
        {
            [self adjustForegroundImage:self.foregroundImage];
        }
        
        if (!self.keyInfo.dontEnlargeOnHighlight)
        {
            if (self.useConstraints)
            {
                self.backgroundImageLeftMargin.constant = self.backgroundImageMargins.left;
                self.backgroundImageRightMargin.constant = self.backgroundImageMargins.right;
                self.backgroundImageTopMargin.constant = self.backgroundImageMargins.top;
                self.backgroundImageBottomMargin.constant = self.backgroundImageMargins.bottom;
                
                [UIView animateWithDuration:.2f animations:^
                {
                    [self layoutIfNeeded];
                } completion:nil];
            }
            else
            {
                [UIView animateWithDuration:.2f animations:^
                {
                    self.backgroundImageMargins = self->_backgroundImageMargins;
                } completion:nil];
            }
        }
    }
    
    self.highlighted = highlighted;
}

- (void)highlightAnimation
{
    if (!self.enabled) return;
    
    if (self.useConstraints)
    {
        self.topMargin.constant = self.labelMargins.top - kAnimationDistanceOnHighlightLabel;
        self.bottomMargin.constant = self.labelMargins.bottom + kAnimationDistanceOnHighlightLabel;
        
        [self layoutIfNeeded];
        
        self.topMargin.constant = self.labelMargins.top;
        self.bottomMargin.constant = self.labelMargins.bottom;
        
        [UIView animateWithDuration:.2f animations:^
        {
            [self layoutIfNeeded];
        } completion:nil];
    }
    else
    {
        CGRect labelFrame = CGRectMake(self.characterLabel.frame.origin.x,
                                       self.labelMargins.top - kAnimationDistanceOnHighlightLabel,
                                       self.characterLabel.frame.size.width,
                                       self.characterLabel.frame.size.height);
        
        self.characterLabel.frame = labelFrame;
        
        [UIView animateWithDuration:.2f animations:^
        {
            self.characterLabel.frame = CGRectMake(self.characterLabel.frame.origin.x,
                                                   self.labelMargins.top,
                                                   self.characterLabel.frame.size.width,
                                                   self.characterLabel.frame.size.height);
        } completion:nil];
    }
}

- (void)addLeftSwipe
{
    self.swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(registerSwipe:)];
    self.swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swipeLeftGestureRecognizer.delaysTouchesBegan = NO;
    self.swipeLeftGestureRecognizer.delaysTouchesEnded = NO;
    self.swipeLeftGestureRecognizer.cancelsTouchesInView = NO;
    self.swipeLeftGestureRecognizer.delegate = self;
    
    [self addGestureRecognizer:self.swipeLeftGestureRecognizer];
}

- (void)addRightSwipe
{
    self.swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(registerSwipe:)];
    self.swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    self.swipeRightGestureRecognizer.delaysTouchesBegan = NO;
    self.swipeRightGestureRecognizer.delaysTouchesEnded = NO;
    self.swipeRightGestureRecognizer.cancelsTouchesInView = NO;
    self.swipeRightGestureRecognizer.delegate = self;
    
    [self addGestureRecognizer:self.swipeRightGestureRecognizer];
}

- (void)setThirdState
{
    if (self.foregroundImageThirdState)
    {
        [self adjustForegroundImage:self.foregroundImageThirdState];
    }
}

- (void)adjustFrame:(CGRect)newFrame
{
    [super adjustFrame:newFrame];
    
    self.labelMargins = _labelMargins;
    self.backgroundImageMargins = _backgroundImageMargins;
    self.foregroundImageView.center = CGPointMake(newFrame.size.width / 2.0, newFrame.size.height / 2.0);
}

- (void)adjustForegroundImage:(UIImage *)newImage
{
    self.foregroundImageView.image = newImage;
    
    if (self.useConstraints)
    {
        for (NSLayoutConstraint *constraint in self.foregroundImageView.constraints)
        {
            if (constraint.firstAttribute == NSLayoutAttributeHeight)
            {
                constraint.constant = newImage.size.height;
            }
            else if (constraint.firstAttribute == NSLayoutAttributeWidth)
            {
                constraint.constant = newImage.size.width;
            }
        }
        
        [self updateConstraints];
    }
    else
    {
        self.foregroundImageView.frame = CGRectMake(0.0f, 0.0f, newImage.size.width, newImage.size.height);
        self.foregroundImageView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    }
}

- (UIColor *)halfAlphaColorForColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    
    if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) return nil;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha / 2.0];
}

- (void)cleanupTimer
{
    [self.swipeTimer invalidate];
    self.swipeTimer = nil;
}

- (void)swipeTimerElapsed:(NSTimer *)timer
{
    if (self.waitingForSwipe)
    {
        [self.delegate waitingForSwipe:NO];
        self.waitingForSwipe = NO;
    }
    
    self.swipeTimerElapsed = YES;
    
    if (!self.touchIsWithinView)
    {
        [self highlight:NO];
    }
}

- (void)checkKeyIdentifier
{
    if ([self.keyIdentifier isEqualToString:kSpaceKeyName])
    {
        _displaysPreview = NO;
    }
    else
    {
        _displaysPreview = YES;
    }
}

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (!self.enabled) return;
    
    [MMAudioManager playClickSound];
    
    if (self.swipeUpGestureRecognizer)
    {
        self.swipeTimerElapsed = NO;
        self.swipeTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxDurationForSwipeRecognition
                                                           target:self
                                                         selector:@selector(swipeTimerElapsed:)
                                                         userInfo:nil
                                                          repeats:NO];
    }
}

- (void)checkIfTouchInView:(UITouch *)touch
{
    self.touchIsWithinView = CGRectContainsPoint(self.bounds, [touch locationInView:self]);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self checkIfTouchInView:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.enabled)
    {
        [self checkIfTouchInView:[touches anyObject]];
        
        if (!self.swipeTimerElapsed && (int)self.swipeGestureRegistered >= 0)
        {
            [self.delegate keyViewDidSwipe:self direction:self.swipeGestureRegistered];
        }
        else if (self.touchIsWithinView)
        {
            [self.delegate keyViewDidTouchUpInside:self];
        }
    }
    
    self.swipeGestureRegistered = -1;
    [self cleanupTimer];
    
    if (self.waitingForSwipe)
    {
        [self.delegate waitingForSwipe:NO];
        self.waitingForSwipe = NO;
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.swipeGestureRegistered = -1;
    [self cleanupTimer];
    
    [super touchesCancelled:touches withEvent:event];
}

- (void)registerSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    self.swipeGestureRegistered = gestureRecognizer.direction;
}

- (NSString *)keyIdentifier
{
    if (!_keyIdentifier)
    {
        _keyIdentifier = self.characterLabel.text;
    }
    
    return _keyIdentifier;
}

- (void)keyIdentifier:(NSString *)keyIdentifier
{
    _keyIdentifier = keyIdentifier;
    
    [self checkKeyIdentifier];
}

- (void)setKeyInfo:(MMKeyInfo *)keyInfo
{
    if (!keyInfo)
    {
        _keyInfo = nil;
        
        [self removeGestureRecognizer:self.swipeUpGestureRecognizer];
        self.swipeUpGestureRecognizer = nil;
        
        return;
    }
    
    _keyInfo = keyInfo;
    
    if (!self.characterLabel)
    {
        self.characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.characterLabel];
    }
    
    self.characterLabel.text = self.keyInfo.displayCharacter;
}

- (void)setLabelMargins:(UIEdgeInsets)labelMargins
{
    _labelMargins = labelMargins;
    
    if (self.useConstraints)
    {
        [self setLabelConstraints:labelMargins];
    }
    else
    {
        [self setLabelFrames:labelMargins];
    }
}

- (void)setLabelConstraints:(UIEdgeInsets)margins
{
    self.leftMargin.constant = margins.left;
    self.rightMargin.constant = margins.right;
    self.topMargin.constant = margins.top;
    self.bottomMargin.constant = margins.bottom;
}

- (void)setLabelFrames:(UIEdgeInsets)margins
{
    CGFloat additionalLeft = self.additionalLeftPadding * self.unitWidth;
    CGFloat additionalRight = self.additionalRightPadding * self.unitWidth;
    
    self.characterLabel.frame = CGRectMake(margins.left + additionalLeft,
                                           margins.top,
                                           self.frame.size.width - margins.left - margins.right - additionalLeft - additionalRight,
                                           self.frame.size.height - margins.top - margins.bottom);
}

- (void)setBackgroundImageMargins:(UIEdgeInsets)margins
{
    _backgroundImageMargins = margins;
    
    if (self.useConstraints)
    {
        [self setBackgroundImageConstaints:margins];
    }
    else
    {
        [self setBackgroundImageFrames:margins];
    }
}

- (void)setBackgroundImageFrames:(UIEdgeInsets)margins
{
    CGFloat additionalLeftPadding = self.unitWidth * self.additionalLeftPadding;
    CGFloat additionalRightPadding = self.unitWidth * self.additionalRightPadding;
    CGRect newFrame = CGRectMake(margins.left + additionalLeftPadding,
                                 margins.top,
                                 self.frame.size.width - margins.left - margins.right - additionalLeftPadding - additionalRightPadding,
                                 self.frame.size.height - margins.top - margins.bottom);
    
    self.backgroundImageView.frame = newFrame;
}

- (void)setBackgroundImageConstaints:(UIEdgeInsets)margins
{
    self.backgroundImageLeftMargin.constant = margins.left;
    self.backgroundImageRightMargin.constant = margins.right;
    self.backgroundImageTopMargin.constant = margins.top;
    self.backgroundImageBottomMargin.constant = margins.bottom;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    if (enabled)
    {
        self.characterLabel.textColor = self.design.designProperties.buttonLabelTextColor;
        self.backgroundImageView.alpha = 1.0f;
        self.foregroundImageView.alpha = 1.0f;
    }
    else
    {
        self.characterLabel.textColor = [self halfAlphaColorForColor:self.design.designProperties.buttonLabelTextColor];
        self.backgroundImageView.alpha = 0.4f;
        self.foregroundImageView.alpha = 0.4f;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.swipeTimerElapsed) return NO;
    
    [self.delegate waitingForSwipe:YES];
    self.waitingForSwipe = YES;
    
    return YES;
}

@end
