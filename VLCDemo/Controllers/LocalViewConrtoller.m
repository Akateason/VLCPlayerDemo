//
//  LocalViewConrtoller.m
//  MRVLCPlayer
//
//  Created by Maru on 16/3/20.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "LocalViewConrtoller.h"
#import "MRVLCPlayer.h"
#import <Masonry.h>
#import <XTlib.h>

@implementation LocalViewConrtoller

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
}

- (IBAction)localPlay:(id)sender {
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    NSString *documentPath = [filePath firstObject] ;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/test.mp4",documentPath]] ;
    //  [NSURL fileURLWithPath:@"/Users/Maru/Documents/Media/Movie/1.mkv"];
    
    
    MRVLCPlayer *player = [[MRVLCPlayer alloc] init];
    player.mediaURL = url ;
    [player showInView:self.view.window];
    [player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(APP_WIDTH) ;
        make.height.mas_equalTo(APP_WIDTH / 16 * 9) ;
        make.top.equalTo(self.view) ;
    }] ;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
