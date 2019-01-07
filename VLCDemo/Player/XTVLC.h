//
//  XTVLC.h
//  VLCDemo
//
//  Created by teason23 on 2018/6/4.
//  Copyright © 2018年 teason23. All rights reserved.
// 这是一个View的封装, 由于vlc的机制不要试图单例化它.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "XTVLCView.h"
#import <XTlib.h>

typedef void (^PlayerWillDismissBlock)(VLCMediaPlayer *_Nonnull player, UIImage *_Nullable thumbnail);


@interface XTVLC : UIView <VLCMediaPlayerDelegate, XTVLCViewDelegate>

@property (nonatomic, strong, readonly) VLCMediaPlayer *_Nonnull player;
@property (nonatomic, strong, nonnull) NSURL *mediaURL;
@property (nonatomic, assign) BOOL isFullscreenModel;
@property (nonatomic, copy) PlayerWillDismissBlock _Nullable willDismissAndCatchThumbnail;
@property (nonatomic) BOOL m_hasCloseButton;
@property (nonatomic) BOOL m_forceHorizon;
@property (nonatomic) BOOL m_forbiddenGesture;

- (void)showMeInView:(UIView *_Nonnull)view
                 url:(NSURL *_Nullable)url;

- (void)showMeInView:(UIView *_Nonnull)view
                 url:(NSURL *_Nullable)url
      hasCloseButton:(BOOL)hasCloseBt;

- (void)showMeInView:(UIView *_Nonnull)view
                 url:(NSURL *_Nullable)url
      hasCloseButton:(BOOL)hasCloseBt
        forceHorizon:(BOOL)forceHorizon
    forbiddenGesture:(BOOL)forbiddenGesture;

- (void)showMeInView:(UIView *_Nonnull)view
                 url:(NSURL *_Nullable)url
      hasCloseButton:(BOOL)hasCloseBt
        forceHorizon:(BOOL)forceHorizon
    forbiddenGesture:(BOOL)forbiddenGesture
       startFromRate:(int)startFrom;


- (void)play;
- (void)playFromMilesSeconds:(int)ms;
- (void)stop;
- (BOOL)isPlaying;
- (void)dismiss;
- (void)changeMediaURL:(NSURL *_Nonnull)mediaURL;
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation;

@end
