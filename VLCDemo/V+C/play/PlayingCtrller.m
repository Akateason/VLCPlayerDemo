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
@property (strong, nonatomic) XTVLC *playerView ;
@property (nonatomic,strong) FileModel *model ;
@end

@implementation PlayingCtrller

//- (void)dealloc
//{
//    NSLog(@"dealloc PlayingCtrller") ;
//}

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        self.model = model ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    appdelegate.orientationsOnlyLandScape = YES ;
    appdelegate.orientationsOnlyRotate = NO ;
    
    [self setupPlayer] ;
}

- (void)setupPlayer
{
    self.playerView = [[XTVLC alloc] init] ;
    NSURL *url = [NSURL fileURLWithPath:[self.model fullPathWithBasePath:[self baseFullPath]]] ;
    [self.playerView showMeInView:self.view url:url hasCloseButton:YES forceHorizon:YES] ;
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(APP_WIDTH) ;
        make.height.mas_equalTo(APP_WIDTH / 16 * 9) ;
        make.top.equalTo(self.view) ;
    }] ;
    
    @weakify(self)
    self.playerView.willDismissAndCatchThumbnail = ^(VLCMediaPlayer * _Nonnull player, UIImage * _Nullable thumbnail) {
        @strongify(self)
        self.model.allTime = player.media.length.stringValue ;
        self.model.lastTime = player.time.stringValue ;
        NSString *suffix = [[self.model.displayPath componentsSeparatedByString:@"."] firstObject] ;
        suffix = [[suffix componentsSeparatedByString:@"/"] lastObject] ;
        NSString *coverPath = [NSString stringWithFormat:@"/cover/cover_%@.png",suffix] ;
        NSString *path = [self.directPrefixPath stringByAppendingString:coverPath] ;
        NSData *data = UIImagePNGRepresentation(thumbnail) ;
        [data writeToFile:path atomically:NO] ;
        
        self.model.coverPath = coverPath ;
        [self.model update] ;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES] ;
            [self.delegate refreshModel:self.model] ;
        }) ;
    } ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO] ;
    [self.playerView forceChangeOrientation:UIInterfaceOrientationPortrait] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES ;
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
