//
//  MMBackground.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMImageCache;

@interface MMBackground : NSObject
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong, readonly) UIImage *image;

+ (MMBackground *)backgroundWithInformation:(NSDictionary *)infoDictionary;

- (void)loadImageWithImageCache:(MMImageCache *)imageCache;

@end
