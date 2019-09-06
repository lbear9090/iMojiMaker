//
//  ShopBuyRoundedActivityIndicatorView.h
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopBuyRoundedActivityIndicatorView : UIView

@property (nonatomic, assign) CGFloat lineWidth;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
