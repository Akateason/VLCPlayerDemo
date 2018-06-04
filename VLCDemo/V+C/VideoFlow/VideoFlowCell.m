//
//  VideoFlowCell.m
//  VLCDemo
//
//  Created by teason23 on 2018/6/5.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "VideoFlowCell.h"
#import <XTlib.h>

@implementation VideoFlowCell

+ (CGFloat)cellHeight {
    return APP_WIDTH / 16. * 9. ;
}


- (void)awakeFromNib {
    [super awakeFromNib] ;
    // Initialization code
    [_playBt setImage:[[UIImage imageNamed:@"btPlay"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
