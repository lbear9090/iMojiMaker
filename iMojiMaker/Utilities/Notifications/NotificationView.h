//
//  NotificationView.h
//  iMojiMaker
//
//  Created by Lucky on 5/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NotificationCompletionBlock)(void);

typedef NS_ENUM(NSInteger, kNotificationType)
{
    kNotificationTypeSuccess    = 0,
    kNotificationTypeError      = 1,
    kNotificationTypeInfo       = 2
};

@interface NotificationView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSTimeInterval dismissDelay;
@property (nonatomic, copy) NotificationCompletionBlock completionBlock;

- (void)showNotification;

@end
