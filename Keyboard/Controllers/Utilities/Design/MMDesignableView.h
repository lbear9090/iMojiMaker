//
//  MMDesignableView.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMGradient;
@class MMBackground;
@class MMGradientView;
@class MMBackgroundImageView;

@interface MMDesignableView : UIView

@property (nonatomic, assign) BOOL useConstraints;
@property (nonatomic, strong) MMGradientView *backgroundGradientView;
@property (nonatomic, strong) MMBackgroundImageView *backgroundImageView;

- (void)setBackgroundGradient:(MMGradient *)gradient;
- (void)setBackgroundImage:(MMBackground *)backgroundImage;

@end
