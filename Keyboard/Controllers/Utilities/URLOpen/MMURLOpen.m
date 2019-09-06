//
//  MMURLOpen.m
//  Keyboard
//
//  Created by Lucky on 7/3/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMURLOpen.h"

@implementation MMURLOpen

+ (void)openURLWithResponder:(UIResponder *)responder url:(NSURL *)url
{
    while (responder)
    {
        if ([responder respondsToSelector:@selector(openURL:)])
        {
            [responder performSelector:@selector(openURL:) withObject:url];
        }
        responder = [responder nextResponder];
    }
}

@end
