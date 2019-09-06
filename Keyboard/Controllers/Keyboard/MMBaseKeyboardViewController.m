//
//  MMBaseKeyboardViewController.m
//  Keyboard
//
//  Created by Lucky on 6/7/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "MMUIHelper.h"
#import "MMTouchGraph.h"
#import "MMAudioManager.h"
#import "MMKeyboardSettings.h"
#import "MMContainerViewController.h"
#import "MMBaseKeyboardViewController.h"

static const CFTimeInterval kMMKeyboardViewCharacterDeleteInterval = 0.1f;
static const CFTimeInterval kMMKeyboardViewWordDeleteInterval = 0.2f;
static const NSInteger kMMKeyboardViewCharacterDeleteCountBeforeStartingWordDelete = 15;

static const CFTimeInterval kMMKeyboardViewKeyTouchDownDurationThreshold = 0.45f;
static const CFTimeInterval kMMKeyboardViewKeyTouchDownDurationThresholdAfterDrag = 2.0f;

static const BOOL kMMKeyboardViewDebugTouchPoint = NO;
static const float kMMKeyboardViewTouchAreaResizeFactorOnTouch = 0.25f;

@interface MMBaseKeyboardViewController ()
@property (nonatomic, strong) IBOutletCollection(MMKeyView) NSMutableArray *characterKeys;
@property (nonatomic, strong) IBOutletCollection(MMKeyView) NSMutableArray *specialKeys;
@property (nonatomic, strong) NSDictionary *layoutDictionary;
@property (nonatomic, strong) UIView *widenedTouchAreaView;
@property (nonatomic, strong) MMTouchGraph *touchesImage;
@property (nonatomic, strong) MMKeyView *activeKey;
@property (nonatomic, strong) NSTimer *touchTimer;
@property (nonatomic, strong) NSArray *allKeys;
@property (nonatomic, assign) NSInteger characterDeleteCount;
@property (nonatomic, assign) CGRect keyboardViewFrame;
@property (nonatomic, assign) CGRect widenedTouchArea;
@end

@implementation MMBaseKeyboardViewController

- (instancetype)initWithFrame:(CGRect)frame layoutFilePath:(NSString *)layoutFilePath
{
    self = [super init];
    if (self)
    {
        self.instantiatedFromNib = NO;
        self.keyboardViewFrame = frame;
        self.layoutDictionary = [NSDictionary dictionaryWithContentsOfFile:layoutFilePath];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil layoutFilePath:(NSString *)layoutFilePath
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        self.instantiatedFromNib = YES;
        self.layoutDictionary = [NSDictionary dictionaryWithContentsOfFile:layoutFilePath];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    if (self.instantiatedFromNib) return;
    
    MMKeyboardView *view = [[MMKeyboardView alloc] initWithFrame:self.keyboardViewFrame delegate:self];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.characterKeys = view.characterKeys;
    self.specialKeys = view.specialKeys;
    self.view = view;
    
    MMKeyboardSettings *keyboardSettings = [MMKeyboardSettings instance];
    [keyboardSettings loadSettings];
    
    if (kMMKeyboardViewDebugTouchPoint)
    {
        self.touchesImage = [[MMTouchGraph alloc] initWithFrame:self.view.frame];
        self.touchesImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.touchesImage];
        [self.view addConstraints:[MMUIHelper snapAllSidesOfView:self.touchesImage toView:self.view]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadInfoForKeys:self.specialKeys];
    [self loadInfoForKeys:self.characterKeys];
    
    self.allKeys = [self.characterKeys arrayByAddingObjectsFromArray:self.specialKeys];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self textHasChanged];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.touchBias save];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        UIInterfaceOrientation interfaceOrientation = [MMContainerViewController currentOrientation];
        [self updateKeyboardWithOrientation:interfaceOrientation];
    }];
}

- (void)setView:(MMKeyboardView *)view
{
    super.view = view;
}

- (MMKeyboardView *)view
{
    return (MMKeyboardView *)super.view;
}

- (void)setActiveKey:(MMKeyView *)activeKey
{
    if (!activeKey)
    {
        [self.touchTimer invalidate];
        self.touchTimer = nil;
        _activeKey = nil;
        
        return;
    }
    
    if (self.activeKey != activeKey)
    {
        [self.touchTimer invalidate];
        
        CFTimeInterval duration = self.activeKey ? kMMKeyboardViewKeyTouchDownDurationThresholdAfterDrag : kMMKeyboardViewKeyTouchDownDurationThreshold;
        
        _activeKey = activeKey;
        
        if (_activeKey == [self.view deleteKey])
        {
            self.characterDeleteCount = kMMKeyboardViewCharacterDeleteCountBeforeStartingWordDelete;
            self.touchTimer = [self timerWithTimeInterval:duration selector:@selector(continuousDeleteAction) repeats:NO];
        }
        else
        {
            self.touchTimer = [self timerWithTimeInterval:duration selector:@selector(keyHoldAction) repeats:NO];
        }
    }
}

