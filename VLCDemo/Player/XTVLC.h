//
//  XTVLC.h
//  VLCDemo
//
//  Created by teason23 on 2018/6/4.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "XTVLCView.h"
#import <XTlib.h>

typedef void (^PlayerWillDismissBlock)(VLCMediaPlayer *_Nonnull player, UIImage *_Nullable thumbnail);


@interface XTVLC : UIView <VLCMediaPlayerDelegate, XTVLCViewDelegate>

@property (nonatomic, strong, nonnull) NSURL *mediaURL;
@property (nonatomic, assign) BOOL isFullscreenModel;
@property (nonatomic, copy) PlayerWillDismissBlock _Nullable willDismissAndCatchThumbnail;
@property (nonatomic, strong, readonly) VLCMediaPlayer *_Nonnull player;

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


- (void)play;
- (void)stop;
- (BOOL)isPlaying;
- (void)dismiss;
- (void)changeMediaURL:(NSURL *_Nonnull)mediaURL;
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation;

@end
