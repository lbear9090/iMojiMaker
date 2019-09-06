//
//  AnimatedImage.h
//  iMojiMaker
//
//  Created by Lucky on 4/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimatedImageView.h"

extern const NSTimeInterval kAnimatedImageDelayTimeIntervalMinimum;

@interface AnimatedImage : NSObject

@property (nonatomic, strong, readonly) UIImage *posterImage;
@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, assign, readonly) NSUInteger loopCount;
@property (nonatomic, strong, readonly) NSDictionary *delayTimesForIndexes;
@property (nonatomic, assign, readonly) NSUInteger frameCount;
@property (nonatomic, assign, readonly) NSUInteger frameCacheSizeCurrent;
@property (nonatomic, assign) NSUInteger frameCacheSizeMax;
@property (nonatomic, strong, readonly) NSData *data;

- (UIImage *)imageAtIndex:(NSUInteger)index;
- (UIImage *)imageLazilyCachedAtIndex:(NSUInteger)index;
+ (CGSize)sizeForImage:(id)image;

- (instancetype)initWithAnimatedGIFData:(NSData *)data;
- (instancetype)initWithAnimatedGIFData:(NSData *)data optimalFrameCacheSize:(NSUInteger)optimalFrameCacheSize predrawingEnabled:(BOOL)isPredrawingEnabled;
+ (instancetype)animatedImageWithGIFData:(NSData *)data;

@end

@interface WeakProxy : NSProxy

+ (instancetype)weakProxyForObject:(id)targetObject;

@end