- (void)setSpecialKeys:(NSMutableArray *)specialKeys
{
    _specialKeys = [specialKeys mutableCopy];
}

- (void)setCharacterKeys:(NSMutableArray *)characterKeys
{
    _characterKeys = [characterKeys mutableCopy];
}

- (MMTouchBias *)touchBias
{
    if (!_touchBias)
    {
        _touchBias = [[MMTouchBias alloc] init];
    }
    
    return _touchBias;
}

- (UIKeyboardType)keyboardType
{
    return [self.delegate keyboardType];
}

- (UIReturnKeyType)returnKeyType
{
    return [self.delegate returnKeyType];
}

- (void)shouldShare:(id<MMShareDelegate>)sender
{
    
}

- (void)shouldRate:(id<MMShareDelegate>)sender
{
    
}

- (void)keyViewDidSwipe:(MMKeyView *)keyView direction:(UISwipeGestureRecognizerDirection)direction
{
    
}

- (void)keyViewDidTouchUpInside:(MMKeyView *)keyView
{
    
}

- (void)waitingForSwipe:(BOOL)wating
{
    
}

- (float)keyViewScaleOnTouchFactor
{
    return kMMKeyboardViewTouchAreaResizeFactorOnTouch;
}

- (void)loadInfoForKeys:(NSArray *)keysArray
{
    for (MMKeyView *key in keysArray)
    {
        NSDictionary *keyInfoDictionary = [self.layoutDictionary objectForKey:key.keyIdentifier];
        MMKeyInfo *keyInfo = [MMKeyInfo keyInfoWithDictionary:keyInfoDictionary];
        key.keyInfo = keyInfo;
    }
}

- (void)keyDidTouchAndHold:(MMKeyView *)keyView
{
    
}

- (MMKeyView *)keyViewForTouchLocation:(CGPoint)touchLocation
{
    CGRect spaceRect = [self.view.spaceKey convertRect:self.view.spaceKey.bounds toView:self.view];
    
    if (CGRectContainsPoint(spaceRect, touchLocation)) return self.view.spaceKey;
    
    for (MMKeyView *key in self.allKeys)
    {
        CGPoint checkTouchLocation = touchLocation;
        CGRect keyFrame = [key convertRect:key.bounds toView:self.view];
        CGPoint offset = [self.touchBias offsetForLocation:touchLocation relativeView:self.view];
        checkTouchLocation.x -= key.unitWidth * offset.x;
        checkTouchLocation.y -= keyFrame.size.height * offset.y;
        
        if (CGRectContainsPoint(keyFrame, checkTouchLocation)) return key;
    }
    
    return nil;
}

- (void)textHasChanged
{
    
}

- (void)adjustReturnKey
{
    
}

- (void)setEnabled:(BOOL)enabled
{
    if (!enabled)
    {
        [self.touchTimer invalidate];
        self.touchTimer = nil;
    }

    self.view.userInteractionEnabled = enabled;
}

- (void)setKeyboardDesign:(MMKeyboardDesign *)keyboardDesign
{
    
}

- (void)setKeyboardKeyState:(kMMKeyboardKeyState)keyboardKeyState
{
    
}

- (void)updateKeyboardWithOrientation:(UIInterfaceOrientation)orientation
{
    MMKeyboardDesign *keyboardDesign = [self.dataSource requestCurrentKeyboardDesign:self];
    [self.view adjustToNewInterfaceOrientation:orientation keyboardDesign:keyboardDesign];
    
    for (MMKeyView *key in self.allKeys)
    {
        [keyboardDesign adjustKeyView:key withOrientation:orientation];
    }
}

- (NSTimer *)timerWithTimeInterval:(NSTimeInterval)timeInterval selector:(SEL)selector repeats:(BOOL)repeats
{
    return [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:selector userInfo:nil repeats:repeats];
}

- (void)continuousDeleteAction
{
    [self.touchTimer invalidate];
    self.touchTimer = [self timerWithTimeInterval:kMMKeyboardViewCharacterDeleteInterval selector:@selector(deleteCharacterAction) repeats:YES];
}

- (void)deleteCharacterAction
{
    if (self.characterDeleteCount > 0)
    {
        [self deleteWordAction];
    }
    else
    {
        [self.touchTimer invalidate];
        self.touchTimer = [self timerWithTimeInterval:kMMKeyboardViewWordDeleteInterval selector:@selector(deleteWordAction) repeats:YES];
    }
    
    self.characterDeleteCount--;
}

- (void)deleteWordAction
{
    [MMAudioManager playClickSound];
    [self.delegate keyboardViewControllerDeleteLastWord:self];
    [self textHasChanged];
}

- (void)keyHoldAction
{
    [self keyDidTouchAndHold:self.activeKey];
    
    [self.touchTimer invalidate];
    self.touchTimer = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self.touchesImage registerTouchAtPosition:[touch locationInView:self.view]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.activeKey = nil;
    
    for (MMKeyView *key in self.allKeys)
    {
        [key highlight:NO];
    }
}

@end
