//
//  MMRootViewController.m
//  Keyboard
//
//  Created by Lucky on 6/14/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMRootViewController.h"
#import "MMLaunchingInfoPlistParser.h"

@implementation MMRootViewController

+ (instancetype)instantiateFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[MMLaunchingInfoPlistParser storyboardName] bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:[self storyboardIdentifier]];
}

+ (NSString *)storyboardIdentifier
{
    return nil;
}

+ (BOOL)canInstantiateFromStoryboard
{
    return YES;
}

- (void)switchToNumbers
{
    
}

@end
