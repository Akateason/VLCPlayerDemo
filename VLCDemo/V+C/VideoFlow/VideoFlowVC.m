//
//  VideoFlowVC.m
//  VLCDemo
//
//  Created by teason23 on 2018/6/5.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "VideoFlowVC.h"
#import "VideoFlowCell.h"
#import "XTColor+MyColors.h"

@interface VideoFlowVC () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet RootTableView *table;

@end

@implementation VideoFlowVC

- (void)prepareUI {
    [super prepareUI] ;
    
    _table.backgroundColor = [XTColor lakerYellow] ;
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
    return 13 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoFlowCell *cell = [VideoFlowCell fetchFromTable:tableView] ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoFlowCell cellHeight] ;
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
