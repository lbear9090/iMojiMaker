//
//  MMKeyboardView.m
//  Keyboard
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Utilities.h"
#import "MMKeyboardView.h"
#import "MMGradientView.h"
#import "MMKeyboardDesign.h"
#import "MMBackgroundImageView.h"
#import "MMContainerViewController.h"

static CGFloat const kAltKeyMultiplierShown = 1.0f;
static CGFloat const kSpaceKeyMultiplierWhenAltHiddenIPhone = 4.5f;
static CGFloat const kSpaceKeyMultiplierWhenAltHiddenIPad = 6.5f;

static NSString *const kAltKeyName = @"alt";
static NSString *const kNextKeyName = @"next";
static NSString *const kReturnKeyName = @"return";
static NSString *const kShiftKeyName = @"shift";
static NSString *const kRightShiftKeyName = @"rshift";
static NSString *const kDismissKeyName = @"dismiss";
static NSString *const kiMojiKeyName = @":)";
static NSString *const kDeleteKeyName = @"delete";
static NSString *const kNumberKeyName = @"123";

@interface MMKeyboardView ()
@property (nonatomic, strong) IBOutletCollection(UIView) NSMutableArray *rows;
@property (nonatomic, weak) IBOutlet UIView *topRow;
@property (nonatomic, weak) IBOutlet UIView *middleRow;
@property (nonatomic, weak) IBOutlet UIView *bottomRow;
@property (nonatomic, weak) IBOutlet UIView *baseRow;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topPadding;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomPadding;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leftPadding;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightPadding;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *altKeyWidth;
@property (nonatomic, strong) UIView *paddedView;
@property (nonatomic, assign) UIInterfaceOrientation lastOrientation;
@property (nonatomic, assign) NSUInteger numberOfUnitsPerRow;
@property (nonatomic, assign) CGSize lastKeyboardSize;
@property (nonatomic, assign) BOOL useConstraints;
@end

@implementation MMKeyboardView
@dynamic useConstraints;

- (MMKeyboardView *)initWithFrame:(CGRect)frame delegate:(id<MMKeyViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate;
        [self setup];
        [self buildKeyboard];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setup];
}

- (void)layoutSubviews
{
    if (!self.useConstraints)
    {
        UIInterfaceOrientation orientation = [MMContainerViewController currentOrientation];
        
        if ((orientation != self.lastOrientation) || (self.frame.size.width != self.lastKeyboardSize.width) || (self.frame.size.height != self.lastKeyboardSize.height))
        {
            [self adjustFramesToInterfaceOrientation:orientation];
        }
    }
    
    [super layoutSubviews];
}

- (void)adjustToNewInterfaceOrientation:(UIInterfaceOrientation)orientation keyboardDesign:(MMKeyboardDesign *)keyboardDesign
{
    self.keyboardDesign = keyboardDesign;
    
    if (self.useConstraints)
    {
        UIEdgeInsets padding = [keyboardDesign keyboardMarginsForOrientation:orientation];
        [self adjustConstraintsToNewPaddingMargins:padding];
    }
}

