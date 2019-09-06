//
//  NSURL+Extension.h
//  iMojiMaker
//
//  Created by Lucky on 5/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ContentLoader.h"
#import "Configurations.h"

@interface NSURL (Directory)

- (BOOL)isDirectory;

@end

@interface NSURL (ProductSize)

- (BOOL)containsProductSize:(kProductsSize)productSize;

@end
