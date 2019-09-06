//
//  MMSharedContainer.m
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Configurations.h"
#import "MMSharedContainer.h"

static NSString *const kPasteboardString = @"iMoji";

@implementation MMSharedContainer

+ (BOOL)isAllowedAccessToSharedContainer
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *pasteboardString = pasteboard.string;
    pasteboard.string = kPasteboardString;
    
    if (!pasteboard.hasStrings) return NO;
    
    if (pasteboardString)
    {
        pasteboard.string = pasteboardString;
    }
    
    return YES;
}

+ (NSArray *)arrayWithFileName:(NSString *)fileName
{
    NSURL *fileURL = [MMSharedContainer containerFileURLWithFileName:fileName];
    NSArray *array = [NSArray arrayWithContentsOfURL:fileURL];
    
    return array;
}

+ (NSDictionary *)dictionaryWithFileName:(NSString *)fileName
{
    NSURL *fileURL = [MMSharedContainer containerFileURLWithFileName:fileName];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:fileURL];
    
    return dictionary;
}

+ (void)writeArray:(NSArray *)array fileName:(NSString *)fileName
{
    NSURL *fileURL = [MMSharedContainer containerFileURLWithFileName:fileName];
    [array writeToURL:fileURL atomically:YES];
}

+ (void)writeDictionary:(NSDictionary *)dictionary fileName:(NSString *)fileName
{
    NSURL *fileURL = [MMSharedContainer containerFileURLWithFileName:fileName];
    [dictionary writeToURL:fileURL atomically:YES];
}

+ (void)removeFileWithName:(NSString *)fileName
{
    NSURL *fileURL = [MMSharedContainer containerFileURLWithFileName:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:fileURL error:nil];
}

+ (NSURL *)containerURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager containerURLForSecurityApplicationGroupIdentifier:kAppGroupId];
}

+ (NSURL *)containerFileURLWithFileName:(NSString *)fileName
{
    NSURL *containerURL = [MMSharedContainer containerURL];
    
    return [containerURL URLByAppendingPathComponent:fileName];
}

@end
