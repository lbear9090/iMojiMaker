//
//  MMKeyboardDesign.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMKeyView.h"
#import "MMDesignProperties.h"

extern NSString *const kMMKeyboardDesignDirectory;

@interface MMKeyboardDesign : NSObject
@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, strong, readonly) MMGradient *backgroundGradient;
@property (nonatomic, strong, readonly) MMBackground *backgroundImage;
@property (nonatomic, strong, readonly) UIImage *buttonImage;
@property (nonatomic, strong, readonly) UIImage *buttonImageHighlighted;
@property (nonatomic, strong, readonly) UIImage *specialButtonImage;
@property (nonatomic, strong, readonly) UIImage *specialButtonImageHighlighted;
@property (nonatomic, strong) MMDesignProperties *designProperties;

+ (MMKeyboardDesign *)sharedDesign;
+ (NSURL *)getDesignFilePathWithFileName:(NSString *)fileName;

- (void)adjustButton:(UIButton *)button isSpecial:(BOOL)isSpecial;
- (void)adjustButton:(UIButton *)button keyInfo:(MMKeyInfo *)keyInfo;
- (void)adjustKeyView:(MMKeyView *)keyView isSpecial:(BOOL)isSpecial;
- (void)adjustKeyView:(MMKeyView *)keyView withOrientation:(UIInterfaceOrientation)orientation;
- (UIEdgeInsets)keyboardMarginsForOrientation:(UIInterfaceOrientation)orientation;
- (UIImage *)loadImage:(NSString *)imageName;
- (NSString *)imagePath:(NSString *)imageName;

@end
