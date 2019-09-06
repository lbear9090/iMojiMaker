//
//  MMToolbar568LayoutMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar568LayoutMap.h"

static CGFloat const kMMToolbar568LayoutMapHeight = 33.0;

@implementation MMToolbar568LayoutMap

- (CGFloat)interitemSpace
{
    return 8.0;
}

- (CGFloat)edgeOffset
{
    return 3.0;
}

- (CGFloat)specialSpace
{
    return 8.0;
}

- (CGSize)changeContentButtonSize
{
    return CGSizeMake(50.0, kMMToolbar568LayoutMapHeight);
}

- (CGSize)backspaceButtonSize
{
    return CGSizeMake(50.0, kMMToolbar568LayoutMapHeight);
}

- (CGSize)nextKeyboardButtonSize
{
    return CGSizeMake(50.0, kMMToolbar568LayoutMapHeight);
}

- (CGSize)returnButtonSize
{
    return CGSizeMake(50.0, kMMToolbar568LayoutMapHeight);
}

- (CGSize)spaceButtonSize
{
    return CGSizeMake(0.0, kMMToolbar568LayoutMapHeight);
}

@end
