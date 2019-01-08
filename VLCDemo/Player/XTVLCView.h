//
//  XTVLCView.h
//  VLCDemo
//
//  Created by teason23 on 2018/6/4.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XTVLCConst.h"

@protocol XTVLCViewDelegate <NSObject>
@optional
- (void)controlViewFingerMoveUp;
- (void)controlViewFingerMoveDown;
- (BOOL)controlViewFingerMoveLeft;
- (BOOL)controlViewFingerMoveRight;
@end


@interface XTVLCProgressSlider : UISlider
@end


@interface XTVLCView : UIView

@property (nonatomic, weak) id<XTVLCViewDelegate> delegate;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIView *bottomBarAppend;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
//@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) XTVLCProgressSlider *progressSlider;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UILabel *alertlable;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic) BOOL isVericalPan;
@property (nonatomic) BOOL isHorizonPan;

- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;

@end


@interface UILabel (ConfigureAble)
- (void)configureWithTime:(NSString *)time isLeft:(BOOL)left;
- (void)configureWithLight;
- (void)configureWithVolume:(float)volume;
@end
