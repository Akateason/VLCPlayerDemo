//
//  XTVLC.m
//  VLCDemo
//
//  Created by teason23 on 2018/6/4.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "XTVLC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XTVLCConst.h"
#import <Masonry.h>
#import <XTlib.h>

static const NSTimeInterval kVideoPlayerAnimationTimeinterval = 0.25f;

@interface XTVLC () <VLCMediaThumbnailerDelegate>
{
    BOOL hasCloseButton ;
    BOOL m_forceHorizon ;
}
@property (nonatomic,strong,readwrite) VLCMediaPlayer *player ;
@property (nonatomic, nonnull,strong) XTVLCView *controlView ;
@property (strong, nonatomic) VLCMediaThumbnailer *thumbnailer ;
@end

@implementation XTVLC

#pragma mark - Life

- (instancetype)init {
    if (self = [super init]) {
        [self setupNotification] ;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"xtplayer dealloc") ;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self setupPlayer] ;
    [self setupView] ;
    [self setupControlView] ;
}


#pragma mark - Public

- (void)showMeInView:(UIView * _Nonnull)view
                 url:(NSURL * _Nonnull)url
{
    [self showMeInView:view url:url hasCloseButton:YES] ;
}

- (void)showMeInView:(UIView * _Nonnull)view
                 url:(NSURL * _Nonnull)url
      hasCloseButton:(BOOL)hasCloseBt
{
    [self showMeInView:view url:url hasCloseButton:hasCloseBt forceHorizon:NO] ;
}

- (void)showMeInView:(UIView * _Nonnull)view
                 url:(NSURL * _Nonnull)url
      hasCloseButton:(BOOL)hasCloseBt
        forceHorizon:(BOOL)forceHorizon
{
    self.mediaURL = url ;
    hasCloseButton = hasCloseBt ;
    m_forceHorizon = forceHorizon ;
    [self showInView:view forceHorizon:forceHorizon] ;
}

- (void)dismiss {
    if (![self superview]) return ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.thumbnailer fetchThumbnail] ; // get thumbnail when stop or dismiss
        // 注销通知
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications] ;
        [[NSNotificationCenter defaultCenter] removeObserver:self] ;
        
        [self removeFromSuperview] ;
    }) ;
}

- (void)catchThumbnail {
    [self.thumbnailer fetchThumbnail] ; // get thumbnail when stop or dismiss . go to delegate .
}

#pragma mark - vlc thumbnail delegate

- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    NSLog(@"getThumbnailer time out.");
    if (self.willDismissAndCatchThumbnail) self.willDismissAndCatchThumbnail(self.player,nil) ;
    
    if (_player) {
        [_player stop] ;
        _player.delegate = nil ;
        _player = nil ;
    }
}

- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    UIImage *image = [UIImage imageWithCGImage:thumbnail] ;
    if (self.willDismissAndCatchThumbnail) self.willDismissAndCatchThumbnail(self.player,image) ;
    
    if (_player) {
        [_player stop] ;
        _player.delegate = nil ;
        _player = nil ;
    }
}

#pragma mark - Private

- (void)showInView:(UIView *)view forceHorizon:(BOOL)forceHorizon {
    [view addSubview:self] ;
    if (m_forceHorizon) [self forceChangeOrientation:UIInterfaceOrientationLandscapeRight] ;
    
    self.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerAnimationTimeinterval
                     animations:^{
                         self.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self play] ;
                     }];
}

- (void)setupView {
    [self setBackgroundColor:[UIColor blackColor]] ;
}

- (void)setupPlayer {
    [self.player setDrawable:self] ;
    self.player.media = [[VLCMedia alloc] initWithURL:self.mediaURL] ;
}

- (void)setupControlView {
    [self addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self) ;
    }] ;
    
    self.controlView.closeButton.hidden = !hasCloseButton ;
    
    //添加控制界面的监听方法
    [self.controlView.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.progressSlider addTarget:self action:@selector(progressValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)setupNotification {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationHandler)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

/**
 *    强制横屏
 */
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation
{
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]] ;
        [invocation setSelector:selector] ;
        [invocation setTarget:[UIDevice currentDevice]] ;
        [invocation setArgument:&val atIndex:2] ;
        [invocation invoke] ;
    }
}

#pragma mark Notification Handler
/**
 *    屏幕旋转处理
 */
- (void)orientationHandler
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        self.isFullscreenModel = YES ;
    }
    else {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            self.isFullscreenModel = NO ;
        }
    }
    [self.controlView autoFadeOutControlBar] ;
}

/**
 *    即将进入后台的处理
 */
- (void)applicationWillEnterForeground {
    [self play];
}

/**
 *    即将返回前台的处理
 */
- (void)applicationWillResignActive {
    [self pause];
}

#pragma mark - Button Event

- (void)playButtonClick {
    [self play];
}

- (void)pauseButtonClick {
    [self pause];
}

- (void)closeButtonClick {
    [self dismiss];
}

- (void)fullScreenButtonClick {
    UIInterfaceOrientation orientation;
    if (self.controlView.fullScreenButton.selected) {
        orientation = UIInterfaceOrientationPortrait;
    }
    else {
        orientation = UIInterfaceOrientationLandscapeRight;
    }
    [self forceChangeOrientation:orientation] ;
}

