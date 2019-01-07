//
//  FolderCell.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/5/22.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "FolderCell.h"
#import "XTColor+MyColors.h"


@implementation FolderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.textColor = [XTColor text1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
