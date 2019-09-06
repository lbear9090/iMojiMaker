//
//  CreateContainerModelDetails.h
//  iMojiMaker
//
//  Created by Lucky on 5/17/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateContainerModelDetails : NSObject

@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, assign, readonly) CGFloat alpha;
@property (nonatomic, assign, readonly) NSInteger layerIndex;
@property (nonatomic, assign, readonly) CGAffineTransform transform;

- (instancetype)initWithFrame:(CGRect)frame alpha:(CGFloat)alpha layerIndex:(NSInteger)layerIndex transform:(CGAffineTransform)transform;

@end
