//
//  FilesViewController.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/5/22.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "FilesViewController.h"
#import "UINavigationController+RotateUtil.h"
#import "AppDelegate.h"

@interface FilesViewController ()
@end

@implementation FilesViewController

- (void)viewDidLoad
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.orientationsOnlyLandScape = NO ;
    appdelegate.orientationsOnlyRotate = YES ;
    
    self.bPrepare = YES ;
    [super viewDidLoad] ;    
    self.title = @"xtcPlayer" ;
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
