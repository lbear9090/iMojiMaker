//
//  MMKeyboardDesign.m
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMMargin.h"
#import "Utilities.h"
#import "MMGradient.h"
#import "MMBackground.h"
#import "MMImageCache.h"
#import "MMKeyboardDesign.h"

NSString *const kMMKeyboardDesignDirectory = @"KeyboardDesign";

static NSString *const kMMButtonBackgroundFile = @"ButtonBackgroundMain.png";
static NSString *const kMMButtonBackgroundHighlightedFile = @"ButtonBackgroundMainHighlighted.png";
static NSString *const kMMButtonBackgroundSpecialFile = @"ButtonBackgroundSpecial.png";
static NSString *const kMMButtonBackgroundSpecialHighlightedFile = @"ButtonBackgroundSpecialHighlighted.png";
static NSString *const kMMDesignPropertiesPlistFile = @"Properties.plist";

@interface MMKeyboardDesign ()
@property (nonatomic, strong) MMImageCache *imageCache;
@end

@implementation MMKeyboardDesign

+ (MMKeyboardDesign *)sharedDesign
{
    NSURL *propertiesURL = [MMKeyboardDesign getDesignFilePathWithFileName:kMMDesignPropertiesPlistFile];
    
    return [[MMKeyboardDesign alloc] initFromPropertiesFilePath:propertiesURL];
}

+ (NSURL *)getDesignFilePathWithFileName:(NSString *)fileName
{
    if (!fileName) return nil;
    
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSURL *designDirectoryURL = [bundleURL URLByAppendingPathComponent:kMMKeyboardDesignDirectory];
    
    return [designDirectoryURL URLByAppendingPathComponent:fileName];
}

- (instancetype)init
{
    self = [self initFromDesignFolder];
    if (self)
    {
        self.imageCache = [[MMImageCache alloc] init];
    }
    
    return self;
}

- (instancetype)initFromPropertiesFilePath:(NSURL *)propertiesFile
{
    self = [super init];
    if (self)
    {
        self.imageCache = [[MMImageCache alloc] init];
        self.designProperties = [MMDesignProperties designPropertiesFromFile:propertiesFile];
        
        if (self.designProperties.backgroundImage)
        {
            [self.designProperties.backgroundImage loadImageWithImageCache:self.imageCache];
        }
        
        NSURL *url = [MMKeyboardDesign getDesignFilePathWithFileName:kMMButtonBackgroundFile];
        UIImage *image = [self.imageCache imageForURL:url];
        
        _buttonImage = [image resizableImageWithCapInsets:self.designProperties.buttonNinePatchInsets resizingMode:UIImageResizingModeStretch];
        
        url = [MMKeyboardDesign getDesignFilePathWithFileName:kMMButtonBackgroundHighlightedFile];
        image = [self.imageCache imageForURL:url];
        
        if (image)
        {
            _buttonImageHighlighted = [image resizableImageWithCapInsets:self.designProperties.buttonNinePatchInsets resizingMode:UIImageResizingModeStretch];
        }
        else
        {
            _buttonImageHighlighted = _buttonImage;
        }
        
        url = [MMKeyboardDesign getDesignFilePathWithFileName:kMMButtonBackgroundSpecialFile];
        image = [self.imageCache imageForURL:url];
        _specialButtonImage = [image resizableImageWithCapInsets:self.designProperties.buttonNinePatchInsets resizingMode:UIImageResizingModeStretch];
        
        url= [MMKeyboardDesign getDesignFilePathWithFileName:kMMButtonBackgroundSpecialHighlightedFile];
        image = [self.imageCache imageForURL:url];
        
        if (image)
        {
            _specialButtonImageHighlighted = [image resizableImageWithCapInsets:self.designProperties.buttonNinePatchInsets resizingMode:UIImageResizingModeStretch];
        }
        else
        {
            _specialButtonImageHighlighted = _specialButtonImage;
        }
        
        _backgroundColor = self.designProperties.backgroundColor;
    }
    
    return self;
}

