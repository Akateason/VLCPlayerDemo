//
//  XTPlayerVC.m
//  VLCDemo
//
//  Created by teason23 on 2018/2/26.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "XTPlayerVC.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface XTPlayerVC () <VLCMediaPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topBack;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *btDismiss;

@property (weak, nonatomic) IBOutlet UIView *bottomBack;
@property (weak, nonatomic) IBOutlet UIView *progressArea;//进度区.手可点击
@property (weak, nonatomic) IBOutlet UIView *progressBar;//进度条
@property (weak, nonatomic) IBOutlet UILabel *lbAllTime;//总时间
@property (weak, nonatomic) IBOutlet UILabel *lbThisTime;//当前播放到时间
@property (weak, nonatomic) IBOutlet UIButton *btZoom;
@property (weak, nonatomic) IBOutlet UIButton *btPlay;//play or pause
@property (weak, nonatomic) IBOutlet UIButton *btProgress;//进度条上的.要拖拽的点.


@property (nonatomic,strong,readwrite) VLCMediaPlayer *player ;
@end

@implementation XTPlayerVC

#pragma mark - action

- (IBAction)btBackOnClick:(id)sender {
    
}

- (IBAction)btZoomOnCllick:(UIButton *)sender {
    
}

- (IBAction)btPlayOnClick:(UIButton *)sender {
    
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
