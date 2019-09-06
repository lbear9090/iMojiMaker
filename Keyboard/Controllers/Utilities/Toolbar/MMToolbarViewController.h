//
//  MMToolbarViewController.h
//  Keyboard
//
//  Created by Lucky on 6/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMToolbarLayoutMap;
@class MMToolbarButtonContentMap;

typedef NS_ENUM(NSInteger, kMMToolbarButtonType)
{
    kMMToolbarButtonTypeSpace,
    kMMToolbarButtonTypeReturn,
    kMMToolbarButtonTypeBackspace,
    kMMToolbarButtonTypeNextKeyboard,
    kMMToolbarButtonTypeChangeContent
};

@protocol MMToolbarViewControllerDelegate;

@interface MMToolbarViewController : UIViewController

@property (nonatomic, weak) id<MMToolbarViewControllerDelegate> delegate;

+ (NSString *)segueIdentifier;

- (void)updateButtonContentWithContentMap:(MMToolbarButtonContentMap *)contentMap;
- (void)adaptConstraintsForSpacingMap:(MMToolbarLayoutMap *)spacingMap;
- (BOOL)shouldUpdateButtonContentMapForViewSize:(CGSize)viewSize;
- (void)configureAppearance;

@end

@protocol MMToolbarViewControllerDelegate <NSObject>

- (void)toolbarViewController:(MMToolbarViewController *)controller touchDownButtonWithType:(kMMToolbarButtonType)type;
- (void)toolbarViewController:(MMToolbarViewController *)controller touchUpButtonWithType:(kMMToolbarButtonType)type;
- (void)toolbarViewController:(MMToolbarViewController *)controller willLayoutViewWithSize:(CGSize)viewSize;

@end
