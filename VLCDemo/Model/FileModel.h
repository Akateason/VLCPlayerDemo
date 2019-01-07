//
//  FileModel.h
//  MRVLCPlayer
//
//  Created by teason23 on 2017/5/22.
//  Copyright © 2017年 Alloc. All rights reserved.
//
#import <Foundation/Foundation.h>
@class UIImage;


typedef enum : int {
    typeOfFileModel_unKnow = 0,
    typeOfFileModel_file,
    typeOfFileModel_folder,
} TypeOfFileModel;


@interface FileModel : NSObject

@property (copy, nonatomic) NSString *baseName; // name encode base64
@property (strong, nonatomic) UIImage *imgCover;
@property (nonatomic) int fType;
@property (nonatomic, copy) NSString *allTime;
@property (nonatomic, copy) NSString *lastTime;
@property (nonatomic) int msPlayTime; // 毫秒.已经播放的时间

- (instancetype)initWithDisplayPath:(NSString *)display;

// util
- (NSString *)displayName;
- (NSString *)playName;
- (NSString *)fullPathWithBasePath:(NSString *)basePath;

@end
