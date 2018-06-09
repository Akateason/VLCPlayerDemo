//
//  VideoFlowCell.m
//  VLCDemo
//
//  Created by teason23 on 2018/6/5.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "VideoFlowCell.h"
#import <XTlib.h>
#import "FileModel.h"

@implementation VideoFlowCell

- (void)configure:(FileModel *)file indexPath:(NSIndexPath *)indexPath {
    [super configure:file indexPath:indexPath] ;
    
    self.lbTitle.text = file.displayName ;
    self.imagePlaceholder.image = file.imgCover ?: [UIImage imageNamed:@"placeholder"];
}

+ (CGFloat)cellHeight {
    return APP_WIDTH / 16. * 9. ;
}

- (NSString *)documentBasePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] ;
}

- (void)awakeFromNib {
    [super awakeFromNib] ;
    // Initialization code
    [_playBt setImage:[[UIImage imageNamed:@"btPlay"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
    _imagePlaceholder.layer.masksToBounds = YES ;
    _imagePlaceholder.backgroundColor = [UIColor blackColor] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
