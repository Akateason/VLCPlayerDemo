//
//  UIViewController+FileUrl.h
//  MRVLCPlayer
//
//  Created by teason23 on 2017/6/21.
//  Copyright © 2017年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FileUrl)

@property (nonatomic,copy) NSString *baseRelativePath ;
- (NSString *)directPrefixPath ;
- (NSString *)baseFullPath ;

@end
