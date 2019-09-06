//
//  ShopBuyButton.m
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ShopBuyButton.h"
#import "ShopBuyBorderedButton.h"
#import "ShopBuyRoundedActivityIndicatorView.h"

@implementation ShopBuyButton
{
    ShopBuyBorderedButton *_button;
    ShopBuyRoundedActivityIndicatorView *_activityIndicatorView;
    
    NSString *_normalTitle;
    NSString *_confirmationTitle;
    
    NSAttributedString *_attributedNormalTitle;
    NSAttributedString *_attributedConfirmationTitle;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.clearsContextBeforeDrawing = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.confirmationColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    
    _button = [[ShopBuyBorderedButton alloc] initWithFrame:self.bounds];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _button.userInteractionEnabled = NO;
    [self addSubview:_button];
    
    _activityIndicatorView = [[ShopBuyRoundedActivityIndicatorView alloc] init];
    _activityIndicatorView.userInteractionEnabled = NO;
    [self addSubview:_activityIndicatorView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat progressSize = self.bounds.size.height;
    CGRect progressFrame = CGRectMake(self.bounds.size.width - progressSize,0, progressSize, progressSize);
    _activityIndicatorView.frame = progressFrame;
    
    if (self.buttonState != ShopBuyButtonStateProgress)
    {
        _button.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    else
    {
        _button.frame = progressFrame;
    }
}

- (void)setImage:(UIImage *)image
{
    _button.image = image;
}

- (UIImage *)image
{
    return _button.image;
}

- (void)setButtonState:(ShopBuyButtonState)buttonState
{
    [self setButtonState:buttonState animated:NO];
}

- (void)stopProgressAnimation
{
    _activityIndicatorView.alpha = 0;
    _button.alpha = 1;
    [_activityIndicatorView stopAnimating];
}

- (void)configureButtonForProgressState
{
    _button.cornerRadius = self.bounds.size.height / 2.0;
    _button.titleEdgeInsets = UIEdgeInsetsMake(0, self.bounds.size.height, 0, -(self.bounds.size.width - self.bounds.size.height) - self.bounds.size.height);
    _button.frame = CGRectMake(self.bounds.size.width - self.bounds.size.height, 0, self.bounds.size.height, self.bounds.size.height);
}

- (void)configureButtonForRegularState
{
    _button.cornerRadius = kShopBuyBorderedButtonDefaultCornerRadius;
    _button.titleEdgeInsets = UIEdgeInsetsZero;
    _button.frame = self.bounds;
}

- (void)setButtonState:(ShopBuyButtonState)buttonState animated:(BOOL)animated
{
    if (buttonState != self.buttonState)
    {
        _buttonState = buttonState;
        [self updateTintColors];
        [self updateTitle];
        
        if (self.buttonState == ShopBuyButtonStateProgress)
        {
            if (animated)
            {
                // don't animate the button highlight state. (use iOS6 compatible transactions, instead of performWithoutAnimation:)
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                _button.highlighted = NO;
                [CATransaction commit];
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^
                {
                    [self configureButtonForProgressState];
                }
                completion:^(BOOL finished)
                {
                    if (self.buttonState == ShopBuyButtonStateProgress)
                    {
                        [self updateTintColors];
                        [UIView animateWithDuration:0.5 animations:^
                        {
                            self->_button.alpha = 0;
                            self->_activityIndicatorView.alpha = 1;
                            [self->_activityIndicatorView startAnimating];
                        }];
                    }
                }];
            }
            else
            {
                [self configureButtonForProgressState];
                
                _button.alpha = 0;
                _activityIndicatorView.alpha = 1;
                [_activityIndicatorView startAnimating];
                [self setNeedsLayout];
            }
        }
        else if (self.buttonState == ShopBuyButtonStateNormal)
        {
            _button.alpha = 1;
            _activityIndicatorView.alpha = 0;
            
            if (animated)
            {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^
                {
                    [self configureButtonForRegularState];
                }
                completion:^(BOOL finished)
                {
                    [self updateTintColors];
                }];
            }
            else
            {
                [self configureButtonForRegularState];
                [self setNeedsLayout];
            }
        }
        else if (self.buttonState == ShopBuyButtonStateConfirmation)
        {
            [self configureButtonForRegularState];
            [self setNeedsLayout];
        }
    }
    else if (self.buttonState == ShopBuyButtonStateProgress && !animated)
    {
        // make sure we restart animation in re-used TableViewCells: they remove
        // all subview animations when they get reused.
        [_activityIndicatorView startAnimating];
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    [self updateTintColors];
}

- (void)setNormalTitle:(NSString *)normalTitle
{
    _normalTitle = [normalTitle copy];
    _attributedNormalTitle = nil;
    [self updateTitle];
}

- (NSString *)normalTitle
{
    if (_normalTitle) return _normalTitle;
    if (_attributedNormalTitle) return _attributedNormalTitle.string;

    return nil;
}

- (void)setAttributedNormalTitle:(NSAttributedString *)attributedNormalTitle
{
    _attributedNormalTitle = [attributedNormalTitle copy];
    _normalTitle = nil;
    [self updateTitle];
}

- (NSAttributedString *)attributedNormalTitle
{
    if (_attributedNormalTitle) return _attributedNormalTitle;
    if (_normalTitle) return [[NSAttributedString alloc] initWithString:_normalTitle];

    return nil;
}

- (void)setConfirmationColor:(UIColor *)confirmationColor
{
    _confirmationColor = confirmationColor;
    [self updateTintColors];
}

- (void)setConfirmationTitle:(NSString *)confirmationTitle
{
    _confirmationTitle = [confirmationTitle copy];
    _attributedConfirmationTitle = nil;
    [self updateTitle];
}

- (NSString *)confirmationTitle
{
    if (_confirmationTitle) return _confirmationTitle;
    if (_attributedConfirmationTitle) return _attributedConfirmationTitle.string;

    return nil;
}

- (void)setAttributedConfirmationTitle:(NSAttributedString *)attributedConfirmationTitle
{
    _attributedConfirmationTitle = [attributedConfirmationTitle copy];
    _confirmationTitle = nil;
    [self updateTitle];
}

- (NSAttributedString *)attributedConfirmationTitle
{
    if (_attributedConfirmationTitle) return _attributedConfirmationTitle.copy;
    if (_confirmationTitle) return [[NSAttributedString alloc] initWithString:_confirmationTitle];
    
    return nil;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [_button sizeThatFits:size];
}

- (CGSize)intrinsicContentSize
{
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (void)updateTitle
{
    if (self.buttonState == ShopBuyButtonStateConfirmation)
    {
        if (_attributedConfirmationTitle)
        {
            _button.attributedTitle = _attributedConfirmationTitle;
        }
        else
        {
            _button.title = _confirmationTitle;
        }
    }
    else
    {
        if (_attributedNormalTitle)
        {
            _button.attributedTitle = _attributedNormalTitle;
        }
        else
        {
            _button.title = _normalTitle;
        }
    }
    
    [self invalidateIntrinsicContentSize];
}

- (void)updateTintColors
{
    _button.tintColor = self.buttonState == ShopBuyButtonStateConfirmation ? self.confirmationColor : self.normalColor;
    _activityIndicatorView.tintColor = self.buttonState == ShopBuyButtonStateConfirmation ? self.confirmationColor : self.normalColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    _button.highlighted = highlighted && self.buttonState != ShopBuyButtonStateProgress;
}

- (UIFont *)titleLabelFont
{
    return _button.titleLabel.font;
}

- (void)setTitleLabelFont:(UIFont *)font
{
    _button.titleLabel.font = font;
    [self invalidateIntrinsicContentSize];
}

@end
