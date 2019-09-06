//
//  MMToolbar1024LayoutMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar1024LayoutMap.h"

static CGFloat const kMMToolbar1024LayoutMapHeight = 73.0;

@implementation MMToolbar1024LayoutMap

- (CGFloat)interitemSpace
{
    return 15.0;
}

- (CGFloat)edgeOffset
{
    return 10.0;
}

- (CGFloat)specialSpace
{
    return 21.0;
}

- (CGSize)changeContentButtonSize
{
    return CGSizeMake(74.0, kMMToolbar1024LayoutMapHeight);
}

- (CGSize)backspaceButtonSize
{
    return [self changeContentButtonSize];
}

- (CGSize)nextKeyboardButtonSize
{
    return CGSizeMake(111.0, kMMToolbar1024LayoutMapHeight);
}

- (CGSize)returnButtonSize
{
    return CGSizeMake(111.0, kMMToolbar1024LayoutMapHeight);
}

- (CGSize)spaceButtonSize
{
    return CGSizeMake(0.0, kMMToolbar1024LayoutMapHeight);
}

@end
