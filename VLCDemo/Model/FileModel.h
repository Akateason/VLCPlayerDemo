//
//  FileModel.h
//  MRVLCPlayer
//
//  Created by teason23 on 2017/5/22.
//  Copyright © 2017年 Alloc. All rights reserved.
//
#import "XTDBModel.h"


typedef enum : int {
    typeOfFileModel_unKnow = 0 ,
    typeOfFileModel_file ,
    typeOfFileModel_folder ,
} TypeOfFileModel ;


@interface FileModel : XTDBModel

@property (nonatomic,copy) NSString             *displayPath     ; // Unique // 处理单引号
@property (nonatomic,copy) NSString             *playDisplayPath ; //还原displayPath单引号. 不参与建表

@property (nonatomic)      int                  fType           ;
@property (nonatomic,copy) NSString             *coverPath      ;
@property (nonatomic,copy) NSString             *allTime        ;
@property (nonatomic,copy) NSString             *lastTime       ;

- (instancetype)initWithDisplayPath:(NSString *)display ;

- (NSString *)fullPathWithBasePath:(NSString *)basePath ;

@end
