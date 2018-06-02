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

typedef void(^DismissCompleteBlock)(VLCMediaPlayer * _Nonnull player) ;

@interface MRVLCPlayer : UIView <VLCMediaPlayerDelegate,MRVideoControlViewDelegate>

@property (nonatomic,strong,nonnull) NSURL  *mediaURL ;
@property (nonatomic,assign)         BOOL    isFullscreenModel ;
@property (nonatomic,copy) DismissCompleteBlock _Nullable dismissComplete ;


- (void)showMeInView:(UIView * _Nonnull)view
                 url:(NSURL * _Nonnull)url ;

- (void)showMeInView:(UIView * _Nonnull)view
                 url:(NSURL * _Nonnull)url
      hasCloseButton:(BOOL)hasCloseButton ;


- (void)play ;
- (void)dismiss ;

@end


