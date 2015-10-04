//
//  PDramaDataSave.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PDramaDataSave.h"

@implementation PDramaDataSave

+(PDramaDataSave *) sharedInstance
{
    static PDramaDataSave *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}


- (NSString *)avatarImagePathForUser:(NSString *)user_id
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = USER_AVATAR_DIR;
    
    if (![fm fileExistsAtPath:filePath isDirectory:NULL]) {
        [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.png", user_id];
    return PATH_IN_USER_AVATAR_DIR(fileName);
}


@end
