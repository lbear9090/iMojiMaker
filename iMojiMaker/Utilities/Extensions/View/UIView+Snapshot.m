//
//  UIView+Snapshot.m
//  iMojiMaker
//
//  Created by Lucky on 5/18/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIImage *)snapshot
{
    return [self snapshotWithScale:[UIScreen mainScreen].scale];
}

- (UIImage *)snapshotWithScale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
