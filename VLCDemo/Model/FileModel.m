//
//  FileModel.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/5/22.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "FileModel.h"
#import <XTlib.h>


@implementation FileModel

+ (NSDictionary *)modelPropertiesSqliteKeywords {
    return @{
        @"baseName" : @"UNIQUE",
    };
}

//+ (NSArray *)ignoreProperties
//{
//    return @[
//             ] ;
//}

- (instancetype)initWithDisplayPath:(NSString *)display {
    self = [super init];
    if (self) {
        if ([self isFile:display]) {
            self.fType = typeOfFileModel_file;
        }
        else if ([self isFolder:display]) {
            self.fType = typeOfFileModel_folder;
        }
        else
            self.fType = typeOfFileModel_unKnow;

        self.baseName = [display base64EncodedString];
    }
    return self;
}

// util
- (NSString *)displayName {
    NSString *origin = [self.baseName base64DecodedString];
    if ([origin containsString:@"/"]) {
        origin = [[origin componentsSeparatedByString:@"/"] lastObject];
    }
    return origin;
}

- (NSString *)playName {
    return [self.baseName base64DecodedString];
}

- (NSString *)fullPathWithBasePath:(NSString *)basePath {
    return [NSString stringWithFormat:@"%@/%@", basePath, self.playName];
}

// private
- (BOOL)isFile:(NSString *)displaystr {
    return ([displaystr containsString:@"."]);
}

- (BOOL)isFolder:(NSString *)displaystr {
    return (![displaystr containsString:@"/"] && ![displaystr containsString:@"."]);
}

@end
