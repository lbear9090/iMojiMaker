//
//  MMMargin.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kMMMarginTopEdgeKey;
extern NSString *const kMMMarginLeftEdgeKey;
extern NSString *const kMMMarginBottomEdgeKey;
extern NSString *const kMMMarginRightEdgeKey;

@interface MMMargin : NSObject
@property (nonatomic, assign, readonly) UIEdgeInsets portrait;
@property (nonatomic, assign, readonly) UIEdgeInsets landscape;
@property (nonatomic, assign, readonly) UIEdgeInsets current;

+ (MMMargin *)marginFromDictionary:(NSDictionary *)marginInformation;

@end
