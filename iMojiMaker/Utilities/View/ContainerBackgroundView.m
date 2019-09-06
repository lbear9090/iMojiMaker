//
//  ContainerBackgroundView.m
//  iMojiMaker
//
//  Created by Lucky on 5/13/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Configurations.h"
#import <QuartzCore/QuartzCore.h>
#import "ContainerBackgroundView.h"

@implementation ContainerBackgroundView

- (void)setDelegate:(id<ContainerBackgroundViewDelegate>)delegate
{
    _delegate = delegate;
    
    if (!_delegate) return;
    
    self.backgroundColor = [_delegate containerBackgroundViewBackgroundColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self drawLinesWithRect:rect];
    [self drawCirclesWithRect:rect];
}

- (CGFloat)lineWidth
{
    return [self.delegate containerBackgroundViewLineWidth];
}

- (UIColor *)drawColor
{
    return [self.delegate containerBackgroundViewDrawColor];
}

- (void)drawLinesWithRect:(CGRect)rect
{
    [self drawDiagonalLinesWithRect:rect];
    [self drawVerticalLinesWithRect:rect];
    [self drawHorizontalLinesWithRect:rect];
}

- (void)drawCirclesWithRect:(CGRect)rect
{
    CGFloat dashPattern[] = {5.0f, 3.0f};
    CGFloat lineWidth = [self lineWidth];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat value = width / 16.0;
    CGFloat halfWidth = width / 2.0;
    CGFloat halfHeight = height / 2.0;
    CGFloat quarterWidth = halfWidth / 2.0;
    CGFloat quarterHeight = halfHeight / 2.0;
    CGFloat diagonalWidth = sqrt(2.0) * quarterWidth;
    CGFloat diagonalHeight = sqrt(2.0) * quarterHeight;
    CGFloat insetX = (width - (diagonalWidth * 2.0)) / 2.0;
    CGFloat insetY = (height - (diagonalHeight * 2.0)) / 2.0;
    
    UIBezierPath *bigPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, value, value)];
    UIBezierPath *middlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, insetX, insetY)];
    UIBezierPath *smallPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, insetX - (value - insetX), insetY - (value - insetY))];
    
    [[self drawColor] setStroke];
    
    [bigPath setLineWidth:lineWidth];
    [middlePath setLineWidth:lineWidth];
    [smallPath setLineWidth:lineWidth];
    
    [bigPath setLineDash:dashPattern count:2 phase:1];
    [smallPath setLineDash:dashPattern count:2 phase:1];
    
    [bigPath setLineCapStyle:kCGLineCapRound];
    [smallPath setLineCapStyle:kCGLineCapRound];
    
    [bigPath stroke];
    [middlePath stroke];
    [smallPath stroke];
}

- (void)drawDiagonalLinesWithRect:(CGRect)rect
{
    CGFloat lineWidth = [self lineWidth];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(width, height)];
    [path moveToPoint:CGPointMake(width, 0.0)];
    [path addLineToPoint:CGPointMake(0.0, height)];
    
    [[self drawColor] setStroke];
    [path setLineWidth:lineWidth];
    [path stroke];
}

- (void)drawVerticalLinesWithRect:(CGRect)rect
{
    CGFloat lineWidth = [self lineWidth];
    CGFloat halfLineWidth = lineWidth / 2.0;
    CGFloat width = rect.size.width - halfLineWidth;
    CGFloat height = rect.size.height;
    CGFloat halfWidth = width / 2.0;
    CGFloat quarterWidth = halfWidth / 2.0;
    CGFloat value = width / 16.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(halfLineWidth, 0.0)];
    [path addLineToPoint:CGPointMake(halfLineWidth, height)];
    [path moveToPoint:CGPointMake(value, height - value)];
    [path addLineToPoint:CGPointMake(value, value)];
    [path moveToPoint:CGPointMake(quarterWidth, 0.0)];
    [path addLineToPoint:CGPointMake(quarterWidth, height)];
    [path moveToPoint:CGPointMake(halfWidth, height)];
    [path addLineToPoint:CGPointMake(halfWidth, 0.0)];
    [path moveToPoint:CGPointMake(halfWidth + quarterWidth, 0.0)];
    [path addLineToPoint:CGPointMake(halfWidth + quarterWidth, height)];
    [path moveToPoint:CGPointMake(width - value, height - value)];
    [path addLineToPoint:CGPointMake(width - value, value)];
    [path moveToPoint:CGPointMake(width, 0.0)];
    [path addLineToPoint:CGPointMake(width, height)];
    
    [[self drawColor] setStroke];
    [path setLineWidth:lineWidth];
    [path stroke];
}

- (void)drawHorizontalLinesWithRect:(CGRect)rect
{
    CGFloat lineWidth = [self lineWidth];
    CGFloat halfLineWidth = lineWidth / 2.0;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height - halfLineWidth;
    CGFloat halfHeight = height / 2.0;
    CGFloat quarterHeight = halfHeight / 2.0;
    CGFloat value = width / 16.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, halfLineWidth)];
    [path addLineToPoint:CGPointMake(width, halfLineWidth)];
    [path moveToPoint:CGPointMake(width - value, value)];
    [path addLineToPoint:CGPointMake(value, value)];
    [path moveToPoint:CGPointMake(0.0, quarterHeight)];
    [path addLineToPoint:CGPointMake(width, quarterHeight)];
    [path moveToPoint:CGPointMake(width, halfHeight)];
    [path addLineToPoint:CGPointMake(0.0, halfHeight)];
    [path moveToPoint:CGPointMake(0.0, halfHeight + quarterHeight)];
    [path addLineToPoint:CGPointMake(width, halfHeight + quarterHeight)];
    [path moveToPoint:CGPointMake(width - value, height - value)];
    [path addLineToPoint:CGPointMake(value, height - value)];
    [path moveToPoint:CGPointMake(0.0, height)];
    [path addLineToPoint:CGPointMake(width, height)];
    
    [[self drawColor] setStroke];
    [path setLineWidth:lineWidth];
    [path stroke];
}

@end
