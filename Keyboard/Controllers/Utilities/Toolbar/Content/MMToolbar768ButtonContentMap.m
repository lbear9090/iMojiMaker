//
//  MMToolbar768ButtonContentMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar768ButtonContentMap.h"

@implementation MMToolbar768ButtonContentMap

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.spaceButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarSpaceButtonTitle fontSize:20.0];
        self.returnButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarReturnButtonTitle fontSize:20.0];
        self.changeContentButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarChangeContentButtonTitle fontSize:20];
    }
    
    return self;
}

@end
