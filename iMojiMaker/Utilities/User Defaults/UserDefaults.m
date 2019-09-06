//
//  UserDefaults.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "UserDefaults.h"

@interface UserDefaults ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation UserDefaults

#pragma mark - Public

+ (NSDictionary *)dictionaryForKey:(NSString *)key
{
    return [self objectForKey:key];
}

+ (NSArray *)arrayForKey:(NSString *)key
{
    return [self objectForKey:key];
}

+ (NSString *)stringForKey:(NSString *)key
{
    return [self objectForKey:key];
}

+ (NSInteger)integerForKey:(NSString *)key
{
    NSNumber *number = [self objectForKey:key];
    return number.integerValue;
}

+ (CGFloat)floatForKey:(NSString *)key
{
    NSNumber *number = [self objectForKey:key];
    return number.floatValue;
}

+ (BOOL)boolForKey:(NSString *)key
{
    NSNumber *number = [self objectForKey:key];
    return number.boolValue;
}

+ (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    [self setObject:dictionary forKey:key];
}

+ (void)setArray:(NSArray *)array forKey:(NSString *)key
{
    [self setObject:array forKey:key];
}

+ (void)setString:(NSString *)string forKey:(NSString *)key
{
    [self setObject:string forKey:key];
}

+ (void)setInteger:(NSInteger)integer forKey:(NSString *)key
{
    [self setObject:@(integer) forKey:key];
}

+ (void)setFloat:(CGFloat)floatValue forKey:(NSString *)key
{
    [self setObject:@(floatValue) forKey:key];
}

+ (void)setBool:(BOOL)boolValue forKey:(NSString *)key
{
    [self setObject:@(boolValue) forKey:key];
}

#pragma mark - Getters

- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults)
    {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}

#pragma mark - Private

+ (instancetype)sharedUserDefaults
{
    static dispatch_once_t predicate;
    static UserDefaults *instance = nil;
    dispatch_once(&predicate, ^{ instance = [[self alloc] init]; });
    return instance;
}

+ (id)objectForKey:(NSString *)key
{
    return [[UserDefaults sharedUserDefaults] objectForKey:key];
}

+ (void)setObject:(id)object forKey:(NSString *)key
{
    [[UserDefaults sharedUserDefaults] setObject:object forKey:key];
}

- (id)objectForKey:(NSString *)key
{
    return [self.userDefaults objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [self.userDefaults setObject:object forKey:key];
}

@end
