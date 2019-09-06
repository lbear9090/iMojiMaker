//
//  MessagesDisplayCollectionViewCell.h
//  Messages
//
//  Created by Lucky on 5/30/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Products.h"
#import <Messages/Messages.h>

@interface MessagesDisplayCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)configureWithProductData:(ProductData *)productData;

@end
