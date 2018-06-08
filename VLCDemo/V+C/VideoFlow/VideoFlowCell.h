//
//  VideoFlowCell.h
//  VLCDemo
//
//  Created by teason23 on 2018/6/5.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootTableCell.h"

@interface VideoFlowCell : RootTableCell
@property (weak, nonatomic) IBOutlet UIButton *playBt;
@property (weak, nonatomic) IBOutlet UIImageView *imagePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *grayMask;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end
