//
//  MMToolbar480ButtonContentMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar480ButtonContentMap.h"

@implementation MMToolbar480ButtonContentMap

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.spaceButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarSpaceButtonTitle fontSize:14.0];
        self.returnButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarReturnButtonTitle fontSize:14.0];
    }
    
    return self;
}

@end
