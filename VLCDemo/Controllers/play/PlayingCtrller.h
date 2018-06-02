//
//  PlayingCtrller.h
//  MRVLCPlayer
//
//  Created by teason23 on 2017/6/21.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileModel ;

@protocol PlayingCtrllerDelegate <NSObject>
- (void)refreshModel:(id)model ;
@end

@interface PlayingCtrller : UIViewController
@property (nonatomic,weak) id <PlayingCtrllerDelegate> delegate ;
- (instancetype)initWithModel:(id)model ;
@end
