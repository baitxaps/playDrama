//
//  CapturePlayViewController.m
//  PlayDrama
//  http://jiapumin.iteye.com/blog/2109378
//  Created by hairong.chen on 15/8/6.
//  Copyright (c) 2015年 times. All rights reserved.
//


static NSString *const URL      = @"http://up.qiniu.com";
static NSString *const g_token  = @"v2CXWOeGzjrqS9K1MN1lNSluZJO3sJkP_g5bc_wB:1D833J_kbEv7PiMy0Ho5Nr43K9s=:eyJzY29wZSI6InRlc3QiLCJkZWFkbGluZSI6MTQ0MTEwNzU0MX0=";
#define kTextViewTag  0x11010

#import "CapturePlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Category.h"
//#import "CatchImage.h"

@interface CapturePlayViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UIButton              *backButton;
@property (strong, nonatomic) UIButton              *submitButton;
@property (strong, nonatomic) NSURL                 *videoFileURL;
@property (strong, nonatomic) AVPlayer              *player;
@property (strong, nonatomic) AVPlayerLayer         *playerLayer;
@property (strong, nonatomic) UIButton              *playButton;
@property (strong, nonatomic) AVPlayerItem          *playerItem;
@property (weak  , nonatomic) IBOutlet UITextView   *destTextView;

@end

@implementation CapturePlayViewController


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
     withVideoFileURL:(NSURL *)videoFileURL
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.videoFileURL = videoFileURL;
    }
    return self;
}

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavbar];
    [self setupViews];
}


- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(avPlayerItemDidPlayToEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [self.destTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
}


- (void)addNavbar
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_backButton setImage:[UIImage imageNamed:@"vedio_nav_btn_back_nor.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"vedio_nav_btn_back_pre.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(backActionButton)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth - 60, 0, 60, 44)];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitAction:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
}

#pragma mark -  上传视频

- (void)submitAction:(UIButton *)sender
{
    if ([self valid]) {
        return;
    }
    
    //upload
    [self.view endEditing:YES];
    long long fileSize   = [self fileSizeAtPath:self.filePath];
    NSDictionary *params = @{@"token":self.destTextView.text,//g_token,//
                             @"file" :self.self.videoFileURL,
                             @"fileSize":@(fileSize)
                             };
    
    [self showHudWithTitle:@"正在上传中..."];
    NSData *videoData    = [NSData dataWithContentsOfFile:self.filePath];
    
    [Networking UploadDataWithUrlString:URL
                             parameters:params
                        timeoutInterval:[NSNumber numberWithDouble:30.0f]
                            requestType:HTTPRequestType
                           responseType:JSONResponseType
              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                  
                  [formData appendPartWithFileData:videoData
                                              name:@"file"
                                          fileName:@"video.mp4"
                                          mimeType:@"video/mp4"];
                  
              } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  PDebugLog(@"%@",responseObject);
                  [_hud hide:YES];
                  //[self backActionButton];
                  
                  
                 NSString *tips =  [NSString stringWithFormat:@"%@,%@",operation,responseObject];
                  
                  self.destTextView.text = tips;
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self.view makeToast:error.localizedDescription duration:1.0 position:@"center" tag:10010];
                  [_hud hide:YES];
                  NSString *tips =  [NSString stringWithFormat:@"%@,errorcode = %ld,%@",operation,(long)error.code,error.description ];
                  self.destTextView.text = tips;
                  
              }];
}


- (BOOL)valid
{
    NSString *destString = [self.destTextView.text stringByTrimmingWhitespace:self.destTextView.text];
    if ([destString length]==0) {
        [self.view makeToast:@"对小伙伴们说点什么吧！" duration:1.0 position:@"center" tag:10010];
        return YES;
    }
    return NO;
}

- (void)setupViews
{
    [self initPlayLayer];
    self.view.backgroundColor   = RGBAColor(16, 16, 16, 1.0f);
    self.playButton             = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    [_playButton setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(pressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    //imageView.image = [CatchImage thumbnailImageForVideo:self.videoFileURL atTime:second];
    
    UILabel *placeholder        = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 280.0, 30)];
    placeholder.textColor       = RGBAColor(206, 206, 212, 1);
    placeholder.tag             = kTextViewTag;
    placeholder.text            = NSLocalizedString(@"你想说点什么", nil);
    placeholder.font            = [UIFont systemFontOfSize:14.0];
    placeholder.textAlignment   = NSTextAlignmentLeft;
    [self.destTextView addSubview:placeholder];
}


- (void)initPlayLayer
{
    if (!_videoFileURL) {
        return;
    }
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:_videoFileURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(DEVICE_SIZE.width - 100, 44, 100,100/*DEVICE_SIZE.width, DEVICE_SIZE.width*/);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:_playerLayer];
    
}

- (void)pressPlayButton:(UIButton *)button
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

#pragma mark - 返回
- (void)backActionButton
{
    if (self.backBlock) {
        self.backBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *placeholderL   = (UILabel *)[textView viewWithTag:kTextViewTag];
    
    placeholderL.hidden     = [textView.text length]>0;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - PlayEndNotification
- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _playButton.alpha = 1.0f;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

