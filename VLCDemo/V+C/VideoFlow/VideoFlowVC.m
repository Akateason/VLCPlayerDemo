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


@interface VideoFlowVC () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic  ) IBOutlet RootTableView   *table ;
@property (copy, nonatomic  ) NSArray *datasource       ;

@property (strong, nonatomic) XTVLC    *vlc             ;
@property (strong, nonatomic) UIView   *movingContainer ;
@property (nonatomic        ) int      idx_isOn         ;
@end

@implementation VideoFlowVC

- (void)prepareUI {
    [super prepareUI] ;
    
    self.idx_isOn = -1 ;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    _table.hideAllRefreshers = YES ;
    _table.dataSource = self ;
    _table.delegate = self ;
    _table.backgroundColor = nil ;
    [VideoFlowCell registerNibFromTable:_table] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoFlowCell *cell = [VideoFlowCell fetchFromTable:tableView] ;
    [cell configure:self.datasource[indexPath.row] indexPath:indexPath] ;
    [cell hiddenAll:indexPath.row == self.idx_isOn] ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoFlowCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row ;
    if (row == self.idx_isOn) return ;
    
    self.idx_isOn = row ;
    
    if (![self.vlc superview]) {
        [self.view addSubview:self.vlc] ;
        [self.view bringSubviewToFront:self.table] ;
    }
    [self changeRect:indexPath] ;
    [self playWithIndexPath:indexPath] ;
    [self.table reloadData] ;
}

- (void)scrollViewDidScroll:(RootTableView *)table {
    if (self.idx_isOn == -1) return ;
    
    NSArray *visibleIndexes = [table indexPathsForVisibleRows] ;
    __block BOOL containIsPlaying = false ;
    [visibleIndexes enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.row == self.idx_isOn) {
            containIsPlaying = true ;
        }
    }] ;
    

    NSIndexPath *current = [NSIndexPath indexPathForRow:self.idx_isOn inSection:0] ;
    if ([self.vlc superview]) {
        [self changeRect:current] ;
    }
    
    if (!containIsPlaying) {
        [self stopWithIndexPath:current] ;
        self.idx_isOn = -1 ;
    }
}

- (void)changeRect:(NSIndexPath *)indexPath {
    VideoFlowCell *cell = [self.table cellForRowAtIndexPath:indexPath] ;
    CGRect rect = [self.table convertRect:cell.frame toView:self.view.window] ;
    self.movingContainer.frame = rect ;
    [self.vlc mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.movingContainer) ;
    }] ;
}

- (void)playWithIndexPath:(NSIndexPath *)indexPath {
    FileModel *model = self.datasource[indexPath.row] ;
    NSString *sql = [NSString stringWithFormat:@"baseName like '%%%@%%'",model.baseName] ;
    model = [FileModel findFirstWhere:sql] ;
    NSURL *url = [NSURL fileURLWithPath:[model fullPathWithBasePath:[self baseFullPath]]] ;
    [self.vlc changeMediaURL:url] ;
    [self.vlc play] ;
}

- (void)stopWithIndexPath:(NSIndexPath *)indexPath {
    [self.vlc stop] ;
    [self.vlc removeFromSuperview] ;
}

#pragma mark - props

- (NSArray *)datasource {
    if(!_datasource){
        _datasource = ({
            NSArray * object = [[FileModel selectAll] xt_orderby:@"updateTime" descOrAsc:YES] ;
            object;
       });
    }
    return _datasource;
}

- (XTVLC *)vlc{
    if(!_vlc){
        _vlc = ({
            FileModel *model = self.datasource[self.idx_isOn != -1 ? self.idx_isOn : 0 ] ;
            NSString *sql = [NSString stringWithFormat:@"baseName like '%%%@%%'",model.baseName] ;
            model = [FileModel findFirstWhere:sql] ;
            NSURL *url = [NSURL fileURLWithPath:[model fullPathWithBasePath:[self baseFullPath]]] ;
            
            XTVLC * object = [XTVLC new] ;
            [object showMeInView:self.movingContainer url:url hasCloseButton:NO forceHorizon:NO forbiddenGesture:YES] ;
            [self.view bringSubviewToFront:self.table] ;
            object;
       });
    }
    return _vlc;
}

- (UIView *)movingContainer{
    if(!_movingContainer){
        _movingContainer = ({
            UIView * object = [[UIView alloc] init] ;
            object.backgroundColor = nil ;
            [self.view addSubview:object] ;
            object;
       });
    }
    return _movingContainer;
}

@end
