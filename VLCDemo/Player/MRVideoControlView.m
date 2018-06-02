//
//  MRVideoControl.m
//  MRVLCPlayer
//
//  Created by Maru on 16/3/8.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "MRVideoControlView.h"
#import "Masonry.h"

@interface MRVideoControlView ()

@end

@implementation MRVideoControlView

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView] ;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}


#pragma mark - Public Method
- (void)animateHide
{
    [UIView animateWithDuration:MRVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 0;
        self.bottomBar.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

- (void)animateShow
{
    [UIView animateWithDuration:MRVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 1;
        self.bottomBar.alpha = 1;
    } completion:^(BOOL finished) {
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:MRVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}


#pragma mark - Private Method
- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];

    [self.layer addSublayer:self.bgLayer];
    
    [self addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self) ;
        make.height.mas_equalTo(MRVideoControlBarHeight) ;
    }] ;
    
    [self addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self) ;
        make.height.mas_equalTo(MRVideoControlBarHeight) ;
    }] ;
    
    [self.topBar addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.topBar) ;
        make.size.mas_equalTo(CGSizeMake(MRVideoControlBarHeight, MRVideoControlBarHeight)) ;
    }] ;
    
    [self.bottomBar addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomBar) ;
        make.size.mas_equalTo(CGSizeMake(MRVideoButtonHeight, MRVideoButtonHeight)) ;
    }] ;
    
    [self.bottomBar addSubview:self.pauseButton];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomBar) ;
        make.size.mas_equalTo(CGSizeMake(MRVideoButtonHeight, MRVideoButtonHeight)) ;
    }] ;
    
    [self addSubview:self.alertlable];
    [self.alertlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self) ;
    }] ;
    
    [self.bottomBar addSubview:self.fullScreenButton];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomBar.mas_bottom) ;
        make.right.equalTo(self.bottomBar.mas_right).mas_equalTo(-5) ;
        make.size.mas_equalTo(CGSizeMake(MRVideoButtonHeight, MRVideoButtonHeight)) ;
    }] ;
    
    [self.bottomBar addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bottomBar) ;
        make.height.mas_equalTo(MRVideoControlSliderHeight) ;
    }] ;
    
    [self.bottomBar addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playButton.mas_centerY) ;
        make.left.equalTo(self.playButton.mas_right) ;
    }] ;
    
    self.pauseButton.hidden = YES;
    
    
    [self addGestureRecognizer:self.pan] ;
}


- (void)responseTapImmediately
{
    self.bottomBar.alpha == 0 ? [self animateShow] : [self animateHide];
}

#pragma mark - Override
#pragma mark Touch Event


- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint localPoint  = [pan locationInView:self] ;
    CGPoint speedDir    = [pan velocityInView:self] ;
    
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.alertlable.alpha = MRVideoControlAlertAlpha;
            
            // 判断方向
            if (ABS(speedDir.x) > ABS(speedDir.y))
            {
                _isVericalPan = false ;
                _isHorizonPan = true ;
            }
            else
            {
                _isVericalPan = true ;
                _isHorizonPan = false ;
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            // 判断方向
            if (_isHorizonPan)
            {
                
                if ([pan translationInView:self].x > 0)
                {
                    if ([_delegate respondsToSelector:@selector(controlViewFingerMoveRight)])
                    {
                        BOOL bResult = [self.delegate controlViewFingerMoveRight] ;
                        if (!bResult) return ;
                        [self.alertlable configureWithTime:self.timeLabel.text                  //[self.timeLabel.text substringToIndex:5]
                                                    isLeft:NO] ;
                    }
                }
                else
                {
                    if ([_delegate respondsToSelector:@selector(controlViewFingerMoveRight)])
                    {
                        BOOL bResult = [self.delegate controlViewFingerMoveLeft] ;
                        if (!bResult) return ;
                        [self.alertlable configureWithTime:self.timeLabel.text                  //[self.timeLabel.text substringToIndex:5]
                                                    isLeft:YES] ;
                    }
                }
                
            }
            else if (_isVericalPan)
            {
                
                if (localPoint.x > self.bounds.size.width / 2)
                {
                    // 改变音量
                    if ([pan translationInView:self].y > 0)
                    {
                        self.volumeSlider.value -= 0.03;
                    }
                    else
                    {
                        self.volumeSlider.value += 0.03;
                    }
                    [self.alertlable configureWithVolume:self.volumeSlider.value] ;
                }
                else
                {
                    // 改变显示亮度
                    if ([pan translationInView:self].y > 0)
                    {
                        [UIScreen mainScreen].brightness -= 0.01;
                    }
                    else
                    {
                        [UIScreen mainScreen].brightness += 0.01;
                    }
                    [self.alertlable configureWithLight];
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            _isVericalPan = true ;
            _isHorizonPan = true ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    self.alertlable.alpha = 0;
                }];
            });
        }
            break;
            
        default:
            break;
    }

}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self responseTapImmediately];
        });
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self responseTapImmediately];
}

#pragma mark - Property
//- (MRVideoHUDView *)indicatorView {
//    if (!_indicatorView) {
//        _indicatorView = [[MRVideoHUDView alloc] init];
//    }
//    return _indicatorView;
//}

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = MRRGB(27, 27, 27);
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"Play Icon"] forState:UIControlStateNormal];
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"Pause Icon"] forState:UIControlStateNormal];
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"Full Screen Icon"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage imageNamed:@"Min. Icon"] forState:UIControlStateSelected];
    }
    return _fullScreenButton;
}


- (MRProgressSlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[MRProgressSlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"Player Control Nob"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:MRRGB(239, 71, 94)];
        [_progressSlider setMaximumTrackTintColor:MRRGB(157, 157, 157)];
        [_progressSlider setBackgroundColor:[UIColor clearColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"Player close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:MRVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        _bgLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Video Bg"]].CGColor;
        _bgLayer.bounds = self.frame;
//        _bgLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
        _bgLayer.position = self.center ;
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

- (UILabel *)alertlable
{
    if (!_alertlable) {
        _alertlable = [UILabel new];
        _alertlable.textAlignment = NSTextAlignmentCenter;
        _alertlable.backgroundColor = [UIColor colorWithWhite:0.000 alpha:MRVideoControlAlertAlpha];
        _alertlable.textColor = [UIColor whiteColor];
        _alertlable.layer.cornerRadius = 10;
        _alertlable.layer.masksToBounds = YES;
        _alertlable.alpha = 0;
    }
    return _alertlable;
}



- (UIPanGestureRecognizer *)pan
{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    }
    return _pan ;
}


@end

@implementation MRProgressSlider

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0 ,
                      self.bounds.size.height * 0.6 ,
                      self.bounds.size.width ,
                      MRProgressWidth) ;
}

@end

@implementation UILabel (ConfigureAble)

- (void)configureWithTime:(NSString *)time isLeft:(BOOL)left
{
    [self setText:time] ;
//    left ? [self setText:[NSString stringWithFormat:@"<<%@",time]] : [self setText:[NSString stringWithFormat:@">>%@",time]];
}
- (void)configureWithLight {
    self.text = [NSString stringWithFormat:@"亮度:%d%%",(int)([UIScreen mainScreen].brightness * 100)];
}

- (void)configureWithVolume:(float)volume {
    self.text = [NSString stringWithFormat:@"音量:%d%%",(int)(volume * 100)];
}

@end


