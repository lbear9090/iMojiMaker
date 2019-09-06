//
//  ShareButton.m
//  iMojiMaker
//
//  Created by Lucky on 5/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ShareButton.h"
#import "Configurations.h"

@implementation ShareButton

- (void)configureShare
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2.0;
    
    [self setBackgroundColor:[UIColor colorWithHexString:kBlueColor]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont odinRoundedRegularWithSize:self.titleLabel.font.pointSize];
}

@end
