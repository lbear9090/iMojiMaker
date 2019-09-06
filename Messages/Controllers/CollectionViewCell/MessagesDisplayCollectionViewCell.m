//
//  MessagesDisplayCollectionViewCell.m
//  Messages
//
//  Created by Lucky on 5/30/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Utilities.h"
#import "MessagesDisplayCollectionViewCell.h"

@interface MessagesDisplayCollectionViewCell ()
@property (nonatomic, weak) MSStickerView *stickerView;
@end

@implementation MessagesDisplayCollectionViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureCell];
    }
    
    return self;
}

- (void)configureCell
{
    MSStickerView *stickerView = [[MSStickerView alloc] initWithFrame:self.bounds];
    stickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    stickerView.contentMode = UIViewContentModeScaleAspectFit;
    stickerView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:stickerView];
    self.stickerView = stickerView;
}

- (void)configureWithProductData:(ProductData *)productData
{
    [self.stickerView setSticker:[self stickerWithProductData:productData]];
    [self.stickerView startAnimating];
}

- (MSSticker *)stickerWithProductData:(ProductData *)productData
{
    NSURL *imageFileURL = [NSURL fileURLWithPath:productData.imagePath];
    return [[MSSticker alloc] initWithContentsOfFileURL:imageFileURL localizedDescription:applicationName() error:nil];
}

@end
