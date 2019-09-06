//
//  ProductData.h
//  iMojiMaker
//
//  Created by Lucky on 5/2/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ProductData : NSObject

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) BOOL isAnimated;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *imagePath;

- (instancetype)initWithPath:(NSString *)path;

- (NSData *)loadImageData;

@end
