//
//  MMShareDelegate.h
//  iMojiMaker
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

@protocol MMShareDelegate <NSObject>

- (void)shouldShare:(id<MMShareDelegate>)sender;
- (void)shouldRate:(id<MMShareDelegate>)sender;

@end
