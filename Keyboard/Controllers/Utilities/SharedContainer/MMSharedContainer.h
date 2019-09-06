//
//  MMSharedContainer.h
//  Keyboard
//
//  Created by Lucky on 6/4/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSharedContainer : NSObject

+ (BOOL)isAllowedAccessToSharedContainer;

+ (NSArray *)arrayWithFileName:(NSString *)fileName;
+ (NSDictionary *)dictionaryWithFileName:(NSString *)fileName;

+ (void)writeArray:(NSArray *)array fileName:(NSString *)fileName;
+ (void)writeDictionary:(NSDictionary *)dictionary fileName:(NSString *)fileName;

+ (void)removeFileWithName:(NSString *)fileName;

@end
