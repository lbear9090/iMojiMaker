#import <UIKit/UIKit.h>

@interface AdMobService : NSObject

+ (void)setDebugEnabled:(BOOL)debugState;
+ (void)setTestDevices:(NSArray *)testDevices;

+ (void)setBannerIdentifier:(NSString *)identifier;
+ (void)setInterstitialIdentifier:(NSString *)identifier;
+ (void)setRewardedVideoIdentifier:(NSString *)identifier;

+ (void)setInterstitialInterval:(NSInteger)interval;
+ (void)setInitialViewController:(UIViewController *)controller;

+ (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)disableAds;

+ (void)presentInterstitial;
+ (void)presentRewardedVideo;

+ (void)presentInterstitialWithCompletionBlock:(void (^)(void))completionBlock;
+ (void)presentRewardedVideoWithCompletionBlock:(void (^)(void))completionBlock;

@end
