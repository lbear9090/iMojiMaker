//
//  MMUIHelper.m
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMUIHelper.h"

@implementation MMUIHelper

+ (NSArray *)fillConstraintsInView:(UIView *)view forView:(UIView *)fillView
{
    return @[[self snapLeftConstraintInView:view forView:fillView],
             [self snapTopConstraintInView:view forView:fillView],
             [self snapRightConstraintInView:view forView:fillView],
             [self snapBottomConstraintInView:view forView:fillView]];
}

+ (NSArray *)snapAllSidesOfView:(UIView *)childView toView:(UIView *)containerView
{
    return @[[self snapLeftConstraintInView:childView forView:containerView],
             [self snapTopConstraintInView:childView forView:containerView],
             [self snapRightConstraintInView:containerView forView:childView],
             [self snapBottomConstraintInView:containerView forView:childView]];
}

+ (NSLayoutConstraint *)snapLeftConstraintInView:(UIView *)view forView:(UIView *)snapView
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:snapView
                                        attribute:NSLayoutAttributeLeading
                                       multiplier:1.0f
                                         constant:0.0f];
}

+ (NSLayoutConstraint *)snapTopConstraintInView:(UIView *)view forView:(UIView *)snapView
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:snapView
                                        attribute:NSLayoutAttributeTop
                                       multiplier:1.0f
                                         constant:0.0f];
}

+ (NSLayoutConstraint *)snapRightConstraintInView:(UIView *)view forView:(UIView *)snapView
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeTrailing
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:snapView
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1.0f
                                         constant:0.0f];
}

+ (NSLayoutConstraint *)snapBottomConstraintInView:(UIView *)view forView:(UIView *)snapView
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:snapView
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0f
                                         constant:0.0f];
}

+ (NSLayoutConstraint *)findConstraintOnItem:(UIView *)item attribute:(NSLayoutAttribute)attribute
{
    for (NSLayoutConstraint *constraint in item.superview.constraints)
    {
        if (constraint.firstItem == item && constraint.firstAttribute == attribute) return constraint;
        if (constraint.secondItem == item && constraint.secondAttribute == attribute) return constraint;
    }
    
    return nil;
}

+ (NSLayoutConstraint *)widthConstraintForView:(UIView *)view width:(CGFloat)width
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:1.0f
                                         constant:width];
}

+ (NSLayoutConstraint *)heightConstraintForView:(UIView *)view height:(CGFloat)height
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:1.0f
                                         constant:height];
}

+ (NSLayoutConstraint *)widthConstraintForItem:(UIView *)item inView:(UIView *)view
{
    return [NSLayoutConstraint constraintWithItem:item
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:1.0f
                                         constant:0.0f];
}

+ (NSLayoutConstraint *)heightConstraintForItem:(UIView *)item inView:(UIView *)view
{
    return [NSLayoutConstraint constraintWithItem:item
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:1.0f
                                         constant:0.0f];
}

@end
