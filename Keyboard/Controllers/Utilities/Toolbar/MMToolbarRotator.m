//
//  MMToolbarRotator.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Utilities.h"
#import "MMToolbarRotator.h"
#import "MMToolbarLayoutMap.h"
#import "MMToolbar320LayoutMap.h"
#import "MMToolbar480LayoutMap.h"
#import "MMToolbar568LayoutMap.h"
#import "MMToolbar768LayoutMap.h"
#import "MMToolbar1024LayoutMap.h"
#import "MMToolbarButtonContentMap.h"
#import "MMToolbar320ButtonContentMap.h"
#import "MMToolbar480ButtonContentMap.h"
#import "MMToolbar768ButtonContentMap.h"
#import "MMToolbar1024ButtonContentMap.h"

@implementation MMToolbarRotator

+ (MMToolbarLayoutMap *)spacingMapForToolbarWith:(CGFloat)width
{
    if (isIPad())
    {
        if (width == 768.0)
        {
            return [[MMToolbar768LayoutMap alloc] init];
        }
        else
        {
            return [[MMToolbar1024LayoutMap alloc] init];
        }
    }
    else
    {
        if (width == 320.0) return [[MMToolbar320LayoutMap alloc] init];
        if (width == 375.0) return [[MMToolbar320LayoutMap alloc] init];
        if (width == 480.0) return [[MMToolbar480LayoutMap alloc] init];
    }
    
    return [[MMToolbar568LayoutMap alloc] init];
}


+ (MMToolbarButtonContentMap *)buttonContentMapForToolbarWidth:(CGFloat)width
{
    if (isIPad())
    {
        if (width == 768.0)
        {
            return [[MMToolbar768ButtonContentMap alloc] init];
        }
        else
        {
            return [[MMToolbar1024ButtonContentMap alloc] init];
        }
    }
    else
    {
        if (width == 320.0) return [[MMToolbar320ButtonContentMap alloc] init];
        if (width == 375.0) return [[MMToolbar320ButtonContentMap alloc] init];
        if (width == 480.0) return [[MMToolbar480ButtonContentMap alloc] init];
    }
    
    return [[MMToolbar480ButtonContentMap alloc] init];
}


+ (CGFloat)toolbarHeightForToolbarWith:(CGFloat)width
{
    if (isIPad())
    {
        if (width == 768.0)
        {
            return 68.0;
        }
        else
        {
            return 85.0;
        }
    }
    else
    {
        if (width == 320.0) return 45.0;
        if (width == 375.0) return 45.0;
        if (width == 480.0) return 39.0;
    }
    
    return 39.0;
}

@end
