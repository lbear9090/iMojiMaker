//
//  MMUIHelper.h
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMUIHelper : NSObject

+ (NSArray *)fillConstraintsInView:(UIView *)view forView:(UIView *)fillView;
+ (NSArray *)snapAllSidesOfView:(UIView *)childView toView:(UIView *)containerView;
+ (NSLayoutConstraint *)snapLeftConstraintInView:(UIView *)view forView:(UIView *)snapView;
+ (NSLayoutConstraint *)snapTopConstraintInView:(UIView *)view forView:(UIView *)snapView;
+ (NSLayoutConstraint *)snapRightConstraintInView:(UIView *)view forView:(UIView *)snapView;
+ (NSLayoutConstraint *)snapBottomConstraintInView:(UIView *)view forView:(UIView *)snapView;

+ (NSLayoutConstraint *)widthConstraintForView:(UIView *)view width:(CGFloat)width;
+ (NSLayoutConstraint *)heightConstraintForView:(UIView *)view height:(CGFloat)height;
+ (NSLayoutConstraint *)widthConstraintForItem:(UIView *)item inView:(UIView *)view;
+ (NSLayoutConstraint *)heightConstraintForItem:(UIView *)item inView:(UIView *)view;

+ (NSLayoutConstraint *)findConstraintOnItem:(UIView *)item attribute:(NSLayoutAttribute)attribute;

@end
