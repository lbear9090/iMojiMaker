//
//  LoadingView.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "LoadingView.h"
#import "AppDelegate.h"

@implementation LoadingView

#pragma mark - Inherited

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self = [self loadViewNib];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

#pragma mark - Public

+ (void)show
{
    [[LoadingView sharedInstance] show];
}

+ (void)hide
{
    [[LoadingView sharedInstance] hide];
}

#pragma mark - Private

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    static LoadingView *instance = nil;
    dispatch_once(&predicate, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (instancetype)loadViewNib
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *loadedNibsArray = [bundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    return [loadedNibsArray firstObject];
}

- (NSLayoutConstraint *)constraintToItemView:(UIView *)itemView withLayoutAttribute:(NSLayoutAttribute)layoutAttribute
{
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:layoutAttribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:itemView
                                        attribute:layoutAttribute
                                       multiplier:1.0
                                         constant:0.0];
}

- (void)addToParentView:(UIView *)parentView
{
    [parentView addSubview:self];
    
    [parentView addConstraint:[self constraintToItemView:parentView withLayoutAttribute:NSLayoutAttributeTop]];
    [parentView addConstraint:[self constraintToItemView:parentView withLayoutAttribute:NSLayoutAttributeBottom]];
    [parentView addConstraint:[self constraintToItemView:parentView withLayoutAttribute:NSLayoutAttributeLeading]];
    [parentView addConstraint:[self constraintToItemView:parentView withLayoutAttribute:NSLayoutAttributeTrailing]];
}

- (void)show
{
    UIViewController *topViewController = [AppDelegate topViewController];
    [self addToParentView:topViewController.view];
}

- (void)hide
{
    [self removeFromSuperview];
}

@end
