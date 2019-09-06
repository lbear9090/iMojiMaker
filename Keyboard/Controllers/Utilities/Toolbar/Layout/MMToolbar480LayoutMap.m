//
//  MMToolbar480LayoutMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar480LayoutMap.h"

static CGFloat const kMMToolbar480LayoutMapHeight = 33.0;

@implementation MMToolbar480LayoutMap

- (CGFloat)interitemSpace
{
    return 4.0;
}

- (CGFloat)edgeOffset
{
    return 5.0;
}

- (CGFloat)specialSpace
{
    return 4.0;
}

- (CGSize)changeContentButtonSize
{
    return CGSizeMake(45.0, kMMToolbar480LayoutMapHeight);
}

- (CGSize)backspaceButtonSize
{
    return CGSizeMake(45.0, kMMToolbar480LayoutMapHeight);
}

- (CGSize)nextKeyboardButtonSize
{
    return CGSizeMake(45.0, kMMToolbar480LayoutMapHeight);
}

- (CGSize)returnButtonSize
{
    return CGSizeMake(45.0, kMMToolbar480LayoutMapHeight);
}

- (CGSize)spaceButtonSize
{
    return CGSizeMake(0.0, kMMToolbar480LayoutMapHeight);
}

@end
