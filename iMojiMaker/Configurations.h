//
//  Configurations.h
//  iMojiMaker
//
//  Created by Lucky on 4/23/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#ifndef Configurations_h
#define Configurations_h

#import "Utilities.h"
#import "UIColor+Hex.h"
#import "UIFont+OdinRounded.h"

#define kAdMobInterstitialInterval 1
#define kAdMobInterstitialIdentifier @"ca-app-pub-9006052141226885/9670592187"

#define kBlueColor                  @"#2C7CF6"
#define kWhiteColor                 @"#FFFFFF"
#define kGrayColor                  @"#A0A0A0"
#define kLightGrayColor             @"#AAAAAA"

#define kBackgroundColor            @"#F6F6F8"
#define kProductNormalColor         @"#EDEEF2"
#define kProductSelectedColor       @"#D4D9DF"

#define kAppGroupId                 @"group.com.infinitesocial.emojiplus"

#define kApplicationId              1473899541

#define kItunesArtistId             "^**^"

#define kApplicationUrl             @"https://itunes.apple.com/app/id1198220798"

#define kApplicationDeepLink        @"imojimaker://"

#define kSupportEmail               @"main@infinite-social.com"

#define kProductsFileName           @"Products.plist"

#define kProductsFolderName         @"Products"
#define kProductsFreeFolderName     @"Free"
#define kProductsBuyFolderName      @"Buy"

#define kSmallProductSizePrefix     @"Small-"
#define kMediumProductSizePrefix    @"Medium-"
#define kBigProductSizePrefix       @"Big-"

#define kNotificationTitleSaved     @"Success"
#define kNotificationMessageSaved   @"iMoji saved with success. Now you can send it from iMessage or Keyboard."

#define kNotificationTitleCopied    @"Success"
#define kNotificationMessageCopied  @"iMoji copied to clipboard. Paste into text field."

#define kNotificationTitleRequest   @"Warning"
#define kNotificationMessageRequest @"Please allow full keyboard access in Settings to use saved iMoji."

#endif /* Configurations_h */
