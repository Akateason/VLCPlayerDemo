//
//  UIViewController+FileUrl.m
//  MRVLCPlayer
//
//  Created by teason23 on 2017/6/21.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import "UIViewController+FileUrl.h"
#import <objc/runtime.h>

@implementation UIViewController (FileUrl)

static char keyBaseRelativePath;

- (void)setBaseRelativePath:(NSString *)baseRelativePath
{
    objc_setAssociatedObject(self, &keyBaseRelativePath, baseRelativePath, OBJC_ASSOCIATION_COPY_NONATOMIC) ;
}

- (NSString *)baseRelativePath
{
    id anObject = objc_getAssociatedObject(self, &keyBaseRelativePath) ;
    if (!anObject) {
        anObject = @"" ;
    }
    return anObject ;
}

- (NSString *)directPrefixPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] ;
}

- (NSString *)baseFullPath
{
    return [[[self directPrefixPath] stringByAppendingString:@"/"] stringByAppendingString:self.baseRelativePath] ;
}



@end
