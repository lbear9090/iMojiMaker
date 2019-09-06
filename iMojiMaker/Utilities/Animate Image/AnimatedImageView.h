//
//  AnimatedImageView.h
//  iMojiMaker
//
//  Created by Lucky on 4/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnimatedImage;

@interface AnimatedImageView : UIImageView

@property (nonatomic, strong) AnimatedImage *animatedImage;
@property (nonatomic, copy) void(^loopCompletionBlock)(NSUInteger loopCountRemaining);

@property (nonatomic, strong, readonly) UIImage *currentFrame;
@property (nonatomic, assign, readonly) NSUInteger currentFrameIndex;

@property (nonatomic, copy) NSString *runLoopMode;

@end
