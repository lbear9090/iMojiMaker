//
//  MMDeleteTool.m
//  Keyboard
//
//  Created by Lucky on 6/27/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMDeleteTool.h"

@interface MMDeleteTool ()
{
    NSInteger charactersDeleted;
}

@end

@implementation MMDeleteTool

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        charactersDeleted = 0;
        self.deleteCharactersCount = 15;
        self.deleteWordsInterval = 0.2f;
        self.deleteCharactersInterval = 0.1f;
        self.deleteFirstCharactersInterval = 0.8f;
    }
    
    return self;
}

- (void)deleteBeginHoldDown:(UIInputViewController *)inputViewController
{
    [self manageDelete:inputViewController];
}

- (void)deleteEndHoldDown:(UIInputViewController *)inputViewController
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    charactersDeleted = 0;
}

- (void)manageDelete:(UIInputViewController *)inputViewController
{
    NSTimeInterval interval = 0;
    if (charactersDeleted > self.deleteCharactersCount)
    {
        interval = self.deleteWordsInterval;
        [self deleteWord:inputViewController];
        [self deleteWord:inputViewController];
    }
    else
    {
        if (charactersDeleted != 0) {
            interval = self.deleteCharactersInterval;
        }
        else
        {
            interval = self.deleteFirstCharactersInterval;
        }
        [self deleteCharacter:inputViewController];
    }
    
    [self performSelector:@selector(manageDelete:) withObject:inputViewController afterDelay:interval];
    
    charactersDeleted++;
}

- (void)deleteCharacter:(UIInputViewController *)inputViewController
{
    [inputViewController.textDocumentProxy deleteBackward];
}

- (void)deleteWord:(UIInputViewController *)inputViewController
{
    NSString *text = [inputViewController.textDocumentProxy documentContextBeforeInput];
    
    if (!text)
    {
        for (NSInteger i = 0; i < 5; i++)
        {
            [inputViewController.textDocumentProxy deleteBackward];
        }
        
        return;
    }
    
    NSInteger deleteCount = 0;
    
    while (text.length > 0 && [[text substringFromIndex:text.length - 1] isEqualToString:@" "])
    {
        deleteCount++;
        NSRange range = {text.length - 1, 1};
        text = [text stringByReplacingCharactersInRange:range withString:@""];
    }
    
    NSRange lastSpaceRange = [text rangeOfString:@" " options:NSBackwardsSearch];
    
    if (lastSpaceRange.location != NSNotFound)
    {
        deleteCount += (text.length - 1) - lastSpaceRange.location;
    }
    else
    {
        deleteCount = text.length;
    }
    
    for (NSInteger i = 0; i < deleteCount; i++)
    {
        [inputViewController.textDocumentProxy deleteBackward];
    }
}

@end
