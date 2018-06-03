//
//  MRVLCPlayer.h
//  MRVLCPlayer
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "MRVideoControlView.h"

typedef void(^PlayerWillDismissBlock)(VLCMediaPlayer * _Nonnull player, UIImage * _Nullable thumbnail) ;

@interface MRVLCPlayer : UIView <VLCMediaPlayerDelegate,MRVideoControlViewDelegate>

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


