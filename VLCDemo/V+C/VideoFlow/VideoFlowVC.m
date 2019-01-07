//
//  VideoFlowVC.m
//  VLCDemo
//
//  Created by teason23 on 2018/6/5.
//  Copyright © 2018年 teason23. All rights reserved.
// 持有一个instance . 不断切换内容播放, 随着cell调整位置.

#import "VideoFlowVC.h"
#import "VideoFlowCell.h"
#import "XTColor+MyColors.h"
#import "FileModel.h"
#import "XTVLC.h"
#import "UIViewController+FileUrl.h"
#import <XTlib.h>
#import "PlayingCtrller.h"
#import "AppDelegate.h"


@interface VideoFlowVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (copy, nonatomic) NSArray *datasource;

@property (strong, nonatomic) XTVLC *vlc;
@property (strong, nonatomic) UIView *movingContainer;
@property (nonatomic) int idx_isOn;
@end


@implementation VideoFlowVC

- (void)prepareUI {
    [super prepareUI];

    self.idx_isOn = -1;

    self.extendedLayoutIncludesOpaqueBars = YES;

    [_table xt_setup];
    _table.xt_hideAllRefreshers = YES;
    _table.dataSource           = self;
    _table.delegate             = self;
    _table.backgroundColor      = nil;

    [VideoFlowCell registerNibFromTable:_table];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    AppDelegate *appdelegate              = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.orientationsOnlyLandScape = NO;
    appdelegate.orientationsOnlyRotate    = YES;

    [self forceChangeOrientation:UIInterfaceOrientationPortrait];
}

- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation {
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.vlc.isPlaying) {
        NSIndexPath *current = [NSIndexPath indexPathForRow:self.idx_isOn inSection:0];
        [self stopWithIndexPath:current];
        self.idx_isOn = -1;
        [self.table reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoFlowCell *cell = [VideoFlowCell fetchFromTable:tableView];
    [cell configure:self.datasource[indexPath.row] indexPath:indexPath];
    [cell hiddenAll:indexPath.row == self.idx_isOn];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [VideoFlowCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = (int)indexPath.row;
    if (row == self.idx_isOn) {
        if ([self.vlc isPlaying]) {
            //进入 内部VC
            PlayingCtrller *playVC = [PlayingCtrller newVCFromModel:self.datasource[indexPath.row]];
            [playVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:playVC animated:YES];
        }
        else {
            [self.vlc play];
        }
        return;
    }

    self.idx_isOn = row;

    if (![self.vlc superview]) {
        [self.view addSubview:self.vlc];
        [self.view bringSubviewToFront:self.table];
    }
    [self changeRect:indexPath];
    [self playWithIndexPath:indexPath];
    [self.table reloadData];
}

- (void)scrollViewDidScroll:(RootTableView *)table {
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer *pan = table.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:table].y;

    if (velocity < -5) {
        //向上拖动，隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if (velocity > 5) {
        //向下拖动，显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else if (velocity == 0) {
        //停止拖拽
    }


    if (self.idx_isOn == -1) return;

    NSArray *visibleIndexes       = [table indexPathsForVisibleRows];
    __block BOOL containIsPlaying = false;
    [visibleIndexes enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *_Nonnull stop) {
        if (indexPath.row == self.idx_isOn) {
            containIsPlaying = true;
        }
    }];


    NSIndexPath *current = [NSIndexPath indexPathForRow:self.idx_isOn inSection:0];
    if ([self.vlc superview]) {
        [self changeRect:current];
    }

    if (!containIsPlaying) {
        [self stopWithIndexPath:current];
        self.idx_isOn = -1;
    }
}

- (void)changeRect:(NSIndexPath *)indexPath {
    VideoFlowCell *cell        = [self.table cellForRowAtIndexPath:indexPath];
    CGRect rect                = [self.table convertRect:cell.frame toView:self.view.window];
    self.movingContainer.frame = rect;
    [self.vlc mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.movingContainer);
    }];
}

- (void)playWithIndexPath:(NSIndexPath *)indexPath {
    FileModel *model = self.datasource[indexPath.row];
    NSString *sql    = [NSString stringWithFormat:@"baseName like '%%%@%%'", model.baseName];
    model            = [FileModel xt_findFirstWhere:sql];
    NSURL *url       = [NSURL fileURLWithPath:[model fullPathWithBasePath:[self baseFullPath]]];
    [self.vlc changeMediaURL:url];
    [self.vlc play];
}

- (void)stopWithIndexPath:(NSIndexPath *)indexPath {
    [self.vlc stop];
    [self.vlc removeFromSuperview];
}

#pragma mark - props

- (NSArray *)datasource {
    if (!_datasource) {
        _datasource = ({
            NSArray *object = [[FileModel xt_findWhere:@"fType == 1"] xt_orderby:@"xt_updateTime" descOrAsc:YES];
            object;
        });
    }
    return _datasource;
}

- (XTVLC *)vlc {
    if (!_vlc) {
        _vlc = ({
            FileModel *model = self.datasource[self.idx_isOn != -1 ? self.idx_isOn : 0];
            NSString *sql    = [NSString stringWithFormat:@"baseName like '%%%@%%'", model.baseName];
            model            = [FileModel xt_findFirstWhere:sql];
            NSURL *url       = [NSURL fileURLWithPath:[model fullPathWithBasePath:[self baseFullPath]]];

            XTVLC *object = [XTVLC new];
            [object showMeInView:self.movingContainer url:url hasCloseButton:NO forceHorizon:NO forbiddenGesture:YES];
            [self.view bringSubviewToFront:self.table];

            WEAK_SELF
            object.willDismissAndCatchThumbnail = ^(VLCMediaPlayer *_Nonnull player, UIImage *_Nullable thumbnail) {
                weakSelf.idx_isOn = -1;
                [weakSelf.table reloadData];
            };

            object;
        });
    }
    return _vlc;
}

- (UIView *)movingContainer {
    if (!_movingContainer) {
        _movingContainer = ({
            UIView *object         = [[UIView alloc] init];
            object.backgroundColor = nil;
            [self.view addSubview:object];
            object;
        });
    }
    return _movingContainer;
}


#pragma mark - PlayingCtrllerDelegate <NSObject>
- (void)refreshModel:(id)model {
    FileModel *fModel       = model;
    NSMutableArray *tmplist = [self.datasource mutableCopy];
    [tmplist replaceObjectAtIndex:self.idx_isOn
                       withObject:fModel];
    self.datasource = tmplist;
    [self.table reloadData];
}


@end
