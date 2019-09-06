//
//  GestureHandlerModel.m
//  iMojiMaker
//
//  Created by Lucky on 5/22/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "GestureHandlerModel.h"

@implementation GestureHandlerModel

- (instancetype)initWithView:(UIView *)view isFlipped:(BOOL)isFlipped
{
    self = [super init];
    if (self)
    {
        _view = view;
        _isFlipped = isFlipped;
    }
    
    return self;
}

@end
