//
//  MessagesViewController.m
//  Messages
//
//  Created by Lucky on 4/20/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "Configurations.h"
#import "MessagesViewController.h"
#import "UIViewController+Extension.h"
#import "MessagesDisplayViewController.h"

@interface MessagesViewController () <MessagesDisplayViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UILabel *logoLabel;
@property (nonatomic, strong) MessagesDisplayViewController *displayViewController;
@end

@implementation MessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.logoLabel.text = applicationName();
    self.logoLabel.font = [UIFont odinRoundedRegularWithSize:40];
    self.logoLabel.textColor = [UIColor colorWithHexString:kBlueColor];
    self.view.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
}

- (MessagesDisplayViewController *)displayViewController
{
    if (!_displayViewController)
    {
        _displayViewController = [MessagesDisplayViewController loadFromStoryboard];
        _displayViewController.delegate = self;
    }
    
    return _displayViewController;
}

- (void)willBecomeActiveWithConversation:(MSConversation *)conversation
{
    [self presentViewController:self.displayViewController animated:NO completion:nil];
}

- (void)shareApplicationFromDisplayViewController:(MessagesDisplayViewController *)displayViewController
{
    [self.activeConversation insertText:kApplicationUrl completionHandler:nil];
}

- (void)openApplicationFromDisplayViewController:(MessagesDisplayViewController *)displayViewController
{
    NSURL *containerApplicationURL = [NSURL URLWithString:kApplicationDeepLink];
    [self.extensionContext openURL:containerApplicationURL completionHandler:nil];
}

@end
