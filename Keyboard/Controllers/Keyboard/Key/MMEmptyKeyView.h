//
//  MMEmptyKeyView.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMEmptyKeyView : UIView

@property (nonatomic, strong) NSNumber *multiplierOverride;
@property (nonatomic, assign) CGFloat sizeMultiplier;
@property (nonatomic, assign) CGFloat unitWidth;

- (instancetype)initWithFrame:(CGRect)frame keyIdentifier:(NSString *)keyIdentifier sizeMultiplier:(CGFloat)multiplier;

- (void)adjustFrame:(CGRect)newFrame;

@end
