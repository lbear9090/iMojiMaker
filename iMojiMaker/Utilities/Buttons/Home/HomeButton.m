//
//  HomeButton.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "HomeButton.h"
#import "Configurations.h"

@implementation HomeButton

- (void)configureHomeButton
{
    CGFloat size = self.titleLabel.font.pointSize;
    UIColor *color = [UIColor colorWithHexString:kBlueColor];
    
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont odinRoundedRegularWithSize:size];
}

- (void)configureHomeNewButton
{
    UIColor *color = [UIColor whiteColor];
    CGFloat size = self.titleLabel.font.pointSize;
    
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont odinRoundedRegularWithSize:size];
}

- (void)configureHomeFAQButton
{
    CGFloat size = self.titleLabel.font.pointSize;
    UIColor *color = [UIColor colorWithHexString:kGrayColor];
    
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont odinRoundedBoldWithSize:size];
}

- (void)configureHomeEnableKeyboardButton
{
    CGFloat size = self.titleLabel.font.pointSize;
    UIColor *color = [UIColor colorWithHexString:kGrayColor];
    
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont odinRoundedBoldWithSize:size];
}

@end
