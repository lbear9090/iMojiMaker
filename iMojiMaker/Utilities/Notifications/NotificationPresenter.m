//
//  NotificationPresenter.m
//  iMojiMaker
//
//  Created by Lucky on 5/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Configurations.h"
#import "NotificationPresenter.h"

NSString *const kNotificationSuccessImageName = @"success";
NSString *const kNotificationErrorImageName = @"error";
NSString *const kNotificationInfoImageName = @"info";

@implementation NotificationPresenter

+ (void)showNotificationWithType:(kNotificationType)notificationType title:(NSString *)title message:(NSString *)message dismissDelay:(NSTimeInterval)dismissDelay completionBlock:(NotificationCompletionBlock)completionBlock
{
    CGRect notificationViewFrame = [self notificationViewFrameWithHeight:68.0 topInset:38.0 leftInset:18.0];
    NotificationView *notificationView = [self createNotificationWithFrame:notificationViewFrame type:notificationType title:title message:message dismissDelay:dismissDelay completionBlock:completionBlock];
#ifdef Application
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:notificationView];
#endif
    [notificationView showNotification];
}

+ (void)showNotificationInView:(UIView *)view type:(kNotificationType)notificationType title:(NSString *)title message:(NSString *)message dismissDelay:(NSTimeInterval)dismissDelay completionBlock:(NotificationCompletionBlock)completionBlock
{
    CGRect notificationViewFrame = [self notificationViewFrameWithHeight:68.0 topInset:0.0 leftInset:10.0];
    NotificationView *notificationView = [self createNotificationWithFrame:notificationViewFrame type:notificationType title:title message:message dismissDelay:dismissDelay completionBlock:completionBlock];
    [view addSubview:notificationView];
    [notificationView showNotification];
}

+ (NotificationView *)createNotificationWithFrame:(CGRect)frame type:(kNotificationType)notificationType title:(NSString *)title message:(NSString *)message dismissDelay:(NSTimeInterval)dismissDelay completionBlock:(NotificationCompletionBlock)completionBlock
{
    NotificationView *notificationView = [[NotificationView alloc] initWithFrame:frame];
    notificationView.backgroundColor = [self notificationColorWithType:notificationType];
    notificationView.image = [self notificationImageWithType:notificationType];
    notificationView.title = title;
    notificationView.message = message;
    notificationView.dismissDelay = dismissDelay;
    notificationView.completionBlock = completionBlock;
    
    return notificationView;
}

+ (CGRect)notificationViewFrameWithHeight:(CGFloat)height topInset:(CGFloat)topInset leftInset:(CGFloat)leftInset
{
    CGRect frame = [UIScreen mainScreen].bounds;
#ifdef Application
    frame = [[UIApplication sharedApplication] keyWindow].frame;
#endif
    return CGRectMake(leftInset, topInset, (frame.size.width - (leftInset * 2.0)), height);
}

+ (UIColor *)notificationColorWithType:(kNotificationType)notificationType
{
    switch (notificationType)
    {
        case kNotificationTypeSuccess:
        {
            return [UIColor colorWithHexString:kBlueColor];
        }
        case kNotificationTypeError:
        {
            return [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
        }
        case kNotificationTypeInfo:
        {
            return [UIColor colorWithHexString:kGrayColor];
        }
    }
    
    return nil;
}

+ (UIImage *)notificationImageWithType:(kNotificationType)notificationType
{
    switch (notificationType)
    {
        case kNotificationTypeSuccess:
        {
            return [UIImage imageNamed:kNotificationSuccessImageName];
        }
        case kNotificationTypeError:
        {
            return [UIImage imageNamed:kNotificationErrorImageName];
        }
        case kNotificationTypeInfo:
        {
            return [UIImage imageNamed:kNotificationInfoImageName];
        }
    }
    
    return nil;
}

@end
