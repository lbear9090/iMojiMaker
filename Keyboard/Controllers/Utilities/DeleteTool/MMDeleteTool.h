//
//  MMDeleteTool.h
//  Keyboard
//
//  Created by Lucky on 6/27/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMDeleteTool : NSObject

@property (nonatomic) NSInteger deleteCharactersCount;
@property (nonatomic) NSTimeInterval deleteFirstCharactersInterval;
@property (nonatomic) NSTimeInterval deleteCharactersInterval;
@property (nonatomic) NSTimeInterval deleteWordsInterval;

- (void)deleteBeginHoldDown:(UIInputViewController *)inputViewController;
- (void)deleteEndHoldDown:(UIInputViewController *)inputViewController;

@end
