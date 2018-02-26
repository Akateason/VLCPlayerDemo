//
//  PlayingCtrller.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/6/21.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "PlayingCtrller.h"
#import "MRVLCPlayer.h"
#import "Masonry.h"
#import "FileModel.h"
#import "XTFMDB.h"
#import "UIViewController+FileUrl.h"

@interface PlayingCtrller ()
{
    MRVLCPlayer *player ;
}
@property (nonatomic,strong) FileModel *model ;
@property (nonatomic,strong) UITextView *textView ;
@property (nonatomic,strong) UIButton *backBt ;
@end

@implementation PlayingCtrller

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        self.model = model ;
    }
    return self;
}

- (void)loadView
{
    [super loadView] ;
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    self.backBt = ({
        UIButton *view = [UIButton new] ;
        view.backgroundColor = [UIColor lightGrayColor] ;
        [view setTitle:@"back"
              forState:0] ;
        [view setTitleColor:[UIColor redColor]
                   forState:0] ;
        [self.view addSubview:view] ;
        [view addTarget:self
                 action:@selector(backAction)
       forControlEvents:UIControlEventTouchUpInside] ;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 30)) ;
            make.right.bottom.equalTo(self.view).offset(-10) ;
        }] ;
        view ;
    }) ;
    
    self.textView = ({
        UITextView *view = [UITextView new] ;
        view.text = @"在使用UIKit的过程中，性能优化是永恒的话题。很多人都看过分析优化滑动性能的文章，但其中不少文章只介绍了优化方法却对背后的原理避而不谈，或者是晦涩难懂而且读者缺乏实践体验的机会。不妨思考一下下面的问题自己是否有一个清晰的认识：在使用UIKit的过程中，性能优化是永恒的话题。很多人都看过分析优化滑动性能的文章，但其中不少文章只介绍了优化方法却对背后的原理避而不谈，或者是晦涩难懂而且读者缺乏实践体验的机会。不妨思考一下下面的问题自己是否有一个清晰的认识：在使用UIKit的过程中，性能优化是永恒的话题。很多人都看过分析优化滑动性能的文章，但其中不少文章只介绍了优化方法却对背后的原理避而不谈，或者是晦涩难懂而且读者缺乏实践体验的机会。不妨思考一下下面的问题自己是否有一个清晰的认识：在使用UIKit的过程中，性能优化是永恒的话题。很多人都看过分析优化滑动性能的文章，但其中不少文章只介绍了优化方法却对背后的原理避而不谈，或者是晦涩难懂而且读者缺乏实践体验的机会。不妨思考一下下面的问题自己是否有一个清晰的认识：在使用UIKit的过程中，性能优化是永恒的话题。很多人都看过分析优化滑动性能的文章，但其中不少文章只介绍了优化方法却对背后的原理避而不谈，或者是晦涩难懂而且读者缺乏实践体验的机会。不妨思考一下下面的问题自己是否有一个清晰的认识：在使用UIKit的过程中，性能优化是永恒的话题。很多人都看过分析优化滑动性能的文章，但其中不少文章只介绍了优化方法却对背后的原理避而不谈，或者是晦涩难懂而且读者缺乏实践体验的机会。不妨思考一下下面的问题自己是否有一个清晰的认识：在使用UIKit的过程中，性能优化是永恒的话题。很多人都看过分析优化滑动性能的文章，但其中不少文章只介绍了优化方法却对背后的原理避而不谈，或者是晦涩难懂而且读者缺乏实践体验的机会。不妨思考一下下面的问题自己是否有一个清晰的认识：在使用UIKit的过程中，性能优化是永恒的话题。很多人都看过分析优化滑动性能的文章，但其中不少文章只介绍了优化方法却对背后的原理避而不谈，或者是晦涩难懂而且读者缺乏实践体验的机会。不妨思考一下下面的问题自己是否有一个清晰的认识：" ;
        view.textColor = [UIColor blackColor] ;
        [self.view addSubview:view] ;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(self.view.bounds.size.width / 16 * 9 + 10) ;
            make.left.equalTo(self.view).offset(10) ;
            make.right.equalTo(self.view).offset(-10) ;
            make.bottom.equalTo(self.backBt.mas_top).offset(-10) ;
        }] ;
        view ;
    }) ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    [self setupPlayer] ;
}

- (void)setupPlayer
{
    // initial player
    player = [[MRVLCPlayer alloc] init] ;
    player.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9) ;
    player.center = self.view.center ;
    
    // documents
    NSURL *url = [NSURL fileURLWithPath:[self.model fullPathWithBasePath:[self baseFullPath]]] ;
    player.mediaURL = url ;
    [self.view addSubview:player] ;
    [player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top) ;
        make.left.equalTo(self.view.mas_left) ;
        make.right.equalTo(self.view.mas_right) ;
        make.width.equalTo(self.view.mas_width) ;
        make.height.mas_equalTo(self.view.bounds.size.width / 16 * 9) ;
    }] ;
    player.alpha = 0.0 ;
    [UIView animateWithDuration:0.6
                     animations:^{
                         player.alpha = 1.0 ;
                     } completion:^(BOOL finished) {
                         [player play] ;
                     }];

    
    // online
//  player.mediaURL = [NSURL URLWithString:@"http://lilanisoft.com/live/images/Ziyarat_Aashura_by_Samavati_Arabic_sub_English.mp4"] ;
    
//    [player showInView:self.view] ;

    
    __weak PlayingCtrller *weakSelf = self ;
    player.dismissComplete = ^(VLCMediaPlayer * _Nonnull vlcPlayer) {
        
        weakSelf.model.allTime = vlcPlayer.media.length.stringValue ;
        weakSelf.model.lastTime = vlcPlayer.time.stringValue ;
        NSString *suffix = [[weakSelf.model.displayPath componentsSeparatedByString:@"."] firstObject] ;
        suffix = [[suffix componentsSeparatedByString:@"/"] lastObject] ;
        NSString *coverPath = [NSString stringWithFormat:@"/cover/cover_%@.png",suffix] ;
        NSString *path = [weakSelf.directPrefixPath stringByAppendingString:coverPath] ;
        [vlcPlayer saveVideoSnapshotAt:path withWidth:120 andHeight:120/16*9] ;
        weakSelf.model.coverPath = coverPath ;
        [weakSelf.model update] ;
        //
        [weakSelf.delegate refreshModel:weakSelf.model] ;
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
    [player dismiss] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES ;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES] ;
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
