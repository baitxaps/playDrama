//
//  CapturePlayViewController.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/6.
//  Copyright (c) 2015年 times. All rights reserved.
//

typedef void (^DoneBlock)(void);

#import <UIKit/UIKit.h>

@interface CapturePlayViewController : PBasicViewController

@property (nonatomic,  copy)DoneBlock backBlock;
@property (nonatomic,strong)NSString  *filePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVideoFileURL:(NSURL *)videoFileURL;


@end
