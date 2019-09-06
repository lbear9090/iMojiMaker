//
//  UserDefaults.h
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDefaults : NSObject

+ (NSDictionary *)dictionaryForKey:(NSString *)key;
+ (NSArray *)arrayForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;
+ (NSInteger)integerForKey:(NSString *)key;
+ (CGFloat)floatForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;
+ (void)setArray:(NSArray *)array forKey:(NSString *)key;
+ (void)setString:(NSString *)string forKey:(NSString *)key;
+ (void)setInteger:(NSInteger)integer forKey:(NSString *)key;
+ (void)setFloat:(CGFloat)floatValue forKey:(NSString *)key;
+ (void)setBool:(BOOL)boolValue forKey:(NSString *)key;

@end
