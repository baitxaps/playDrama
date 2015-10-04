//
//  PCaptureViewController.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/31.
//  Copyright (c) 2015年 times. All rights reserved.
//
#define DurationTime        10
#import "PCaptureViewController.h"
#import "PBJVision.h"
#import "PBJVisionUtilities.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PProgressView.h"
#import "CapturePlayViewController.h"

@interface PCaptureViewController () <UIGestureRecognizerDelegate,PBJVisionDelegate>
{
    //AVCaptureVideoPreviewLayer可以用来快速呈现相机(摄像头)所收集到的原始数据
    AVCaptureVideoPreviewLayer                  *_previewLayer;
    UILongPressGestureRecognizer                *_longPressGestureRecognizer;
    BOOL                                        _recording;
    ALAssetsLibrary                             *_assetLibrary;
    CGFloat                                     seconds;
}
@property (weak, nonatomic) IBOutlet UIView     *topContainer;
@property (weak, nonatomic) IBOutlet UIView     *previewView;
@property (weak, nonatomic) IBOutlet UIView     *bottomContainer;
@property (weak, nonatomic) IBOutlet UIImageView*recordImageView;
@property (strong,nonatomic) UIView             *maskView;
@property (assign,nonatomic) BOOL               isFrontCameraSupported;
@property (assign,nonatomic) BOOL               isCameraSupported;
@property (assign,nonatomic) BOOL               isTorchSupported;
@property (strong,nonatomic) PProgressView      *progressView;

@end

@implementation PCaptureViewController

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self addGesture];
    [self isCamereSupported];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.recordImageView.userInteractionEnabled = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self hideMaskView];
    [self resetCapture];
    [[PBJVision sharedInstance] startPreview];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[PBJVision sharedInstance] stopPreview];
}


- (void)setupViews
{
    _assetLibrary                = [[ALAssetsLibrary alloc] init];
    _previewView.backgroundColor = [UIColor blackColor];
    _previewLayer                = [[PBJVision sharedInstance] previewLayer];

    CGRect preViewFrame          = _previewView.bounds;
    preViewFrame.size.width      = UIScreenWidth;
    _previewLayer.frame          = preViewFrame;
    _previewLayer.videoGravity   = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
    
    self.maskView               = [self getMaskView];
    [self.view addSubview:_maskView];
    
    self.progressView            = [[PProgressView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, BAR_H )];
    self.progressView.layerColor = BAR_BLUE_COLOR;
    [self.bottomContainer addSubview:self.progressView];
}


- (void)addGesture
{
    _longPressGestureRecognizer                      = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    _longPressGestureRecognizer.delegate = self;
    _longPressGestureRecognizer.minimumPressDuration = 0.05f;
    _longPressGestureRecognizer.allowableMovement    = 10.0f;
    [self.recordImageView  addGestureRecognizer:_longPressGestureRecognizer];
}

- (UIView *)getMaskView
{
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height + DELTA_Y)];
    maskView.backgroundColor = color(30, 30, 30, 1);
    
    return maskView;
}


#pragma mark - UIGestureRecognizer

- (void)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!_recording){
                [self startCapture];
            }
            else{
                [self resumeCapture];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self pauseCapture];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 退出
- (IBAction)closeActoin:(id)sender
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 切换
- (IBAction)switchAction:(id)sender
{
    PBJVision *vision = [PBJVision sharedInstance];
    vision.cameraDevice = vision.cameraDevice == PBJCameraDeviceBack ? PBJCameraDeviceFront : PBJCameraDeviceBack;
}


