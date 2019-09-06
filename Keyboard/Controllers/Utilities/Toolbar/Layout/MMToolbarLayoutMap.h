//
//  MMToolbarLayoutMap.h
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMToolbarLayoutMap : NSObject

@property (nonatomic, assign) CGFloat edgeOffset;
@property (nonatomic, assign) CGFloat interitemSpace;
@property (nonatomic, assign) CGFloat specialSpace;

@property (nonatomic, assign) CGSize changeContentButtonSize;
@property (nonatomic, assign) CGSize backspaceButtonSize;
@property (nonatomic, assign) CGSize nextKeyboardButtonSize;
@property (nonatomic, assign) CGSize returnButtonSize;
@property (nonatomic, assign) CGSize spaceButtonSize;

@end
