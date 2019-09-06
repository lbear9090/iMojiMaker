//
//  NotificationView.m
//  iMojiMaker
//
//  Created by Lucky on 5/24/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "NotificationView.h"

CGFloat const kTitleLabelFontSize = 15.0;
CGFloat const kMessageViewFontSize = 14.0;

@interface NotificationView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation NotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupLayer];
        [self setupSubviews];
        [self setupConstraints];
        [self setupTargets];
    }
    
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.tintColor = [UIColor whiteColor];
    }
    
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (UITextView *)messageView
{
    if (!_messageView)
    {
        _messageView = [[UITextView alloc] init];
        _messageView.font = [UIFont systemFontOfSize:kMessageViewFontSize weight:UIFontWeightSemibold];
        _messageView.backgroundColor = [UIColor clearColor];
        _messageView.textColor = [UIColor whiteColor];
        _messageView.userInteractionEnabled = NO;
        _messageView.textContainerInset = UIEdgeInsetsMake(0.0, -5.0, 0.0, 0.0);
        _messageView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return _messageView;
}

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer)
    {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotification)];
    }
    
    return _tapGestureRecognizer;
}

- (void)setupLayer
{
    self.layer.cornerRadius = 5.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.25;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
}

- (void)setupSubviews
{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageView];
}

- (void)setupConstraints
{
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[[self.imageView.topAnchor constraintEqualToAnchor:self.imageView.superview.topAnchor constant:12.0],
                                              [self.imageView.leadingAnchor constraintEqualToAnchor:self.imageView.superview.leadingAnchor constant:12.0],
                                              [self.imageView.bottomAnchor constraintEqualToAnchor:self.imageView.superview.bottomAnchor constant:-12.0],
                                              [self.imageView.widthAnchor constraintEqualToAnchor:self.imageView.heightAnchor]]];
    
    [NSLayoutConstraint activateConstraints:@[[self.titleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.superview.topAnchor constant:-2.0],
                                              [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:8.0],
                                              [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.superview.trailingAnchor constant:-8.0],
                                              [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.titleLabel.superview.centerYAnchor constant:-2.0]]];
    
    [NSLayoutConstraint activateConstraints:@[[self.messageView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:-6.0],
                                              [self.messageView.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
                                              [self.messageView.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor],
                                              [self.messageView.bottomAnchor constraintEqualToAnchor:self.messageView.superview.bottomAnchor constant:-4.0]]];
}

- (void)setupTargets
{
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setMessage:(NSString *)message
{
    self.messageView.text = message;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)setDismissDelay:(NSTimeInterval)dismissDelay
{
    _dismissDelay = dismissDelay;
    
    if (_dismissDelay > 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:_dismissDelay target:self selector:@selector(dismissNotification) userInfo:nil repeats:NO];
    }
}

- (void)showNotification
{
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.68 initialSpringVelocity:0.1 options:UIViewAnimationOptionLayoutSubviews animations:^
    {
        CGRect frame = self.frame;
#ifdef Application
        frame.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
#endif
        frame.origin.y += 10.0;
        
        self.frame = frame;
    } completion:nil];
}

- (void)dismissNotification
{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^
    {
        CGRect frame = self.frame;
        frame.origin.y = self.frame.origin.y + 5.0;
        
        self.frame = frame;
    }
    completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^
        {
            CGPoint center = self.center;
            center.y = -self.frame.size.height;
            
            self.center = center;
        }
        completion:^(BOOL finished)
        {
            if (self.completionBlock)
            {
                self.completionBlock();
            }
            
            [self removeFromSuperview];
        }];
    }];
}

@end
