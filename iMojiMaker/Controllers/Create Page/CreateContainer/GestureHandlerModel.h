//
//  GestureHandlerModel.h
//  iMojiMaker
//
//  Created by Lucky on 5/22/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureHandlerModel : NSObject

@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) BOOL isFlipped;

- (instancetype)initWithView:(UIView *)view isFlipped:(BOOL)isFlipped;

@end
