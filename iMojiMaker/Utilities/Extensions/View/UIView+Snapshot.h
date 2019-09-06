//
//  UIView+Snapshot.h
//  iMojiMaker
//
//  Created by Lucky on 5/18/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Snapshot)

- (UIImage *)snapshot;
- (UIImage *)snapshotWithScale:(CGFloat)scale;

@end
