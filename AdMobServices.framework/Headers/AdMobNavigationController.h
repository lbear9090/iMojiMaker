#import <UIKit/UIKit.h>

@protocol AdMobNavigationControllerProtocol <NSObject>

- (void)updateIfNeeded;

@end

@interface AdMobNavigationController : UINavigationController <AdMobNavigationControllerProtocol>

@end
