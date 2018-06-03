//
//  FilesCell.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/5/22.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "FilesCell.h"
#import "FileModel.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface FilesCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *label; // contents
@property (weak, nonatomic) IBOutlet UILabel *allTime;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;
@end

@implementation FilesCell

+ (CGFloat)cellHeight
{
    return 100. ;
}

- (NSString *)documentBasePath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] ;
}

- (void)configure:(id)obj
{
    if (!obj) return ;
    
    FileModel *model = obj ;
    self.label.text = model.playDisplayPath ;
    
    self.imgView.image = (!model.coverPath || !model.coverPath.length) ? nil : [UIImage imageWithContentsOfFile:[[self documentBasePath] stringByAppendingString:model.coverPath]] ;
    self.imgView.backgroundColor = (!model.coverPath || !model.coverPath.length) ? [UIColor blackColor] : [UIColor whiteColor] ;
    self.allTime.text = (!model.allTime || !model.allTime.length) ? @"" : model.allTime ;
    self.lastTime.text = (!model.lastTime || !model.lastTime.length) ? @"" : [@"上次播放到" stringByAppendingString:model.lastTime] ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(0, [[self class] cellHeight] - 0.5, CGRectGetWidth([UIScreen mainScreen].bounds), 0.5)] ;
    baseline.backgroundColor = [UIColor lightGrayColor] ;
    [self addSubview:baseline] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