- (void)adjustFramesToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    UIEdgeInsets padding = [self.keyboardDesign keyboardMarginsForOrientation:orientation];
    self.lastKeyboardSize = CGSizeMake(self.inputView.frame.size.width, [MMContainerViewController heightForInterfaceOrientation:orientation]);

    CGFloat additionalTopHeight = [MMContainerViewController correctionForInterfaceOrientation:orientation];
    CGRect backgroundFrame = CGRectMake(0.0f, 0.0f, self.lastKeyboardSize.width, self.lastKeyboardSize.height);
    self.backgroundImageView.frame = backgroundFrame;
    self.backgroundGradientView.frame = backgroundFrame;
    
    [self setKeyboardPadding:padding frame:backgroundFrame additionalTopHeight:additionalTopHeight];

    CGFloat rowHeight = self.paddedView.frame.size.height / self.rows.count;

    for (NSUInteger row = 0; row < self.rows.count; row++)
    {
        UIView *rowView = self.rows[row];
        rowView.frame = CGRectMake(0.0f, rowHeight * row, self.paddedView.frame.size.width, rowHeight);
        NSInteger keyCount = rowView.subviews.count;
        CGFloat keyWidth = rowView.frame.size.width / self.numberOfUnitsPerRow;

        CGFloat keyPosition = 0.0f;

        for (NSUInteger key = 0; key < keyCount; key++)
        {
            MMEmptyKeyView *keyView = rowView.subviews[key];
            keyView.unitWidth = keyWidth;
            CGFloat width = keyWidth * keyView.sizeMultiplier;

            CGRect newFrame = CGRectMake(keyPosition, 0.0f, width, rowHeight);
            keyPosition += width;
            [keyView adjustFrame:newFrame];

            if ([keyView isKindOfClass:[MMKeyView class]])
            {
                [self.keyboardDesign adjustKeyView:(MMKeyView *)keyView withOrientation:orientation];
            }
        }
    }
    
    self.lastOrientation = orientation;
}

- (void)setKeyboardPadding:(UIEdgeInsets)padding frame:(CGRect)backgroundFrame additionalTopHeight:(CGFloat)additionalHeight
{
    CGFloat width = backgroundFrame.size.width - padding.left - padding.right;
    CGFloat height = backgroundFrame.size.height - padding.top - padding.bottom - additionalHeight;
    CGRect frame = CGRectMake(padding.left, additionalHeight + padding.top, width, height);
    self.paddedView.frame = frame;
}

- (UIView *)topMostView:(UIView *)view
{
    if (view.superview != nil) return [self topMostView:view.superview];
    
    return view;
}

- (void)adjustConstraintsToNewPaddingMargins:(UIEdgeInsets)margins
{
    self.topPadding.constant = margins.top;
    self.bottomPadding.constant = margins.bottom;
    self.leftPadding.constant = margins.left;
    self.rightPadding.constant = margins.right;
}

- (void)setup
{
    self.numberOfUnitsPerRow = isIPad() ? 11 : 10;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.35f;
    self.layer.shadowRadius = 4.0f;
    self.layer.shadowOffset = CGSizeZero;
}

