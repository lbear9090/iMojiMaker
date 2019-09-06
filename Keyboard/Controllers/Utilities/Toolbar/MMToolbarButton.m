//
//  MMToolbarButton.m
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMToolbarButton.h"

@implementation MMToolbarButton

- (void)adaptConstraintsForSize:(CGSize)size
{
    self.widthConstraint.constant = size.width;
    self.heightConstraint.constant = size.height;
}

@end
