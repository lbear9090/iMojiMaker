//
//  MMDesignProperties.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMMargin;
@class MMGradient;
@class MMBackground;

@interface MMDesignProperties : NSObject
@property (nonatomic, strong) MMMargin *keyboardMargins;
@property (nonatomic, strong) MMGradient *backgroundGradient;
@property (nonatomic, strong) MMBackground *backgroundImage;
@property (nonatomic, strong) MMMargin *buttonBackgroundImageMargins;
@property (nonatomic, strong) NSString *alternateShareButtonImageName;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIFont *buttonLabelFont;
@property (nonatomic, strong) UIFont *buttonLabelMultiCharacterFont;
@property (nonatomic, strong) UIColor *buttonLabelTextColor;
@property (nonatomic, assign) UIEdgeInsets buttonNinePatchInsets;
@property (nonatomic, assign) UIEdgeInsets ButtonLabelMargins;
@property (nonatomic, assign) NSTextAlignment buttonLabelAlignment;

+ (MMDesignProperties *)designPropertiesFromFile:(NSURL *)url;

@end
