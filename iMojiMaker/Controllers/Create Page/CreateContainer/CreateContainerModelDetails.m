//
//  CreateContainerModelDetails.m
//  iMojiMaker
//
//  Created by Lucky on 5/17/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "CreateContainerModelDetails.h"

@implementation CreateContainerModelDetails

- (instancetype)initWithFrame:(CGRect)frame alpha:(CGFloat)alpha layerIndex:(NSInteger)layerIndex transform:(CGAffineTransform)transform
{
    self = [super init];
    if (self)
    {
        _frame = frame;
        _alpha = alpha;
        _layerIndex = layerIndex;
        _transform = transform;
    }
    
    return self;
}

@end
