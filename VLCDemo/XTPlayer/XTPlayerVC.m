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
#import <ReactiveObjC.h>

@interface XTPlayerVC () <VLCMediaPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topBack;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *btDismiss;

@property (weak, nonatomic) IBOutlet UIView *bottomBack;
@property (weak, nonatomic) IBOutlet UIView *progressArea;//进度区.手可点击
@property (weak, nonatomic) IBOutlet UIView *progressBar;//进度条
@property (weak, nonatomic) IBOutlet UIButton *btProgress;//进度条上的.要拖拽的点.
@property (weak, nonatomic) IBOutlet UILabel *lbAllTime;//总时间
@property (weak, nonatomic) IBOutlet UILabel *lbThisTime;//当前播放到时间
@property (weak, nonatomic) IBOutlet UIButton *btZoom;
@property (weak, nonatomic) IBOutlet UIButton *btPlay;//play or pause


@property (nonatomic) BOOL isDrag;  //抢单按钮是否处于拖动状态

@end

@implementation XTPlayerVC

#pragma mark - public

+ (void)addPlayerInCtrller:(UIViewController *)fromCtrller {
    XTPlayerVC *playerVC = [[XTPlayerVC alloc] initWithNibName:@"XTPlayerVC" bundle:nil] ;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:playerVC] ;
    [fromCtrller presentViewController:navVC
                              animated:YES
                            completion:nil] ;
}

#pragma mark - action

- (IBAction)btBackOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)btZoomOnCllick:(UIButton *)sender {
    
}

- (IBAction)btPlayOnClick:(UIButton *)sender {
    
}

#pragma mark - life

- (void)dragMoving:(UIControl *)c withEvent:event {
    CGPoint center = [[[event allTouches] anyObject] locationInView:self.view];
    c.center = center;
//    //不能超出范围
//    if (center.x - c.width/ 2 >= 0 && center.x + c.width/ 2 <= 100 && center.y -c.height / 2 >= 0 && center.y + c.height < self.view.height - 10) {
//        c.center = center;
//    }
    NSLog(@"center %@",NSStringFromCGPoint(center)) ;
    self.isDrag = YES;
 }

- (void)dragEnded:(UIControl *)c withEvent:event {
    c.center = [[[event allTouches] anyObject] locationInView:self.view];
    self.btProgress.center = c.center; //在这里我用了一个变量存放最后的位置，当viewDidLayoutSubviews方法里使按钮保持在用户最后选定的位置
    self.isDrag = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.drag the progressBt
    [self.btProgress addTarget:self
                        action:@selector(dragMoving:withEvent:)
              forControlEvents:UIControlEventTouchDragInside];
    [self.btProgress addTarget:self
                        action:@selector(dragEnded:withEvent:)
              forControlEvents:UIControlEventTouchUpOutside];

    
    // 2.tap progress area -> progressBt move to .
    
    // 3.finger move horizon
    
    // 4.finger move verical left
    
    // 5.finger move verical right
    
    
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
