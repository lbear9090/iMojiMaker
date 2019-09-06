//
//  MMImageCache.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMImageCache.h"

@interface MMImageCache ()
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@property (nonatomic, strong) NSArray *suffixes;
@property (nonatomic, strong) NSArray *scales;
@property (nonatomic, assign) NSInteger suffixMaxIndex;
@end

@implementation MMImageCache

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.imageDict = [[NSMutableDictionary alloc] init];
        self.suffixes = @[@"", @"@2x", @"@3x", @"~ipad", @"@2x~ipad", @"@3x~ipad"];
        self.scales = @[@(1),@(2),@(3),@(1),@(2),@(3)];
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            self.suffixMaxIndex += 3;
        }
        
        if ([UIScreen mainScreen].scale == 2)
        {
            self.suffixMaxIndex += 1;
        }
        
        if ([UIScreen mainScreen].scale >= 3)
        {
            self.suffixMaxIndex += 2;
        }
    }
    
    return self;
}

- (UIImage *)imageForURL:(NSURL *)url
{
    UIImage *image = self.imageDict[url];
    
    if (!image)
    {
        NSString *fileName = [url lastPathComponent];
        NSString *extension = [fileName pathExtension];
        NSString *fileNameWithoutExtension = [fileName stringByDeletingPathExtension];
        NSURL *folderUrl = [url URLByDeletingLastPathComponent];
        
        for (NSInteger index = self.suffixMaxIndex; index >= 0 && !image; index--)
        {
            NSString *suffix = self.suffixes[index];
            NSString *suffixedFileName = [NSString stringWithFormat:@"%@%@.%@",fileNameWithoutExtension, suffix, extension];
            NSURL *suffixedURL = [folderUrl URLByAppendingPathComponent:suffixedFileName];
            NSData *data = [NSData dataWithContentsOfURL:suffixedURL];
            
            if (data)
            {
                CGFloat scale = [self.scales[index] floatValue];
                image = [UIImage imageWithData:data scale:scale];
                
                self.imageDict[url] = image;
                break;
            }
        }
    }
    
    return image;
}

@end
