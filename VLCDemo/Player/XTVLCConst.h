//
//  XTVLCConst.h
//  VLCDemo
//
//  Created by teason23 on 2018/6/4.
//  Copyright © 2018年 teason23. All rights reserved.
//

#ifndef XTVLCConst_h
#define XTVLCConst_h

#define kMediaLength self.player.media.length
#define kHUDCenter CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
#define XTVLCRGB(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define kXTVLCSCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define XTVLCVideoControlBarHeight XTVLCVideoButtonHeight + XTVLCVideoControlSliderHeight

/*************** HUD ****************************/
static const NSTimeInterval kHUDCycleTimeInterval = 0.8f;
static const CGFloat kHUDCycleLineWidth           = 3.0f;

/*************** Control ****************************/
static const CGFloat XTVLCProgressWidth                          = 3.0f;
static const CGFloat XTVLCVideoControlTimeLabelFontSize          = 10.0;
static const CGFloat XTVLCVideoControlSliderHeight               = 10.0;
static const CGFloat XTVLCVideoButtonHeight                      = 40.;
static const CGFloat XTVLCVideoControlAnimationTimeinterval      = 0.3;
static const CGFloat XTVLCVideoControlBarAutoFadeOutTimeinterval = 4.0;
static const CGFloat XTVLCVideoControlCorrectValue               = 3;
static const CGFloat XTVLCVideoControlAlertAlpha                 = 0.75;


#endif /* XTVLCConst_h */