- (void)buildKeyboard
{
    BOOL isiPad = isIPad();
    self.characterKeys = [NSMutableArray array];
    self.specialKeys = [NSMutableArray array];
    
    NSArray *layout = [self keyboardLayout];
    UIView *parentView = [self topMostView:self];
    UIInterfaceOrientation orientation = [MMContainerViewController currentOrientation];
    CGFloat correctionHeight = [MMContainerViewController correctionForInterfaceOrientation:orientation];
    CGSize propableSize = CGSizeMake(parentView.frame.size.width, [MMContainerViewController heightForInterfaceOrientation:orientation]);
    self.paddedView = [[UIView alloc] initWithFrame:CGRectMake(0, correctionHeight, propableSize.width, propableSize.height - correctionHeight)];
    [self addSubview:self.paddedView];
    
    NSUInteger numberOfRows = layout.count;
    self.rows = [NSMutableArray arrayWithCapacity:numberOfRows];
    
    CGFloat additionalLeftPadding = 0.0;
    CGFloat rowHeight = floorf(self.paddedView.frame.size.height / (CGFloat)numberOfRows);
    
    for (NSUInteger row = 0; row < layout.count; row++)
    {
        UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f + row * rowHeight, self.paddedView.frame.size.width, rowHeight)];
        [self.paddedView addSubview:rowView];
        [self.rows addObject:rowView];
        
        NSArray *rowLayout = layout[row];
        
        CGFloat xPos = 0.0;
        CGFloat unitWidth = rowView.frame.size.width / self.numberOfUnitsPerRow;
        CGFloat keyHeight = rowView.frame.size.height;
        
        MMKeyView *keyView = nil;
        
        for (NSUInteger key = 0; key < rowLayout.count; key++)
        {
            if ([rowLayout[key] isKindOfClass:[NSNumber class]])
            {
                CGFloat multiplier = [rowLayout[key] floatValue];
                CGFloat keyWidth = unitWidth * multiplier;
                
                if (key == 0)
                {
                    additionalLeftPadding = multiplier;
                }
                else if (key == rowLayout.count - 1)
                {
                    keyView.sizeMultiplier += multiplier;
                    keyView.additionalRightPadding = multiplier;
                    keyView.backgroundImageMargins = keyView.backgroundImageMargins;
                }
                else
                {
                    CGRect keyFrame = CGRectMake(xPos, 0.0f, keyWidth, rowHeight);
                    MMEmptyKeyView *keyView = [[MMEmptyKeyView alloc] initWithFrame:keyFrame keyIdentifier:nil sizeMultiplier:multiplier];
                    [rowView addSubview:keyView];
                }
                
                xPos += keyWidth;
            }
            else
            {
                NSString *keyIdentifier = rowLayout[key];
                
                if (keyIdentifier.length == 1)
                {
                    keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:1 isSpecial:NO];
                    
                    if (additionalLeftPadding > 0)
                    {
                        keyView.sizeMultiplier += additionalLeftPadding;
                        keyView.additionalLeftPadding = additionalLeftPadding;
                        keyView.backgroundImageMargins = keyView.backgroundImageMargins;
                        additionalLeftPadding = 0.0;
                    }
                    
                    [rowView addSubview:keyView];
                    xPos += unitWidth;
                }
                else
                {
                    CGFloat multiplier = 0.0;
                    
                    if ([keyIdentifier isEqualToString:kSpaceKeyName])
                    {
                        multiplier = isiPad ? 5.5 : 4.5;
                        self.spaceKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:NO];
                        CGFloat hiddenMultiplier = isiPad ? kSpaceKeyMultiplierWhenAltHiddenIPad : kSpaceKeyMultiplierWhenAltHiddenIPhone;
                        self.spaceKey.multiplierOverride = [NSNumber numberWithFloat:hiddenMultiplier];
                    }
                    else if ([keyIdentifier isEqualToString:kAltKeyName])
                    {
                        multiplier = isiPad ? 1.0 : 1.25;
                        self.altKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:YES];
                        self.altKey.multiplierOverride = [NSNumber numberWithFloat:0];
                        self.altKey.hidden = YES;
                    }
                    else if ([keyIdentifier isEqualToString:kNextKeyName])
                    {
                        multiplier = 1.0;
                        self.nextKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:YES];
                    }
                    else if ([keyIdentifier isEqualToString:kReturnKeyName])
                    {
                        multiplier = isiPad ? 1.5f : 2.0;
                        self.returnKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:YES];
                    }
                    else if ([keyIdentifier isEqualToString:kShiftKeyName])
                    {
                        multiplier = isiPad ? 1.0 : 1.25;
                        self.shiftKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:YES];
                    }
                    else if ([keyIdentifier isEqualToString:kRightShiftKeyName])
                    {
                        multiplier = 1.0;
                        self.rightShiftKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:kShiftKeyName sizeMultiplier:multiplier isSpecial:YES];
                    }
                    else if ([keyIdentifier isEqualToString:kiMojiKeyName])
                    {
                        multiplier = 1.25;
                        self.emojiKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:YES];
                    }
                    else if ([keyIdentifier isEqualToString:kDismissKeyName])
                    {
                        multiplier = 1.0;
                        self.dismissKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:YES];
                    }
                    else if ([keyIdentifier isEqualToString:kDeleteKeyName])
                    {
                        multiplier = isiPad ? 1.0 : 1.25;
                        self.deleteKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:YES];
                    }
                    else if ([keyIdentifier isEqualToString:kNumberKeyName])
                    {
                        multiplier = 1.25;
                        self.numbersKey = keyView = [self keyViewWithPositionX:xPos unitWidth:unitWidth height:keyHeight keyIdentifier:keyIdentifier sizeMultiplier:multiplier isSpecial:YES];
                    }
                    
                    [rowView addSubview:keyView];
                    
                    xPos += unitWidth * multiplier;
                }
            }
        }
    }
}

