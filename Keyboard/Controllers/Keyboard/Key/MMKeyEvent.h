//
//  MMKeyEvent.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMKeyView;

@interface MMKeyEvent : NSObject

@property (nonatomic, assign) CFTimeInterval began;
@property (nonatomic, strong) UITouch *touch;
@property (nonatomic, strong) MMKeyView *initialKey;
@property (nonatomic, strong) MMKeyView *currentKey;

+ (instancetype)keyEventWithTouch:(UITouch *)touch initialKey:(MMKeyView *)initialKey;

@end