- (void)progressValueChanged {
    self.controlView.isHorizonPan = FALSE ;
    self.controlView.isVericalPan = FALSE ;
    
    float rate = self.controlView.progressSlider.value ;
    if (![self.player isPlaying]) {
        [self.player play] ;
    }
    [self.player setPosition:rate] ;
    [self.controlView autoFadeOutControlBar] ;
    
    self.controlView.isHorizonPan = TRUE ;
    self.controlView.isVericalPan = TRUE ;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(progressValueChanged)
                                               object:nil] ;
}

#pragma mark - Player Logic

- (void)play {
    [self.player play];
    self.controlView.playButton.hidden = YES;
    self.controlView.pauseButton.hidden = NO;
    [self.controlView autoFadeOutControlBar];
}

- (void)pause {
    [self.player pause];
    self.controlView.playButton.hidden = NO;
    self.controlView.pauseButton.hidden = YES;
    [self.controlView autoFadeOutControlBar];
}

- (void)stop {
    [self.player stop];
    self.controlView.progressSlider.value = 1;
    self.controlView.playButton.hidden = NO;
    self.controlView.pauseButton.hidden = YES;
}

#pragma mark - VLC Delegate

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    // Every Time change the state,The VLC will draw video layer on this layer.
    [self bringSubviewToFront:self.controlView];
    
    // player state
    switch (self.player.state) {
        case VLCMediaPlayerStateStopped: {
            NSLog(@"stop") ;
            [self stop];
        }
            break;
        case VLCMediaPlayerStateOpening: {
            NSLog(@"open") ;
        }
            break;
        case VLCMediaPlayerStateBuffering: {
            NSLog(@"buffer") ;
        }
            break;
        case VLCMediaPlayerStateEnded: {
            NSLog(@"end") ;
            [self dismiss] ;
        }
            break;
        case VLCMediaPlayerStateError: {
            NSLog(@"error") ;
        }
            break;
        case VLCMediaPlayerStatePlaying: {
            NSLog(@"playint") ;
        }
            break;
        case VLCMediaPlayerStatePaused: {
            NSLog(@"pause") ;
        }
            break;
        case VLCMediaPlayerStateESAdded: {
            NSLog(@"es add") ;
        }
            break;
        default:
            break;
    }
    
    if ([self superview]) {
        // media state
        self.controlView.bgLayer.hidden = self.player.media.state == VLCMediaStatePlaying;
    }
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification
{
    [self bringSubviewToFront:self.controlView];
    if (self.controlView.progressSlider.state != UIControlStateNormal) return ;
    
    float precentValue = ([self.player.time.value floatValue]) / ([kMediaLength.value floatValue]) ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.controlView.progressSlider setValue:precentValue animated:YES];
        [self.controlView.timeLabel setText:[NSString stringWithFormat:@"%@/%@",_player.time.stringValue,kMediaLength.stringValue]] ;
    }) ;
}

#pragma mark - ControlView

- (BOOL)controlViewFingerMoveLeft {
    [self.player extraShortJumpBackward] ;
    
    if (![self.player isPlaying]) {
        return false ;
    }
    return true ;
}

- (BOOL)controlViewFingerMoveRight {
    [self.player extraShortJumpForward] ;
    
    if (![self.player isPlaying]) {
        return false ;
    }
    return true ;
}

- (void)controlViewFingerMoveUp {
    self.controlView.volumeSlider.value += 0.05;
}

- (void)controlViewFingerMoveDown {
    self.controlView.volumeSlider.value -= 0.05;
}

#pragma mark - Props

- (VLCMediaPlayer *)player {
    if (!_player) {
        _player = [[VLCMediaPlayer alloc] init] ;
        _player.delegate = self;
    }
    return _player;
}

- (XTVLCView *)controlView {
    if (!_controlView) {
        _controlView = [[XTVLCView alloc] init];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (void)setIsFullscreenModel:(BOOL)isFullscreenModel
{
    if (_isFullscreenModel == isFullscreenModel) return ;
    
    _isFullscreenModel = isFullscreenModel ;
    float widScreen = APP_WIDTH ;
    float heiScreen = APP_HEIGHT ;
    
    if (isFullscreenModel) { // 全屏
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(widScreen) ;
            make.height.mas_equalTo(heiScreen) ;
        }] ;
        
        self.controlView.fullScreenButton.selected = YES ;
    }
    else { // 原本竖屏
        if (m_forceHorizon) return ; // 强行只支持横屏
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(widScreen)) ;
            make.height.mas_equalTo(widScreen / 16 * 9) ;
        }] ;
        self.controlView.fullScreenButton.selected = NO ;
    }
    
    [self layoutIfNeeded] ;
}

- (VLCMediaThumbnailer *)thumbnailer {
    if (!_thumbnailer) {
        _thumbnailer = [VLCMediaThumbnailer thumbnailerWithMedia:self.player.media andDelegate:self] ;
    }
    return _thumbnailer ;
}

@end