//
//  PlayingCtrller.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/6/21.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "PlayingCtrller.h"
#import "XTVLC.h"
#import "Masonry.h"
#import "FileModel.h"
#import "XTFMDB.h"
#import "UIViewController+FileUrl.h"
#import <XTlib.h>
#import <ReactiveObjC.h>
#import "AppDelegate.h"


@interface PlayingCtrller ()
@property (strong, nonatomic) XTVLC *playerView;
@property (nonatomic, strong) FileModel *model;
@end


@implementation PlayingCtrller

+ (instancetype)newVCFromModel:(id)model {
    PlayingCtrller *pVC = [PlayingCtrller new];
    pVC.model           = model;
    [pVC setupPlayer:0];
    return pVC;
}

+ (instancetype)newVCFromVLC:(XTVLC *)xtvlc
                       model:(id)model
                   startFrom:(int)startFrom {
    PlayingCtrller *pVC = [PlayingCtrller new];
    // todo
    //    xtvlc.m_hasCloseButton = YES ;
    //    xtvlc.m_forceHorizon = YES ;
    //    xtvlc.m_forbiddenGesture = NO ;
    //    pVC.playerView = xtvlc ;

    pVC.model = model;
    [pVC setupPlayer:startFrom];
    return pVC;
}

#pragma mark - life

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout           = UIRectEdgeNone;
    AppDelegate *appdelegate              = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.orientationsOnlyLandScape = YES;
    appdelegate.orientationsOnlyRotate    = NO;

    self.view.backgroundColor = [UIColor blackColor];
}

- (void)setupPlayer:(float)startFrom {
    self.playerView = [XTVLC new];
    NSURL *url      = [NSURL fileURLWithPath:[self.model fullPathWithBasePath:[self baseFullPath]]];

    [self.playerView showMeInView:self.view
                              url:url
                   hasCloseButton:YES
                     forceHorizon:YES
                 forbiddenGesture:NO
                    startFromRate:startFrom];

    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    @weakify(self)
        self.playerView.willDismissAndCatchThumbnail = ^(VLCMediaPlayer *_Nonnull player, UIImage *_Nullable thumbnail) {

        @strongify(self)
            self.model.allTime = player.media.length.stringValue;
        self.model.lastTime    = player.time.stringValue;
        self.model.imgCover    = thumbnail;
        self.model.msPlayTime  = [player.time.value intValue];
        [self.model xt_update];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate refreshModel:self.model];
        });
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO];
    [self.playerView forceChangeOrientation:UIInterfaceOrientationPortrait];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
