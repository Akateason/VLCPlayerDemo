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

@property (nonatomic,strong,nonnull) NSURL *mediaURL;
@property (nonatomic,assign) BOOL isFullscreenModel;
@property (nonatomic,copy) DismissCompleteBlock _Nullable dismissComplete ;

- (void)showInView:(UIView * _Nonnull)view;
- (void)play ;
- (void)dismiss ;





@end


