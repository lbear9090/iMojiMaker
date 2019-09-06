//
//  ShopButton.m
//  iMojiMaker
//
//  Created by Lucky on 5/12/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ShopButton.h"
#import "Configurations.h"

@implementation ShopButton

- (void)configureRestoreButton
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2.0;
    
    [self setBackgroundColor:[UIColor colorWithHexString:kBlueColor]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont odinRoundedRegularWithSize:self.titleLabel.font.pointSize];
}

@end
