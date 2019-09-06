//
//  MMBaseKeyboardViewControllerSubclass.h
//  iMojiMaker
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMBaseKeyboardViewController.h"

@interface MMBaseKeyboardViewController ()
@property (nonatomic, strong) IBOutletCollection(MMKeyView) NSMutableArray *characterKeys;
@property (nonatomic, strong) IBOutletCollection(MMKeyView) NSMutableArray *specialKeys;
@property (nonatomic, strong) UIView *widenedTouchAreaView;
@property (nonatomic, strong) NSDictionary *layout;
@property (nonatomic, strong) NSArray *allKeys;
@property (nonatomic, weak) MMKeyView *activeKey;
@property (nonatomic, assign) CGRect widenedTouchArea;

- (void)loadInfoForKeys:(NSArray *)keysArray;
- (void)keyDidTouchAndHold:(MMKeyView *)keyView;
- (MMKeyView *)keyViewForTouchLocation:(CGPoint)touchLocation;

@end
