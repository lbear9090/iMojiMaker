//
//  MMToolbar1024ButtonContentMap.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbar1024ButtonContentMap.h"

@implementation MMToolbar1024ButtonContentMap

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.spaceButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarSpaceButtonTitle fontSize:27.0];
        self.returnButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarReturnButtonTitle fontSize:27.0];
        self.changeContentButtonContentSet = [MMToolbarButtonContentSet buttonContentSetWithButtonText:kMMToolbarChangeContentButtonTitle fontSize:27];
    }
    
    return self;
}

@end
