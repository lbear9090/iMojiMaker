//
//  MMToolbar320ButtonContentMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar320ButtonContentMap.h"

@implementation MMToolbar320ButtonContentMap

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.spaceButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithDictionaryKey:kMMToolbarSpaceButtonKey isSpecial:NO];
        self.returnButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithDictionaryKey:kMMToolbarReturnButtonKey isSpecial:YES];
    }
    
    return self;
}

@end
