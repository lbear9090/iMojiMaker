//
//  GestureHandlerView.m
//  iMojiMaker
//
//  Created by Lucky on 5/16/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "GestureHandlerView.h"

@interface GestureHandlerView () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) GestureHandlerModel *handlerModel;
@property (nonatomic, strong) UIPanGestureRecognizer *moveGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *resizeGestureRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGestureRecognizer;
@end

@implementation GestureHandlerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addGestureRecognizer:self.moveGestureRecognizer];
    [self addGestureRecognizer:self.resizeGestureRecognizer];
    [self addGestureRecognizer:self.rotationGestureRecognizer];
}

- (void)setHandlerModel:(GestureHandlerModel *)handlerModel;
{
    _handlerModel = handlerModel;
    
    BOOL isActive = (_handlerModel != nil);
    self.moveGestureRecognizer.enabled = isActive;
    self.resizeGestureRecognizer.enabled = isActive;
    self.rotationGestureRecognizer.enabled = isActive;
}

- (UIPanGestureRecognizer *)moveGestureRecognizer
{
    if (!_moveGestureRecognizer)
    {
        _moveGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMoveGestureRecognizer:)];
        _moveGestureRecognizer.delegate = self;
    }
    
    return _moveGestureRecognizer;
}

- (UIPinchGestureRecognizer *)resizeGestureRecognizer
{
    if (!_resizeGestureRecognizer)
    {
        _resizeGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleResizeGestureRecognizer:)];
        _resizeGestureRecognizer.delegate = self;
    }
    
    return _resizeGestureRecognizer;
}

- (UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    if (!_rotationGestureRecognizer)
    {
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureRecognizer:)];
        _rotationGestureRecognizer.delegate = self;
    }
    
    return _rotationGestureRecognizer;
}

- (void)handleMoveGestureRecognizer:(UIPanGestureRecognizer *)moveGestureRecognizer
{
    CGPoint translation = [moveGestureRecognizer translationInView:self.superview];
    CGFloat centerPointX = self.handlerModel.view.center.x + translation.x;
    CGFloat centerPointY = self.handlerModel.view.center.y + translation.y;

    self.handlerModel.view.center = CGPointMake(centerPointX, centerPointY);
    [moveGestureRecognizer setTranslation:CGPointZero inView:self.superview];
}

- (void)handleResizeGestureRecognizer:(UIPinchGestureRecognizer *)resizeGestureRecognizer
{
    self.handlerModel.view.transform = CGAffineTransformScale(self.handlerModel.view.transform, resizeGestureRecognizer.scale, resizeGestureRecognizer.scale);
    resizeGestureRecognizer.scale = 1.0;
}

- (void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    CGFloat rotation = self.handlerModel.isFlipped ? -rotationGestureRecognizer.rotation : rotationGestureRecognizer.rotation;
    self.handlerModel.view.transform = CGAffineTransformRotate(self.handlerModel.view.transform, rotation);
    rotationGestureRecognizer.rotation = 0.0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
