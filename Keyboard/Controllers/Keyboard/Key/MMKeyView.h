//
//  MMKeyView.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyInfo.h"
#import "MMEmptyKeyView.h"

extern NSString *const kSpaceKeyName;

@class MMKeyboardDesign;

@protocol MMKeyViewDelegate;

@interface MMKeyView : MMEmptyKeyView <UIInputViewAudioFeedback, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet id<MMKeyViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *characterLabel;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *foregroundImageView;
@property (nonatomic, strong) NSString *keyIdentifier;
@property (nonatomic, strong) MMKeyboardDesign *design;
@property (nonatomic, strong) MMKeyInfo *keyInfo;
@property (nonatomic, assign) UIEdgeInsets backgroundImageMargins;
@property (nonatomic, assign) CGFloat additionalLeftPadding;
@property (nonatomic, assign) CGFloat additionalRightPadding;
@property (nonatomic, assign) UIEdgeInsets labelMargins;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign, readonly) BOOL displaysPreview;

- (void)setBackgroundImages:(UIImage *)image highlighted:(UIImage *)highlighted margins:(UIEdgeInsets)margins;
- (void)setButtonImage:(UIImage *)image highlighted:(UIImage *)highlighted thirdState:(UIImage *)thirdState;
- (void)addDoubleTapTarget:(id)target action:(SEL)action;
- (void)deactivateConflictingConstraint:(BOOL)deactivate;
- (void)highlight:(BOOL)highlighted;
- (void)highlightAnimation;
- (void)addLeftSwipe;
- (void)addRightSwipe;
- (void)setThirdState;

@end

@protocol MMKeyViewDelegate <NSObject>

- (void)keyViewDidSwipe:(MMKeyView *)keyView direction:(UISwipeGestureRecognizerDirection)direction;
- (void)keyViewDidTouchUpInside:(MMKeyView *)keyView;
- (void)waitingForSwipe:(BOOL)wating;
- (float)keyViewScaleOnTouchFactor;

@end
