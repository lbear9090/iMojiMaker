//
//  MessagesDisplayViewController.h
//  Messages
//
//  Created by Lucky on 5/27/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "ViewController.h"

@protocol MessagesDisplayViewControllerDelegate;

@interface MessagesDisplayViewController : ViewController

@property (nonatomic, weak) id<MessagesDisplayViewControllerDelegate> delegate;

@end

@protocol MessagesDisplayViewControllerDelegate <NSObject>

- (void)shareApplicationFromDisplayViewController:(MessagesDisplayViewController *)displayViewController;
- (void)openApplicationFromDisplayViewController:(MessagesDisplayViewController *)displayViewController;

@end