- (instancetype)initFromDesignFolder
{
    NSURL *propertiesURL = [MMKeyboardDesign getDesignFilePathWithFileName:kMMDesignPropertiesPlistFile];
    
    self = [self initFromPropertiesFilePath:propertiesURL];
    if (self)
    {
        
    }
    
    return self;
}

- (MMGradient *)backgroundGradient
{
    return self.designProperties.backgroundGradient;
}

- (MMBackground *)backgroundImage
{
    return self.designProperties.backgroundImage;
}

- (void)adjustKeyView:(MMKeyView *)keyView isSpecial:(BOOL)isSpecial
{
    keyView.design = self;
    keyView.keyInfo.isSpecialKey = isSpecial;
    keyView.labelMargins = self.designProperties.ButtonLabelMargins;
    keyView.characterLabel.backgroundColor = [UIColor clearColor];
    keyView.characterLabel.textAlignment = self.designProperties.buttonLabelAlignment;
    keyView.characterLabel.textColor = self.designProperties.buttonLabelTextColor;
    
    if (keyView.keyInfo.displayCharacter.length > 1)
    {
        keyView.characterLabel.font = self.designProperties.buttonLabelMultiCharacterFont;
    }
    else
    {
        keyView.characterLabel.font = self.designProperties.buttonLabelFont;
    }
    
    if (keyView.keyInfo.displayImage)
    {
        UIImage *normal = [self loadImage:keyView.keyInfo.displayImage];
        UIImage *highlighted = [self loadImage:keyView.keyInfo.displayImageHighlighted];
        UIImage *thirdState = [self loadImage:keyView.keyInfo.displayImageThirdState];
        [keyView setButtonImage:normal highlighted:highlighted thirdState:thirdState];
    }
    
    if (isSpecial)
    {
        [keyView setBackgroundImages:self.specialButtonImage
                         highlighted:self.specialButtonImageHighlighted
                             margins:self.designProperties.buttonBackgroundImageMargins.current];
    }
    else
    {
        [keyView setBackgroundImages:self.buttonImage
                         highlighted:self.buttonImageHighlighted
                             margins:self.designProperties.buttonBackgroundImageMargins.current];
    }
}

- (void)adjustButton:(UIButton *)button isSpecial:(BOOL)isSpecial
{
    UIImage *background = isSpecial ? self.specialButtonImage : self.buttonImage;
    UIImage *backgroundHighlighted = isSpecial ? self.specialButtonImageHighlighted : self.buttonImageHighlighted;
    
    [button setTintColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setBackgroundImage:background forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundHighlighted forState:UIControlStateHighlighted];
}

- (void)adjustButton:(UIButton *)button keyInfo:(MMKeyInfo *)keyInfo
{
    [self adjustButton:button isSpecial:keyInfo.isSpecialKey];
    
    [button setTitle:@"" forState:UIControlStateNormal];
    
    UIImage *normal = [self loadImage:keyInfo.displayImage];
    UIImage *highlighted = [self loadImage:keyInfo.displayImageHighlighted] ?: normal;
    
    [button setImage:normal forState:UIControlStateNormal];
    [button setImage:highlighted forState:UIControlStateHighlighted];
}

- (NSString *)imagePath:(NSString *)imageName
{
    return [MMKeyboardDesign getDesignFilePathWithFileName:imageName].absoluteString;
}

- (UIImage *)loadImage:(NSString *)imageName
{
    NSURL *imageURL = [MMKeyboardDesign getDesignFilePathWithFileName:imageName];
    UIImage *image = [self.imageCache imageForURL:imageURL];
    
    return image;
}

- (void)adjustKeyView:(MMKeyView *)keyView withOrientation:(UIInterfaceOrientation)orientation
{
    if (isInterfacePortrait(orientation))
    {
        keyView.backgroundImageMargins = self.designProperties.buttonBackgroundImageMargins.portrait;
    }
    else
    {
        keyView.backgroundImageMargins = self.designProperties.buttonBackgroundImageMargins.landscape;
    }
}

- (UIEdgeInsets)keyboardMarginsForOrientation:(UIInterfaceOrientation)orientation
{
    return isInterfacePortrait(orientation) ? self.designProperties.keyboardMargins.portrait : self.designProperties.keyboardMargins.landscape;
}

@end
