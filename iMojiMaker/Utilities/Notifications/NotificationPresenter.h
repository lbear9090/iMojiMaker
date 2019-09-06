//
//  NotificationPresenter.h
//  iMojiMaker
//
//  Created by Lucky on 5/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "NotificationView.h"

@interface NotificationPresenter : NSObject

+ (void)showNotificationWithType:(kNotificationType)notificationType title:(NSString *)title message:(NSString *)message dismissDelay:(NSTimeInterval)dismissDelay completionBlock:(NotificationCompletionBlock)completionBlock;
+ (void)showNotificationInView:(UIView *)view type:(kNotificationType)notificationType title:(NSString *)title message:(NSString *)message dismissDelay:(NSTimeInterval)dismissDelay completionBlock:(NotificationCompletionBlock)completionBlock;

@end