- (MMKeyView *)keyViewWithPositionX:(CGFloat)x unitWidth:(CGFloat)width height:(CGFloat)height keyIdentifier:(NSString *)keyIdentifier sizeMultiplier:(CGFloat)multiplier isSpecial:(BOOL)isSpecial
{
    CGRect keyFrame = CGRectMake(x, 0.0f, width * multiplier, height);
    MMKeyView *keyView = [[MMKeyView alloc] initWithFrame:keyFrame keyIdentifier:keyIdentifier sizeMultiplier:multiplier];
    keyView.unitWidth = width;
    keyView.delegate = self.delegate;
    
    if (isSpecial)
    {
        [self.specialKeys addObject:keyView];
    }
    else
    {
        [self.characterKeys addObject:keyView];
    }
    
    return keyView;
}

- (NSLayoutConstraint *)widthConstraintForBaseKey:(MMKeyView *)key multiplier:(CGFloat)multiplier
{
    return [NSLayoutConstraint constraintWithItem:key
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.baseRow
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:multiplier
                                         constant:1.0f];
}

- (void)setAltKeyHidden:(BOOL)altKeyHidden
{
    if (altKeyHidden != _altKeyHidden)
    {
        _altKeyHidden = altKeyHidden;
        CGFloat altKeyMultiplier = altKeyHidden ? 0.0f : kAltKeyMultiplierShown / self.numberOfUnitsPerRow;
        
        if (self.useConstraints)
        {
            MMKeyView *altKey = self.altKeyWidth.firstItem;
            
            if (self.useConstraints)
            {
                [self.baseRow removeConstraint:self.altKeyWidth];
            }
            
            NSLayoutConstraint *newConstraint = [self widthConstraintForBaseKey:altKey multiplier:altKeyMultiplier];
            [altKey deactivateConflictingConstraint:altKeyHidden];
            [self.baseRow addConstraint:newConstraint];
            self.altKeyWidth = newConstraint;
            altKey.hidden = altKeyHidden;
        }
        else
        {
            if (altKeyHidden)
            {
                CGFloat spaceBarMultiplier = isIPad() ? kSpaceKeyMultiplierWhenAltHiddenIPad : kSpaceKeyMultiplierWhenAltHiddenIPhone;
                self.spaceKey.multiplierOverride = [NSNumber numberWithFloat:spaceBarMultiplier];
                self.altKey.multiplierOverride = @(0.0);
            }
            else
            {
                self.spaceKey.multiplierOverride = nil;
                self.altKey.multiplierOverride = nil;
            }
            
            self.altKey.hidden = altKeyHidden;
            self.lastKeyboardSize = CGSizeZero;
            
            [self layoutSubviews];
        }
    }
}

- (NSArray *)keyboardLayout
{
    if (isIPad())
    {
        return @[@[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"delete"],
                 @[@0.5f, @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"return"],
                 @[@"shift", @"Z", @"X", @"C", @"V", @"B", @"N", @"M", @",", @"." ,@"rshift"],
                 @[@"123", @":)", @"space", @"alt", @"next", @"dismiss"]];
    }
    
    return @[@[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P"],
             @[@0.5f, @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @0.5f],
             @[@"shift", @0.25f, @"Z", @"X", @"C", @"V", @"B", @"N", @"M", @0.25f, @"delete"],
             @[@"123", @":)", @"next", @"space", @"alt", @"return"]];
}

@end
