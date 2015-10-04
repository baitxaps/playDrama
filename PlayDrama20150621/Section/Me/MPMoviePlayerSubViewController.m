//
//  MPMoviePlayerSubViewController.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/7.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "MPMoviePlayerSubViewController.h"

@implementation MPMoviePlayerSubViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.moviePlayer prepareToPlay];
    //self.moviePlayer.controlStyle = MPMovieControlStyleDefault;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(movieFinishedCallback:)
                                                name:MPMoviePlayerPlaybackDidFinishNotification
                                              object:self.moviePlayer];
}

-(void)movieFinishedCallback:(NSNotification*)notify
{
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    MPMoviePlayerSubViewController* theMovie = [notify object];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:theMovie];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


@end
