#import <UIKit/UIKit.h>

@protocol AdMobViewControllerProtocol <NSObject>

@property (nonatomic, assign) CGSize bannerSize;

- (BOOL)shouldDisplayBannerAds;
- (void)didShowBannerAd;
- (void)didHideBannerAd;
- (void)scheduleBannerAdShowing;

- (void)configureAppearance;

@end

@interface AdMobViewController : UIViewController <AdMobViewControllerProtocol>

@end

