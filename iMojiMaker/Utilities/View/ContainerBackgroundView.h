//
//  ContainerBackgroundView.h
//  iMojiMaker
//
//  Created by Lucky on 5/13/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContainerBackgroundViewDelegate;

@interface ContainerBackgroundView : UIView

@property (nonatomic, weak) id<ContainerBackgroundViewDelegate> delegate;

@end


@protocol ContainerBackgroundViewDelegate <NSObject>
@required

- (CGFloat)containerBackgroundViewLineWidth;
- (UIColor *)containerBackgroundViewDrawColor;
- (UIColor *)containerBackgroundViewBackgroundColor;

@end