- (void)isCamereSupported
{
    AVCaptureDevice *frontCamera    = nil;
    AVCaptureDevice *backCamera     = nil;
    
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == AVCaptureDevicePositionFront) {
            frontCamera     = camera;
        } else {
            backCamera      = camera;
        }
    }
    
    if (!backCamera) {
        self.isCameraSupported      = NO;
        return;
    } else {
        self.isCameraSupported      = YES;
        
        if ([backCamera hasTorch]) {
            self.isTorchSupported   = YES;
        } else {
            self.isTorchSupported   = NO;
        }
    }
    
    if (!frontCamera) {
        self.isFrontCameraSupported = NO;
    } else {
        self.isFrontCameraSupported = YES;
    }
    
    [backCamera lockForConfiguration:nil];
    if ([backCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [backCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    [backCamera unlockForConfiguration];
}

#pragma mark - 闪光
- (IBAction)flashAction:(id)sender
{
    if (!_isTorchSupported) {
        return;
    }
    
    AVCaptureTorchMode torchMode;
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if  (btn.selected ) {
        torchMode = AVCaptureTorchModeOn;
    } else {
        torchMode = AVCaptureTorchModeOff;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        [device setTorchMode:torchMode];
        [device unlockForConfiguration];
    });
}

- (void)hideMaskView
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame        = self.maskView.frame;
        frame.origin.y      = self.maskView.frame.size.height;
        self.maskView.frame = frame;
    }];
}

#pragma mark - 保存
- (IBAction)saveAction:(id)sender
{
    if (seconds<2.0) {
        [self.view makeToast:@"至少要录2秒" duration:1 position:@"center" tag:11111];
        return;
    }
    _longPressGestureRecognizer.enabled = YES;
    [self endCapture];
}


- (void)resetCapture
{
    _longPressGestureRecognizer.enabled = YES;
    PBJVision *vision       = [PBJVision sharedInstance];
    vision.delegate         = self;
    
    if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack]) {
        vision.cameraDevice = PBJCameraDeviceBack;
    } else {
        vision.cameraDevice = PBJCameraDeviceFront;
        
    }
    
    vision.cameraMode            = PBJCameraModeVideo;
    vision.cameraOrientation     = PBJCameraOrientationPortrait;
    vision.focusMode             = PBJFocusModeContinuousAutoFocus;
    vision.outputFormat          = PBJOutputFormatSquare;
    vision.videoRenderingEnabled = YES;
    vision.additionalCompressionProperties = @{AVVideoProfileLevelKey : AVVideoProfileLevelH264Baseline30}; //
}

#pragma mark - private start/stop helper methods

- (void)startCapture
{
    //限制锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [[PBJVision sharedInstance] startVideoCapture];
}

- (void)pauseCapture
{
    [[PBJVision sharedInstance] pauseVideoCapture];
}

- (void)resumeCapture
{
    [[PBJVision sharedInstance] resumeVideoCapture];
}

- (void)endCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] endVideoCapture];
}

- (void)visionSessionDidStartPreview:(PBJVision *)vision
{
    self.progressView.progress                  = 0;
    self.recordImageView.userInteractionEnabled = YES;
}


// video capture

- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
    _recording = YES;
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    _recording = NO;
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        PDebugLog(@"recording session cancelled");
        return;
    } else if (error) {
        PDebugLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    
    NSString *videoPath = [videoDict  objectForKey:PBJVisionVideoPathKey];

    [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
        
        PDebugLog(@"assetURL  = %@",assetURL);
        PDebugLog(@"videoPath =%@",videoPath);
        
        UINavigationController *navCon = [[UINavigationController alloc] init];
        navCon.navigationBarHidden     = YES;
        CapturePlayViewController *playCon = [[CapturePlayViewController alloc] initWithNibName:@"CapturePlayViewController" bundle:nil withVideoFileURL:assetURL];
        playCon.filePath = videoPath;
        WS(weakSelf);
        playCon.backBlock = ^{
            [weakSelf closeActoin:nil];
        };
        [self.navigationController pushViewController:playCon animated:NO];

    }];
}

// progress
- (void)vision:(PBJVision *)vision didCaptureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    // PDebugLog(@"captured audio (%f) seconds", vision.capturedAudioSeconds);
}

- (void)vision:(PBJVision *)vision didCaptureAudioSample:(CMSampleBufferRef)sampleBuffer
{
    PDebugLog(@"captured video (%f) seconds", vision.capturedVideoSeconds);
    seconds = vision.capturedAudioSeconds;
    if (vision.capturedAudioSeconds >=DurationTime) {
        [self pauseCapture];
        self.recordImageView.userInteractionEnabled = NO;
        return;
    }
    
    self.progressView.progress = vision.capturedVideoSeconds /( DurationTime *1.0);
}

- (void)didReceiveMemoryWarnin
{
    [super didReceiveMemoryWarning];
    
}

@end
