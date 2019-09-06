//
//  MMToolbarRotator.h
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMToolbarLayoutMap;
@class MMToolbarButtonContentMap;

@interface MMToolbarRotator : NSObject

+ (MMToolbarLayoutMap *)spacingMapForToolbarWith:(CGFloat)width;
+ (MMToolbarButtonContentMap *)buttonContentMapForToolbarWidth:(CGFloat)width;
+ (CGFloat)toolbarHeightForToolbarWith:(CGFloat)width;

@end
