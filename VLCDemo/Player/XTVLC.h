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

typedef void(^PlayerWillDismissBlock)(VLCMediaPlayer * _Nonnull player, UIImage * _Nullable thumbnail) ;

@interface XTVLC : UIView <VLCMediaPlayerDelegate,XTVLCViewDelegate>
@property (nonatomic,strong,nonnull) NSURL  *mediaURL ;
@property (nonatomic,assign)         BOOL    isFullscreenModel ;
@property (nonatomic,copy) PlayerWillDismissBlock _Nullable willDismissAndCatchThumbnail ;

- (void)showMeInView:(UIView * _Nonnull)view
                 url:(NSURL * _Nonnull)url ;

- (void)showMeInView:(UIView * _Nonnull)view
                 url:(NSURL * _Nonnull)url
      hasCloseButton:(BOOL)hasCloseBt ;

- (void)showMeInView:(UIView * _Nonnull)view
                 url:(NSURL * _Nonnull)url
      hasCloseButton:(BOOL)hasCloseBt
        forceHorizon:(BOOL)forceHorizon ;

- (void)play ;

- (void)dismiss ;

- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation ;

@end
