//
//  MMTouchGraph.m
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMTouchGraph.h"

@interface MMTouchGraph ()
{
    CGSize _imageSize;
    CGRect _imageRect;
    CGFloat _scaleFactor;
    CGFloat _pointWidthHeigt;
    CGFloat _pointWidthHeigtHalf;
}

@end

@implementation MMTouchGraph

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scaleFactor = [UIScreen mainScreen].scale;
    _pointWidthHeigt = 3.0 * _scaleFactor;
    _pointWidthHeigtHalf = _pointWidthHeigt / 2.0;
    _imageSize = CGSizeMake(self.frame.size.width * _scaleFactor, self.frame.size.height * _scaleFactor);
    _imageRect = CGRectMake(0.0, 0.0, _imageSize.width, _imageSize.height);
}

- (void)registerTouchAtPosition:(CGPoint)position
{
    UIGraphicsBeginImageContext(_imageSize);
    [self.image drawInRect:_imageRect];
    
    CGFloat originX = position.x * _scaleFactor - _pointWidthHeigtHalf;
    CGFloat originY = position.y * _scaleFactor - _pointWidthHeigtHalf;
    CGRect borderRect = CGRectMake(originX, originY, _pointWidthHeigt, _pointWidthHeigt);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 0.2);
    CGContextSetRGBFillColor(context, 1.0, 0, 0, 0.3);
    CGContextSetLineWidth(context, 5.0);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

@end
