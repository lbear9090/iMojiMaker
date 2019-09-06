//
//  SettingsViewController.m
//  iMojiMaker
//
//  Created by Lucky on 4/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "IAPManager.h"
#import "LoadingView.h"
#import <MessageUI/MessageUI.h>
#import "SettingsViewController.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *contentArray;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    [self createContentArray];
    [self.tableView reloadData];
    
    [self registerForNotifications];
}

- (void)dealloc
{
    [self unregisterForNotifications];
}

- (void)configureAppearance
{
    [super configureAppearance];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    
    UIColor *color = [UIColor colorWithHexString:kBlueColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)createContentArray
{
    NSDictionary *rateItem = @{@"title" : @"Rate This App",
                               @"selector" : @"rateItemAction"};
    
    NSDictionary *contactUs = @{@"title" : @"Contact Us",
                                @"selector" : @"contactUsItemAction"};
    
    NSDictionary *moreAppsItem = @{@"title" : @"More Apps",
                                   @"selector" : @"moreAppsItemAction"};
    
    NSDictionary *shareItem = @{@"title" : [NSString stringWithFormat:@"Share %@",applicationName()],
                                @"selector" : @"shareItemAction"};
    
    NSDictionary *restoreItem = @{@"title" : @"Restore Purchases",
                                  @"selector" : @"restoreItemAction"};
    
    self.contentArray = @[@[rateItem, contactUs, moreAppsItem, shareItem], @[restoreItem]];
}

- (void)rateItemAction
{
    if (@available(iOS 10.3, *))
    {
        [SKStoreReviewController requestReview];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kApplicationUrl] options:@{} completionHandler:nil];
    }
}

- (void)contactUsItemAction
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.navigationBar.tintColor = [UIColor colorWithHexString:kBlueColor];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setToRecipients:@[kSupportEmail]];
        [mailComposeViewController setSubject:applicationName()];
        
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
    else
    {
        NSString *alertTitle = @"Warning";
        NSString *alertMessage = @"Your email is not setted up. Please set up your email and try again. Thanks.";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)moreAppsItemAction
{
    [self presentMoreAppsController];
}

- (void)shareItemAction
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[kApplicationUrl] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)restoreItemAction
{
    [[IAPManager sharedManager] restorePurchases];
}

- (UIBarButtonItem *)leftBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
}

- (void)leftItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = self.contentArray[indexPath.section][indexPath.row];
    cell.textLabel.text = item[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = self.contentArray[indexPath.section][indexPath.row];
    SEL selector = NSSelectorFromString(item[@"selector"]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
#pragma clang diagnostic pop
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlePurchaseCanceledNotification:(NSNotification *)notification
{
}

- (void)handlePurchaseCompleteNotification:(NSNotification *)notification
{
}

- (void)handlePurchasesRestoredNotification:(NSNotification *)notification
{
}

- (void)registerForNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handlePurchaseCanceledNotification:) name:IAPManagerPurchaseCanceledNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(handlePurchaseCompleteNotification:) name:IAPManagerPurchaseCompleteNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(handlePurchasesRestoredNotification:) name:IAPManagerPurchasesRestoredNotification object:nil];
}

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
