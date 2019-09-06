//
//  MMTouchBias.h
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMKeyView;

@interface MMTouchBias : NSObject

- (void)registerTouchAtLocation:(CGPoint)touchLocation forKey:(MMKeyView *)keyView relativeView:(UIView *)relativeView;
- (CGPoint)offsetForLocation:(CGPoint)location relativeView:(UIView *)relativeView;

- (void)save;

@end
