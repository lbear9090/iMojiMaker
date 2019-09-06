//
//  MMBackgroundImageView.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMUIHelper.h"
#import "MMBackground.h"
#import "MMBackgroundImageView.h"

@interface MMBackgroundImageView()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation MMBackgroundImageView

+ (MMBackgroundImageView *)backgroundImageViewWithBackground:(MMBackground *)background
{
    return [[MMBackgroundImageView alloc] initWithBackground:background];
}

- (MMBackgroundImageView *)initWithBackground:(MMBackground *)background
{
    self = [super init];
    if (self)
    {
        UIImage *image = background.image;
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        NSArray *constraints = [MMUIHelper snapAllSidesOfView:self.imageView toView:self];
        [self addConstraints:constraints];
    }
    
    return self;
}

@end
