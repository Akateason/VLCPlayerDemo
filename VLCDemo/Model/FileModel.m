//
//  FileModel.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/5/22.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel
@synthesize displayPath = _displayPath ;

+ (NSDictionary *)modelPropertiesSqliteKeywords
{
    return @{
             @"displayPath" : @"UNIQUE" ,
             } ;
}

+ (NSArray *)ignoreProperties
{
    return @[
             @"basePath" ,
             @"fullPath" ,
             @"playDisplayPath" ,
             ] ;
}

- (instancetype)initWithDisplayPath:(NSString *)display
{
    self = [super init] ;
    if (self)
    {
        self.displayPath = display ;
        if ([self isFile]) {
            self.fType = typeOfFileModel_file ;
        }
        else if ([self isFolder]) {
            self.fType = typeOfFileModel_folder ;
        }
        else
            self.fType = typeOfFileModel_unKnow ;
    }
    return self ;
}

static NSString *const kmarks = @"&quotation&" ;
- (void)setDisplayPath:(NSString *)displayPath
{
    _displayPath = [displayPath stringByReplacingOccurrencesOfString:@"'" withString:kmarks] ;
}

- (void)setCoverPath:(NSString *)coverPath
{
    _coverPath = [coverPath stringByReplacingOccurrencesOfString:@"'" withString:kmarks] ;
}

- (NSString *)playDisplayPath
{
    return [self.displayPath stringByReplacingOccurrencesOfString:kmarks withString:@"'"] ;
}

- (NSString *)fullPathWithBasePath:(NSString *)basePath
{
    return  [NSString stringWithFormat:@"%@/%@",basePath,self.playDisplayPath] ;
}

- (BOOL)isFile
{
    return ([self.displayPath containsString:@"."]) ;
}

- (BOOL)isFolder
{
    return (![self.displayPath containsString:@"/"] && ![self.displayPath containsString:@"."]) ;
}


@end
