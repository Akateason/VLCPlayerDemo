//
//  XTVLCView.m
//  VLCDemo
//
//  Created by teason23 on 2018/6/4.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "XTVLCView.h"
#import <Masonry.h>
#import <ReactiveObjC.h>
#import <XTBase.h>


@interface XTVLCView ()
@property (strong, nonatomic) RACSubject *soundSignal;
@property (strong, nonatomic) RACSubject *lightSignal;
@end


@implementation XTVLCView


#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];

        @weakify(self)
            [[self.soundSignal throttle:.3] subscribeNext:^(NSNumber *x) {
                @strongify(self) bool bPan = [x boolValue];
                if (bPan)
                    self.volumeSlider.value -= 0.1;
                else
                    self.volumeSlider.value += 0.1;

                [self.alertlable configureWithVolume:self.volumeSlider.value];
            }];

        [[self.lightSignal throttle:.3] subscribeNext:^(NSNumber *x) {
            @strongify(self) bool bPan = [x boolValue];
            if (bPan)
                [UIScreen mainScreen].brightness -= 0.1;
            else
                [UIScreen mainScreen].brightness += 0.1;
            [self.alertlable configureWithLight];
        }];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}


#pragma mark - Public Method
- (void)animateHide {
    [UIView animateWithDuration:XTVLCVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha    = 0;
        self.bottomBar.alpha = 0;
    } completion:^(BOOL finished){}];
}

- (void)animateShow {
    [UIView animateWithDuration:XTVLCVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha    = 1;
        self.bottomBar.alpha = 1;
    } completion:^(BOOL finished) {
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:XTVLCVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}


#pragma mark - Private Method
- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.bgLayer];

    //    self.topBar.backgroundColor = [UIColor redColor] ;

    [self addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(XTVLCVideoControlBarHeight);
    }];

    [self addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(XTVLCVideoControlBarHeight);
    }];

    if (xt_isIPhoneXSeries()) {
        UIView *additionOnIfIpXSerious         = [UIView new];
        additionOnIfIpXSerious.backgroundColor = XTVLCRGB(27, 27, 27);
        [self addSubview:additionOnIfIpXSerious];
        [additionOnIfIpXSerious mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.mas_safeAreaLayoutGuideBottom);
        }];
    }

    CGFloat ipxFlexForCloseBt = (xt_isIPhoneXSeries()) ? -20 : 0;
    [self.topBar addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar);
        make.right.equalTo(self.topBar).offset(ipxFlexForCloseBt);
        make.size.mas_equalTo(CGSizeMake(XTVLCVideoControlBarHeight, XTVLCVideoControlBarHeight));
    }];

    [self.bottomBar addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomBar);
        make.size.mas_equalTo(CGSizeMake(XTVLCVideoButtonHeight, XTVLCVideoButtonHeight));
    }];

    [self.bottomBar addSubview:self.pauseButton];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomBar);
        make.size.mas_equalTo(CGSizeMake(XTVLCVideoButtonHeight, XTVLCVideoButtonHeight));
    }];

    [self addSubview:self.alertlable];
    [self.alertlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

    [self.bottomBar addSubview:self.fullScreenButton];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomBar.mas_bottom);
        make.right.equalTo(self.bottomBar.mas_right).mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(XTVLCVideoButtonHeight, XTVLCVideoButtonHeight));
    }];

    [self.bottomBar addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bottomBar);
        make.height.mas_equalTo(XTVLCVideoControlSliderHeight);
    }];

    [self.bottomBar addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playButton.mas_centerY);
        make.left.equalTo(self.playButton.mas_right);
    }];

    self.pauseButton.hidden = YES;

    [self addGestureRecognizer:self.pan];
}


- (void)responseTapImmediately {
    self.bottomBar.alpha == 0 ? [self animateShow] : [self animateHide];
}

#pragma mark - Override
#pragma mark Touch Event


- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint localPoint = [pan locationInView:self];
    CGPoint speedDir   = [pan velocityInView:self];

    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.alertlable.alpha = XTVLCVideoControlAlertAlpha;
            // 判断方向
            if (ABS(speedDir.x) > ABS(speedDir.y)) {
                _isVericalPan = false;
                _isHorizonPan = true;
            }
            else {
                _isVericalPan = true;
                _isHorizonPan = false;
            }
        } break;

        case UIGestureRecognizerStateChanged: {
            // 判断方向
            if (_isHorizonPan) {
                if ([pan translationInView:self].x > 0) {
                    if ([_delegate respondsToSelector:@selector(controlViewFingerMoveRight)]) {
                        BOOL bResult = [self.delegate controlViewFingerMoveRight];
                        if (!bResult) return;
                        [self.alertlable configureWithTime:self.timeLabel.text
                                                    isLeft:NO];
                    }
                }
                else {
                    if ([_delegate respondsToSelector:@selector(controlViewFingerMoveRight)]) {
                        BOOL bResult = [self.delegate controlViewFingerMoveLeft];
                        if (!bResult) return;
                        [self.alertlable configureWithTime:self.timeLabel.text
                                                    isLeft:YES];
                    }
                }
            }
            else if (_isVericalPan) {
                if (localPoint.x > self.bounds.size.width / 2) {
                    // 改变音量
                    [self.soundSignal sendNext:@([pan translationInView:self].y > 0)];
                }
                else {
                    // 改变显示亮度
                    [self.lightSignal sendNext:@([pan translationInView:self].y > 0)];
                }
            }
        } break;

        case UIGestureRecognizerStateEnded: {
            _isVericalPan = true;
            _isHorizonPan = true;

            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    self.alertlable.alpha = 0;
                }];
            });
        } break;

        default:
            break;
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.tapCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self responseTapImmediately];
        });
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self responseTapImmediately];
}

#pragma mark - Property

- (UIView *)topBar {
    if (!_topBar) {
        _topBar                 = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar                 = [UIView new];
        _bottomBar.backgroundColor = XTVLCRGB(27, 27, 27);
    }
    return _bottomBar;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"Play Icon"] forState:UIControlStateNormal];
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"Pause Icon"] forState:UIControlStateNormal];
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"Full Screen Icon"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage imageNamed:@"Min. Icon"] forState:UIControlStateSelected];
    }
    return _fullScreenButton;
}

- (XTVLCProgressSlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[XTVLCProgressSlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"Player Control Nob"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:XTVLCRGB(239, 71, 94)];
        [_progressSlider setMaximumTrackTintColor:XTVLCRGB(157, 157, 157)];
        [_progressSlider setBackgroundColor:[UIColor clearColor]];
        _progressSlider.value      = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"Player close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel                 = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font            = [UIFont systemFontOfSize:XTVLCVideoControlTimeLabelFontSize];
        _timeLabel.textColor       = [UIColor lightGrayColor];
        _timeLabel.textAlignment   = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer                 = [CALayer layer];
        _bgLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Video Bg"]].CGColor;
        _bgLayer.bounds          = self.frame;
        _bgLayer.position        = self.center;
    }
    return _bgLayer;
}

- (UISlider *)volumeSlider {
    if (!_volumeSlider) {
        for (UIControl *view in self.volumeView.subviews) {
            if ([view.superclass isSubclassOfClass:[UISlider class]]) {
                _volumeSlider = (UISlider *)view;
            }
        }
    }
    return _volumeSlider;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
    }
    return _volumeView;
}

- (UILabel *)alertlable {
    if (!_alertlable) {
        _alertlable                     = [UILabel new];
        _alertlable.textAlignment       = NSTextAlignmentCenter;
        _alertlable.backgroundColor     = [UIColor colorWithWhite:0.000 alpha:XTVLCVideoControlAlertAlpha];
        _alertlable.textColor           = [UIColor whiteColor];
        _alertlable.layer.cornerRadius  = 10;
        _alertlable.layer.masksToBounds = YES;
        _alertlable.alpha               = 0;
    }
    return _alertlable;
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    }
    return _pan;
}


- (RACSubject *)soundSignal {
    if (!_soundSignal) {
        _soundSignal = ({
            RACSubject *object = [[RACSubject alloc] init];
            object;
        });
    }
    return _soundSignal;
}

- (RACSubject *)lightSignal {
    if (!_lightSignal) {
        _lightSignal = ({
            RACSubject *object = [[RACSubject alloc] init];
            object;
        });
    }
    return _lightSignal;
}
@end


@implementation XTVLCProgressSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0,
                      self.bounds.size.height * 0.6,
                      self.bounds.size.width,
                      XTVLCProgressWidth);
}

@end


@implementation UILabel (ConfigureAble)

- (void)configureWithTime:(NSString *)time isLeft:(BOOL)left {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:time];
    });
}
- (void)configureWithLight {
    self.text = [NSString stringWithFormat:@"亮度:%d%%", (int)([UIScreen mainScreen].brightness * 100)];
}

- (void)configureWithVolume:(float)volume {
    self.text = [NSString stringWithFormat:@"音量:%d%%", (int)(volume * 100)];
}

@end
