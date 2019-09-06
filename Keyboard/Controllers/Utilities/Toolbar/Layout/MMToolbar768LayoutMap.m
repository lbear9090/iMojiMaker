//
//  MMToolbar768LayoutMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar768LayoutMap.h"

static CGFloat const kMMToolbar768LayoutMapHeight = 56.0;

@implementation MMToolbar768LayoutMap

- (CGFloat)interitemSpace
{
    return 12.0;
}

- (CGFloat)edgeOffset
{
    return 5.0;
}

- (CGFloat)specialSpace
{
    return 14.0;
}

- (CGSize)changeContentButtonSize
{
    return CGSizeMake(56.0, kMMToolbar768LayoutMapHeight);
}

- (CGSize)backspaceButtonSize
{
    return [self changeContentButtonSize];
}

- (CGSize)nextKeyboardButtonSize
{
    return CGSizeMake(85.0, kMMToolbar768LayoutMapHeight);
}

- (CGSize)returnButtonSize
{
    return CGSizeMake(85.0, kMMToolbar768LayoutMapHeight);
}

- (CGSize)spaceButtonSize
{
    return CGSizeMake(0.0, kMMToolbar768LayoutMapHeight);
}

@end
