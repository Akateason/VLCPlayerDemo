//
//  BaseCtrller.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/5/22.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "BaseCtrller.h"
#import "FileModel.h"
#import "FilesCell.h"
#import "FolderCell.h"
#import "NSDate+XTTick.h"
#import "XTVLC.h"
#import "PlayingCtrller.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import <XTlib.h>


@interface BaseCtrller () <UITableViewDelegate,UITableViewDataSource,PlayingCtrllerDelegate>
{
    int indexPlay ;
}
@property (nonatomic,strong) RootTableView *table ;
@property (nonatomic,strong) NSMutableArray *list ;
@end

@implementation BaseCtrller

//@protocol PlayingCtrllerDelegate <NSObject>
- (void)refreshModel:(id)model {
    FileModel *fModel = model ;
    [self.list replaceObjectAtIndex:indexPlay
                         withObject:fModel] ;
    [self.table reloadData] ;
}


- (void)viewDidLoad
{
    [super viewDidLoad] ;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
    
    // Do any additional setup after loading the view.
    NSLog(@"path : %@ \n",self.baseRelativePath) ;
    
    self.table = ({
        RootTableView *table = [[RootTableView alloc] init] ;
        [self.view addSubview:table] ;
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view) ;
        }] ;
        table.delegate = self ;
        table.dataSource = self ;
        table.hideAllRefreshers = YES ;
        table ;
    }) ;
    
    [self.table registerNib:[UINib nibWithNibName:@"FilesCell" bundle:nil]
     forCellReuseIdentifier:@"FilesCell"] ;
    [self.table registerNib:[UINib nibWithNibName:@"FolderCell" bundle:nil]
     forCellReuseIdentifier:@"FolderCell"] ;
    
    [self prepare] ;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.orientationsOnlyLandScape = NO ;
    appdelegate.orientationsOnlyRotate = YES ;

    [self forceChangeOrientation:UIInterfaceOrientationPortrait] ;
}

- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation {
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]] ;
        [invocation setSelector:selector] ;
        [invocation setTarget:[UIDevice currentDevice]] ;
        [invocation setArgument:&val atIndex:2] ;
        [invocation invoke] ;
    }
}

- (void)prepare
{
    self.list = [[NSMutableArray alloc] initWithCapacity:1] ;
    NSLog(@"----------") ;
    //（深度遍历，会递归枚举它的内容）
    NSFileManager *fm = [NSFileManager defaultManager] ;
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:[self baseFullPath]] ;
    NSString *pathTmp = @"" ;
    while ((pathTmp = [dirEnum nextObject]) != nil)
    {
        NSLog(@"%@",pathTmp) ;
        
        if ([pathTmp containsString:@".DS_Store"]) continue ;
        else if ([pathTmp containsString:@".sqlite"]) continue ;
        else if ([pathTmp containsString:@"cover"]) continue ;
        else if ([self isPhotoType:pathTmp]) continue ;
        
        if (!self.bPrepare) {
            pathTmp = STR_FORMAT(@"%@/%@",self.title,pathTmp) ;
        }
        
        FileModel *model = [[FileModel alloc] initWithDisplayPath:pathTmp] ;
        NSString *sql = [NSString stringWithFormat:@"baseName like '%%%@%%'",model.baseName] ;
        
        if (self.bPrepare) {
            if (![FileModel xt_hasModelWhere:sql]) {
                // not exist
                NSURL *url = [NSURL fileURLWithPath:[model fullPathWithBasePath:[self baseFullPath]]] ;
                VLCMedia *media = [VLCMedia mediaWithURL:url] ;
                model.allTime = media.length.stringValue ;
                model.lastTime = nil ;
                [model xt_insert] ;
            }
            else {
                // has . so fetch newest .
                model = [FileModel xt_findFirstWhere:sql] ;
            }
            
            if ([pathTmp containsString:@"/"]) continue ; // folder not display . but insert
        }
        else {
            model = [FileModel xt_findFirstWhere:sql] ;
        }
        
        [self.list addObject:model] ; // will display
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileModel *model = self.list[indexPath.row] ;
    if (model.fType == typeOfFileModel_folder)
    {   // is folder
        FolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"] ;
        return cell ;
    }
    else if (model.fType == typeOfFileModel_file)
    {   // is file
        FilesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilesCell"] ;
        return cell ;
    }
    
    return [UITableViewCell new] ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileModel *model = self.list[indexPath.row] ;
    if (model.fType == typeOfFileModel_folder)
    {   // is folder
        ((FolderCell *)cell).label.text = model.displayName ;
    }
    else if (model.fType == typeOfFileModel_file)
    {   // is file
        FilesCell *fcell = (FilesCell *)cell ;
        [fcell configure:model] ;        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileModel *model = self.list[indexPath.row] ;
    if (model.fType == typeOfFileModel_folder)
    {
        return 44. ;
    }
    else if (model.fType == typeOfFileModel_file)
    {
        return [FilesCell cellHeight] ;
    }
    return 44 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block FileModel *model = self.list[indexPath.row] ;
    
    if (model.fType == typeOfFileModel_folder)
    {   // is folder
        BaseCtrller *secVC = [[BaseCtrller alloc] init] ;
        secVC.title = model.displayName ;
        secVC.baseRelativePath = model.displayName ;
        [self.navigationController pushViewController:secVC animated:YES] ;
    }
    else if (model.fType == typeOfFileModel_file)
    {   // is file
        @autoreleasepool
        {
            if ([self isPhotoType:model.displayName]) return ;
            indexPlay = (int)indexPath.row ;
            NSString *sql = [NSString stringWithFormat:@"baseName like '%%%@%%'",model.baseName] ;
            model = [FileModel xt_findFirstWhere:sql] ;
            PlayingCtrller *playVC = [[PlayingCtrller alloc] initWithModel:model] ;
            playVC.delegate = self ;
            [self.navigationController pushViewController:playVC animated:YES] ;
        }
    }
}

- (BOOL)isPhotoType:(NSString *)displayPath
{
    return (
            [displayPath containsString:@".jpg"]    |
            [displayPath containsString:@".jpeg"]   |
            [displayPath containsString:@".JPG"]    |
            [displayPath containsString:@".JPEG"]   |
            [displayPath containsString:@".png"]    |
            [displayPath containsString:@".PNG"]
    ) ;
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
