//
//  MMBackground.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMImageCache.h"
#import "MMBackground.h"
#import "MMKeyboardDesign.h"

static NSString *const kMMBackgroundFileName = @"Filename";

@implementation MMBackground

+ (MMBackground *)backgroundWithInformation:(NSDictionary *)infoDictionary
{
    if (!infoDictionary) return nil;
    
    MMBackground *background = [[MMBackground alloc] init];
    background.filename = infoDictionary[kMMBackgroundFileName];
    
    return background;
}

- (void)loadImageWithImageCache:(MMImageCache *)imageCache
{
    NSURL *imageURL = [MMKeyboardDesign getDesignFilePathWithFileName:self.filename];
    _image = [imageCache imageForURL:imageURL];
}

@end
