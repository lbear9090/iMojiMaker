//
//  MMKeyboardState.h
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMKeyboardState : NSObject

@property (nonatomic, strong) NSString *designName;
@property (nonatomic, assign) CGFloat designScrollPosition;
@property (nonatomic, assign) CGFloat phrasesScrollPosition;
@property (nonatomic, assign) CGFloat fontsScrollPosition;
@property (nonatomic, assign) BOOL didShowLimitedAccessNotification;
@property (nonatomic, assign) BOOL didShowOpenAppNotification;
@property (nonatomic, assign) NSInteger selectedFontIndex;

+ (instancetype)instance;

- (void)loadState;
- (void)saveState;

@end
