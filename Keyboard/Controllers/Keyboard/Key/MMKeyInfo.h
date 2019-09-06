//
//  MMKeyInfo.h
//  Keyboard
//
//  Created by Lucky on 6/5/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMKeyInfo : NSObject

@property (nonatomic, strong) NSString *displayCharacter;
@property (nonatomic, strong) NSString *character;
@property (nonatomic, strong) NSString *capitalizedCharacter;
@property (nonatomic, strong) NSString *displayImage;
@property (nonatomic, strong) NSString *displayImageHighlighted;
@property (nonatomic, strong) NSString *displayImageThirdState;
@property (nonatomic, strong) NSString *awesomeFontCharacter;
@property (nonatomic, strong) NSString *numberCharacter;
@property (nonatomic, strong) NSString *additionalCharacter;
@property (nonatomic, strong) NSString *specialCharacter;
@property (nonatomic, assign) BOOL isSpecialKey;
@property (nonatomic, assign) BOOL dontEnlargeOnHighlight;

+ (instancetype)keyInfoWithDictionary:(NSDictionary *)dictionary;

@end
