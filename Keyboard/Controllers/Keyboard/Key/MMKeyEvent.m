//
//  MMKeyEvent.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyEvent.h"

@implementation MMKeyEvent

+ (instancetype)keyEventWithTouch:(UITouch *)touch initialKey:(MMKeyView *)initialKey
{
    MMKeyEvent *event = [[MMKeyEvent alloc] init];
    event.touch = touch;
    event.initialKey = initialKey;
    event.currentKey = initialKey;
    
    return event;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.began = CFAbsoluteTimeGetCurrent();
    }
    
    return self;
}

@end
