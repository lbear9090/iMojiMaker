//
//  MMToolbar320LayoutMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar320LayoutMap.h"

static CGFloat const kMMToolbar320LayoutMapHeight = 39.0;

@implementation MMToolbar320LayoutMap

- (CGFloat)interitemSpace
{
    return 6.0;
}

- (CGFloat)edgeOffset
{
    return 3.0;
}

- (CGFloat)specialSpace
{
    return 7.0;
}

- (CGSize)changeContentButtonSize
{
    return CGSizeMake(36.0, kMMToolbar320LayoutMapHeight);
}

- (CGSize)backspaceButtonSize
{
    return CGSizeMake(36.0, kMMToolbar320LayoutMapHeight);
}

- (CGSize)nextKeyboardButtonSize
{
    return CGSizeMake(36.0, kMMToolbar320LayoutMapHeight);
}

- (CGSize)returnButtonSize
{
    return CGSizeMake(36.0, kMMToolbar320LayoutMapHeight);
}

- (CGSize)spaceButtonSize
{
    return CGSizeMake(0.0, kMMToolbar320LayoutMapHeight);
}

@end
