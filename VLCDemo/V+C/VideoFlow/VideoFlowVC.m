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

@interface VideoFlowVC () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet RootTableView *table;
@property (copy, nonatomic) NSArray *datasource ;

@property (strong, nonatomic) XTVLC *vlc ;
@property (strong, nonatomic) UIView *movingContainer ;

@end

@implementation VideoFlowVC

- (void)prepareUI {
    [super prepareUI] ;
    
    _table.hideAllRefreshers = YES ;
    _table.dataSource = self ;
    _table.delegate = self ;
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
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoFlowCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row ;
    FileModel *model = self.datasource[row] ;
//    NSString *sql = [NSString stringWithFormat:@"baseName like '%%%@%%'",model.baseName] ;
//    model = [FileModel findFirstWhere:sql] ;
//    
//    VideoFlowCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
//    CGRect rect = [self.view convertRect:cell.frame toView:self.view] ;
//    self.movingContainer.frame = rect ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSArray *)datasource{
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
            XTVLC * object = [XTVLC new] ;
            [object showMeInView:self.movingContainer url:nil hasCloseButton:NO forceHorizon:NO] ;
            object;
       });
    }
    return _vlc;
}

- (UIView *)movingContainer{
    if(!_movingContainer){
        _movingContainer = ({
            UIView * object = [[UIView alloc] init];
            object.backgroundColor = [UIColor redColor] ;
            [self.view addSubview:object] ;
            object;
       });
    }
    return _movingContainer;
}


@end
