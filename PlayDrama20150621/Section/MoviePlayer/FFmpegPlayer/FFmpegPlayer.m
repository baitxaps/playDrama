//
//  PMoviePlayerView.m
//  PlayDrama
//
//  Created by RHC on 15/5/26.
//  Copyright (c) 2015年 times. All rights reserved.
//
#define LOCAL_MIN_BUFFERED_DURATION   0.2
#define LOCAL_MAX_BUFFERED_DURATION   0.4
#define NETWORK_MIN_BUFFERED_DURATION 2.0
#define NETWORK_MAX_BUFFERED_DURATION 4.0
#define kSYSVOLUME_NOTIFICATION        @"AVSystemController_SystemVolumeDidChangeNotification"

NSString * const KxMovieParameterMinBufferedDuration  = @"KxMovieParameterMinBufferedDuration";
NSString * const KxMovieParameterMaxBufferedDuration  = @"KxMovieParameterMaxBufferedDuration";
NSString * const KxMovieParameterDisableDeinterlacing = @"KxMovieParameterDisableDeinterlacing";

#import "FFmpegPlayer.h"
#import "PSelectorView.h"
#import "PSystemSettingScreenLock.h"
#import "KxMovieDecoder.h"
#import "KxAudioManager.h"
#import "KxMovieGLView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FFmpegPlayer()
{
    PSelectorView       *_selectorView;
    KxMovieDecoder      *_decoder;  //解码器
    dispatch_queue_t    _dispatchQueue;
    NSMutableArray      *_videoFrames;
    NSMutableArray      *_audioFrames;
    NSDictionary        *_parameters;
    NSData              *_currentAudioFrame;
    
    KxMovieGLView       *_glView;
    UIImageView         *_imageView;
    BOOL                _interrupted;//间断
    BOOL                _disableUpdateHUD;
    BOOL                _buffered;
    BOOL                _hiddenHUD;
    BOOL                _fullscreen;
    BOOL                _savedIdleTimer;
    
    CGFloat             _bufferedDuration;//缓冲时间
    CGFloat             _minBufferedDuration;
    CGFloat             _maxBufferedDuration;
    CGFloat             _moviePosition;
    
    NSTimeInterval      _debugStartTime;
    NSUInteger          _debugAudioStatus;
    NSUInteger          _currentAudioFramePos;//当前的音频帧名次/位置
    NSDate              *_debugAudioStatusTS;//调试音频状态TS
    
    NSTimeInterval      _tickCorrectionTime;//蜱校正时间
    NSTimeInterval      _tickCorrectionPosition;
    NSUInteger          _tickCounter;
    UITapGestureRecognizer *_tapGestureRecognizer;
}
@property (weak, nonatomic) IBOutlet UIView                 *topContainerView;   //顶部条
@property (weak, nonatomic) IBOutlet UIView                 *bottomContainerView;//底部条
@property (weak, nonatomic) IBOutlet UIView                 *audioContainerView;//音量条
@property (weak, nonatomic) IBOutlet UIButton               *lockBtn;           //锁屏
@property (weak, nonatomic) IBOutlet UISlider               *progressSlider;    //进度条
@property (weak, nonatomic) IBOutlet UIButton               *selectorDramaBtn;  //选集按钮
@property (weak, nonatomic) IBOutlet UIButton               *fullScreenBtn;     //全屏按钮
@property (weak, nonatomic) IBOutlet UIButton               *playBtn;           //播放、暂停按钮
@property (weak, nonatomic) IBOutlet UILabel                *leftLabel;         //剩余时间
@property (weak, nonatomic) IBOutlet UILabel                *progressLabel;     //进度时间
@property (weak, nonatomic) IBOutlet UIButton               *backBtn;           //返回按钮
@property (weak, nonatomic) IBOutlet UISlider               *volumeSlider;      //声音slider
@property (weak, nonatomic) IBOutlet UILabel                *loadTextLabel;     //进度百分比
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView*activityIndicatorView;
@property (readwrite, strong) KxArtworkFrame                *artworkFrame;
@property (assign,nonatomic) BOOL                           isRotate ,showSelectorView;
@property (assign,nonatomic) BOOL                           isShowing;
@property (readwrite) BOOL                                  playing;
@property (readwrite) BOOL                                  decoding;
@property (nonatomic, assign) NSTimeInterval                fadeDelay;          //tabBar fadeDelay时间

@end

static NSMutableDictionary * gHistory;
static NSString * formatTimeInterval(CGFloat seconds, BOOL isLeft)
{
    seconds = MAX(0, seconds);
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s           = s % 60;
    m           = m % 60;
    
    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%ld:%0.2ld", (long)h, (long)m];
    else        [format appendFormat:@"%ld", (long)m];
    [format appendFormat:@":%0.2ld", (long)s];
    return format;
}

@implementation FFmpegPlayer

- (void)dealloc
{
    _dispatchQueue              = nil;
    _videoFrames                = nil;
    _audioFrames                = nil;
    _parameters                 = nil;
    _currentAudioFrame          = nil;
    _artworkFrame               = nil;
    _tapGestureRecognizer       = nil;
    _decoder                    = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpSilder];
    [self updateBottomBar];
    [self setControlsState];
    [self addVolumeNotification];
}

+(FFmpegPlayer *)initNib
{
    FFmpegPlayer *view = [[NSBundle mainBundle]loadNibNamed:@"FFmpegPlayer"
                                                      owner:self options:nil][1];
    return view;
}

+ (void)initialize
{
    if (!gHistory){
        gHistory = [NSMutableDictionary dictionary];
    }
}

- (void)setControlsState
{
    if (_decoder) {
        [self setupPresentView];//设置当前的视图
    } else {
        _bottomContainerView.userInteractionEnabled = NO;
        _topContainerView.hidden                    = !self.isRotate;
    }
    _fadeDelay                                      = 5.0;
    self.lockBtn.exclusiveTouch                     = YES;
    self.fullScreenBtn.exclusiveTouch               = YES;
    self.selectorDramaBtn.exclusiveTouch            = YES;
    self.exclusiveTouch                             = YES;
    _activityIndicatorView.center                   = self.center;
    _activityIndicatorView.hidesWhenStopped         = YES;
    _volumeSlider.value                             = [MPMusicPlayerController applicationMusicPlayer].volume ;
    _activityIndicatorView.autoresizingMask         = \
    UIViewAutoresizingFlexibleTopMargin  |UIViewAutoresizingFlexibleLeftMargin|
    UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
}

#pragma  mark - viewDidAppear
- (void)viewDidAppear
{
    [self viewToPrepare];
    [self addResignActiveNotification];
}

- (void)viewToPrepare
{
    if (_decoder) {
        [self restorePlay];
    } else {
        [_activityIndicatorView startAnimating];
        _loadTextLabel.text  = @"正在加载中...";
    }
}

#pragma mark - Notification
- (void)addVolumeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:kSYSVOLUME_NOTIFICATION
                                               object:nil];
}

- (void)addResignActiveNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
}

- (void) applicationWillResignActive: (NSNotification *)notification
{
    [self pause];
}

#pragma  mark - viewWillDisappear
- (void)viewWillDisappear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_activityIndicatorView stopAnimating];
    if (_decoder) {
        [self pause];
        if (_moviePosition == 0 || _decoder.isEOF)
            [gHistory removeObjectForKey:_decoder.path];
        else if (!_decoder.isNetwork)
            [gHistory setValue:[NSNumber numberWithFloat:_moviePosition]
                        forKey:_decoder.path];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:_savedIdleTimer];
    _buffered       = NO;
    _interrupted    = YES;
}

#pragma mark - 初始化Silder
- (void)setUpSilder
{
    [_progressSlider setThumbImage:[UIImage imageNamed:@"sliderthumb"]
                          forState:UIControlStateNormal];
    [_volumeSlider   setThumbImage:[UIImage imageNamed:@"sliderthumb"]
                          forState:UIControlStateNormal];
    
    _volumeSlider.layer.anchorPoint=CGPointMake(0.0,0.0);
    _volumeSlider.transform = CGAffineTransformMakeRotation(M_PI_2);
    [_volumeSlider addTarget:self action:@selector(volumeDidChange:)
            forControlEvents:UIControlEventValueChanged];
}

#pragma mark - 音量
- (void)volumeDidChange:(id)sender
{
    UISlider *slider = sender;
    [MPMusicPlayerController applicationMusicPlayer].volume  = slider.value;
}

- (void)volumeChanged:(NSNotification *)notification
{
    float sliderValue   \
    = [notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"]floatValue];
    _volumeSlider.value = sliderValue;
}

- (BOOL) interruptDecoder
{
    if (!_decoder)
        return NO;
    return _interrupted;
}

#pragma  mark -  打开文件
- (void)playWithContentPath: (NSString *) path
                 parameters: (NSDictionary *) parameters
{
    //音频管理初始化
    id<KxAudioManager> audioManager = [KxAudioManager audioManager];
    [audioManager activateAudioSession];
    
    NSAssert(path.length > 0, @"empty path");
    _moviePosition  = 0;
    _parameters     = parameters;
    
    WS(weakSelf);
    KxMovieDecoder *decoder = [[KxMovieDecoder alloc] init];
    decoder.interruptCallback = ^BOOL(){
        __strong FFmpegPlayer *strongSelf = weakSelf;
        return strongSelf ? [strongSelf interruptDecoder] : YES;
    };
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error = nil;
        [decoder openFile:path error:&error];
        __strong FFmpegPlayer *strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [strongSelf setMovieDecoder:decoder withError:error];
            });
        }
    });
}

#pragma mark -
#pragma mark - 解码器准备工作

- (void) setMovieDecoder: (KxMovieDecoder *) decoder withError: (NSError *) error
{
    if (!error && decoder) {
        _decoder                = decoder;
        _dispatchQueue          = dispatch_queue_create("KxMovie", DISPATCH_QUEUE_SERIAL);
        _videoFrames            = [NSMutableArray array];
        _audioFrames            = [NSMutableArray array];

        if (_decoder.isNetwork) {
            _minBufferedDuration = NETWORK_MIN_BUFFERED_DURATION;
            _maxBufferedDuration = NETWORK_MAX_BUFFERED_DURATION;
        } else {
            _minBufferedDuration = LOCAL_MIN_BUFFERED_DURATION;
            _maxBufferedDuration = LOCAL_MAX_BUFFERED_DURATION;
        }
        
        if (!_decoder.validVideo)
            _minBufferedDuration *= 10.0; // increase for audio
        
        if (self.viewController.isViewLoaded) {
            [self setupPresentView];
            _topContainerView.hidden                    = !self.isRotate;
            _audioContainerView.hidden                  = !self.isRotate;
            _bottomContainerView.userInteractionEnabled = YES;
            
            [self showControls];
            if (_activityIndicatorView.isAnimating) {
                [_activityIndicatorView stopAnimating];
                 _loadTextLabel.text = @"";
                [self restorePlay];
            }
        }
    } else {
        if (self.viewController.isViewLoaded && self.viewController.view.window) {
            [_activityIndicatorView stopAnimating];
            _loadTextLabel.text  = @"";
            if (!_interrupted)
                [self handleDecoderMovieError: error];
        }
    }
}

#pragma mark - restorePlay
- (void) restorePlay
{
    NSNumber *n = [gHistory valueForKey:_decoder.path];
    if (n)
        [self updatePosition:n.floatValue playMode:YES];
    else
        [self play];
}

- (UIView *) frameView
{
    return _glView ? _glView : _imageView;
}

- (void) setupPresentView
{
    CGRect bounds = self.bounds;
    if (_decoder.validVideo) {
        _glView = [[KxMovieGLView alloc] initWithFrame:bounds decoder:_decoder];
    }
    if (!_glView) {
        [_decoder setupVideoFrameFormat:KxVideoFrameFormatRGB];
        _imageView = [[UIImageView alloc] initWithFrame:bounds];
        _imageView.backgroundColor = [UIColor blackColor];
    }
    UIView *frameView           = [self frameView];
    frameView.contentMode       = UIViewContentModeScaleAspectFit;
    frameView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | \
    UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight
    | UIViewAutoresizingFlexibleBottomMargin;
    
    [self insertSubview:frameView atIndex:0];//插入视图到指定的索引
    
    if (_decoder.validVideo) {
        [self setupUserInteraction];
    } else {
        _imageView.image        = [UIImage imageNamed:@"music_icon.png"];
        _imageView.contentMode  = UIViewContentModeCenter;
    }
    
    if (_decoder.duration == MAXFLOAT) {
        _leftLabel.text         = @"\u221E"; // infinity
        _leftLabel.font         = [UIFont systemFontOfSize:14];
        CGRect frame;
        frame                   = _leftLabel.frame;
        frame.origin.x          += 40;
        frame.size.width        -= 40;
        _leftLabel.frame        = frame;
        frame                   = _progressSlider.frame;
        frame.size.width        += 40;
        _progressSlider.frame   = frame;
        
    } else {
        [_progressSlider addTarget:self
                            action:@selector(progressDidChange:)
                  forControlEvents:UIControlEventValueChanged];
    }
}

- (void) setupUserInteraction
{
    UIView * view = [self frameView];
    view.userInteractionEnabled = YES;
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                        action:@selector(handleTap:)];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
    [view addGestureRecognizer:_tapGestureRecognizer];
}

- (void) progressDidChange:(id)sender
{
    NSAssert(_decoder.duration != MAXFLOAT, @"bugcheck");
    UISlider *slider            = sender;
    [self setMoviePosition:slider.value * _decoder.duration];
}

- (void) setMoviePosition:(CGFloat) position
{
    BOOL playMode           = self.playing;
    self.playing            = NO;
    _disableUpdateHUD       = YES;
    [self enableAudio:NO];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self updatePosition:position playMode:playMode];
    });
}

- (void) freeBufferedFrames
{
    @synchronized(_videoFrames) {
        [_videoFrames removeAllObjects];
    }
    @synchronized(_audioFrames) {
        
        [_audioFrames removeAllObjects];
        _currentAudioFrame = nil;
    }
    _bufferedDuration = 0;
}

- (BOOL) decodeFrames
{
    NSArray *frames = nil;
    
    if (_decoder.validVideo ||_decoder.validAudio) {
        frames = [_decoder decodeFrames:0];
    }
    if (frames.count) {
        return [self addFrames: frames];
    }
    return NO;
}

- (BOOL) addFrames: (NSArray *)frames
{
    if (_decoder.validVideo) {
        @synchronized(_videoFrames) {
            for (KxMovieFrame *frame in frames)
                if (frame.type == KxMovieFrameTypeVideo) {
                    [_videoFrames addObject:frame];
                    _bufferedDuration += frame.duration;
                }
        }
    }
    if (_decoder.validAudio) {
        @synchronized(_audioFrames) {
            for (KxMovieFrame *frame in frames)
                if (frame.type == KxMovieFrameTypeAudio) {
                    [_audioFrames addObject:frame];
                    if (!_decoder.validVideo)
                        _bufferedDuration += frame.duration;
                }
        }
        
        if (!_decoder.validVideo) {
            for (KxMovieFrame *frame in frames)
                if (frame.type == KxMovieFrameTypeArtwork)
                    self.artworkFrame = (KxArtworkFrame *)frame;
        }
    }

    return self.playing && _bufferedDuration < _maxBufferedDuration;
}

#pragma mark - seek 功能

- (void) updatePosition: (CGFloat) position playMode: (BOOL) playMode
{
    [self freeBufferedFrames];
    position = MIN(_decoder.duration - 1, MAX(0, position));
    
    __weak FFmpegPlayer *weakSelf = self;
    dispatch_async(_dispatchQueue, ^{
        if (playMode) {
            {
                __strong FFmpegPlayer *strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf setDecoderPosition: position];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong FFmpegPlayer *strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf setMoviePositionFromDecoder];
                    [strongSelf play];
                }
            });
            
        } else {
            {
                __strong FFmpegPlayer *strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf setDecoderPosition: position];
                [strongSelf decodeFrames];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong FFmpegPlayer *strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf enableUpdateHUD];
                    [strongSelf setMoviePositionFromDecoder];
                    [strongSelf presentFrame];
                    [strongSelf updateHUD];
                }
            });
        }
    });
}


- (void) updateHUD
{
    if (_disableUpdateHUD)
        return;
    const CGFloat duration      = _decoder.duration;
    const CGFloat position      = _moviePosition -_decoder.startTime;
    if (_progressSlider.state   == UIControlStateNormal)
        _progressSlider.value   = position / duration;
    _progressLabel.text         = formatTimeInterval(position, NO);
    
    if (_decoder.duration != MAXFLOAT)
        _leftLabel.text         = formatTimeInterval(duration - position, YES);
    
    _loadTextLabel.text         =\
    _buffered ?[NSString stringWithFormat:@"正在缓冲:%ld%%",
                                        (NSInteger)\
                (_bufferedDuration / _minBufferedDuration * 100)] : @"";
#ifdef DEBUG
//  const NSTimeInterval timeSinceStart = [NSDate timeIntervalSinceReferenceDate] - _debugStartTime;
    NSString *audioStatus;
    if (_debugAudioStatus) {
        if (NSOrderedAscending == [_debugAudioStatusTS
                                   compare:[NSDate dateWithTimeIntervalSinceNow:-0.5]]) {
            _debugAudioStatus = 0;
        }
    }
    if      (_debugAudioStatus == 1) audioStatus = @"\n(audio outrun)";
    else if (_debugAudioStatus == 2) audioStatus = @"\n(audio lags)";
    else if (_debugAudioStatus == 3) audioStatus = @"\n(audio silence)";
    else audioStatus = @"";
    PDebugLog(@"%@",audioStatus);
#endif
}

- (CGFloat) presentFrame
{
    CGFloat interval = 0;
    if (_decoder.validVideo) {
        KxVideoFrame *frame;
        @synchronized(_videoFrames) {
            if (_videoFrames.count > 0) {
                frame             = _videoFrames[0];
                [_videoFrames removeObjectAtIndex:0];
                _bufferedDuration -= frame.duration;
            }
        }
        if (frame)
            interval = [self presentVideoFrame:frame];
    } else if (_decoder.validAudio) {
        if (self.artworkFrame) {
            _imageView.image  = [self.artworkFrame asImage];
            self.artworkFrame = nil;
        }
    }
#ifdef DEBUG
    if (self.playing && _debugStartTime < 0)
        _debugStartTime = [NSDate timeIntervalSinceReferenceDate] - _moviePosition;
#endif
    
    return interval;
}

//当前音频帧
- (CGFloat) presentVideoFrame: (KxVideoFrame *) frame
{
    if (_glView) {
        [_glView render:frame];
    } else {
        KxVideoFrameRGB *rgbFrame = (KxVideoFrameRGB *)frame;
        _imageView.image          = [rgbFrame asImage];
    }
    _moviePosition = frame.position;
    return frame.duration;
}

- (void) enableUpdateHUD
{
    _disableUpdateHUD = NO;
}

- (void) asyncDecodeFrames
{
    if (self.decoding)
        return;
    WS(weakSelf);
    __weak KxMovieDecoder *weakDecoder = _decoder;
    const CGFloat duration = _decoder.isNetwork ? .0f : 0.1f;
    self.decoding = YES;
    dispatch_async(_dispatchQueue, ^{
        {
            __strong FFmpegPlayer *strongSelf = weakSelf;
            if (!strongSelf.playing)
                return;
        }
        BOOL good = YES;
        while (good) {
            good = NO;
            @autoreleasepool {
                __strong KxMovieDecoder *decoder = weakDecoder;
                if (decoder && (decoder.validVideo || decoder.validAudio)) {
                    NSArray *frames = [decoder decodeFrames:duration];
                    if (frames.count) {
                       __strong FFmpegPlayer *strongSelf = weakSelf;
                        if (strongSelf)
                            good = [strongSelf addFrames:frames];
                    }
                }
            }
        }
        {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) strongSelf.decoding = NO;
        }
    });
}

#pragma mark - play
-(void) play
{
    if (self.playing)
        return;
    if (!_decoder.validVideo &&
        !_decoder.validAudio) {
        return;
    }
    if (_interrupted)
        return;
    self.playing        = YES;
    _interrupted        = NO;
    _disableUpdateHUD   = NO;
    _tickCorrectionTime = 0;
    _tickCounter        = 0;
    
#ifdef DEBUG
    _debugStartTime     = -1;
#endif
    
    [self asyncDecodeFrames];
    [self updatePlayButton];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter]\
         postNotificationName:@"MPMoviePlayerWillEnterFullscreenNotification"
         object:nil];
        [self tick];
        
    });
    
    if (_decoder.validAudio)
        [self enableAudio:YES];
}

#pragma mark - 标记
- (void) tick
{
    if (_buffered && ((_bufferedDuration > _minBufferedDuration) || _decoder.isEOF)) {
        _tickCorrectionTime = 0;
        _buffered           = NO;
        [_activityIndicatorView stopAnimating];
    }
    
    CGFloat interval = 0;
    if (!_buffered)
        interval = [self presentFrame];
    
    if (self.playing) {
        const NSUInteger leftFrames =
        (_decoder.validVideo ? _videoFrames.count : 0);
        //+(_decoder.validAudio ? _audioFrames.count : 0);//------//
        
        if (0 == leftFrames) {
            if (_decoder.isEOF) {
                [self pause];
                [self updateHUD];
                [self dramaHandle:nil];
                return;
            }
            if (_minBufferedDuration > 0 && !_buffered) {
                _buffered = YES;
                [_activityIndicatorView startAnimating];
            }
        }
        if (!leftFrames ||
            !(_bufferedDuration > _minBufferedDuration)) {
            
            [self asyncDecodeFrames];
        }
        const NSTimeInterval correction = [self tickCorrection];
        const NSTimeInterval time = MAX(interval + correction, 0.01);
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self tick];
        });
    }
    
    if ((_tickCounter++ % 3) == 0) {
        [self updateHUD];
    }
}

#pragma mark -刻度校正
- (CGFloat) tickCorrection
{
    if (_buffered)
        return 0;
    const NSTimeInterval now    = [NSDate timeIntervalSinceReferenceDate];
    if (!_tickCorrectionTime) {
        
        _tickCorrectionTime     = now;
        _tickCorrectionPosition = _moviePosition;
        return 0;
    }
    NSTimeInterval dPosition    = _moviePosition - _tickCorrectionPosition;
    NSTimeInterval dTime        = now - _tickCorrectionTime;
    NSTimeInterval correction   = dPosition - dTime;
    if (correction > 1.f || correction < -1.f) {
        correction = 0;
        _tickCorrectionTime     = 0;
    }
    return correction;
}

#pragma mark - pause
- (void) pause
{
    if (!self.playing)
        return;
    self.playing    = NO;
    [self enableAudio:NO];
    [self updatePlayButton];
}

- (void) updatePlayButton
{
    [self updateBottomBar];
}

- (void) updateBottomBar
{
    NSString *imageName = self.playing ?@"playback_pause":@"playback_play";
    [_playBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void) setDecoderPosition: (CGFloat) position
{
    _decoder.position = position;
}

- (void) setMoviePositionFromDecoder
{
    _moviePosition = _decoder.position;
}

- (void) enableAudio: (BOOL) on
{
    id<KxAudioManager> audioManager = [KxAudioManager audioManager];
    if (on && _decoder.validAudio) {
        audioManager.outputBlock = ^(float *outData, UInt32 numFrames, UInt32 numChannels) {
            [self audioCallbackFillData: outData numFrames:numFrames numChannels:numChannels];
        };
        [audioManager play];
// LoggerAudio(2, @"audio device smr: %d fmt: %d chn: %d",(int)audioManager.samplingRate,
//             (int)audioManager.numBytesPerSample,
//              (int)audioManager.numOutputChannels);
    } else {
        [audioManager pause];
        audioManager.outputBlock = nil;
    }
}

- (void) audioCallbackFillData: (float *) outData
                     numFrames: (UInt32) numFrames
                   numChannels: (UInt32) numChannels
{
    if (_buffered) {
        memset(outData, 0, numFrames * numChannels * sizeof(float));
        return;
    }
    @autoreleasepool {
        while (numFrames > 0) {
            if (!_currentAudioFrame) {
                @synchronized(_audioFrames) {
                    NSUInteger count = _audioFrames.count;
                    if (count > 0) {
                        KxAudioFrame *frame = _audioFrames[0];
                        
#ifdef DUMP_AUDIO_DATA
                        LoggerAudio(2, @"Audio frame position: %f", frame.position);
#endif
                        if (_decoder.validVideo) {
                            
                            const CGFloat delta = _moviePosition - frame.position;
                            if (delta < -0.1) {
                                
                                memset(outData, 0, numFrames * numChannels * sizeof(float));
#ifdef DEBUG
                                _debugAudioStatus = 1;
                                _debugAudioStatusTS = [NSDate date];
#endif
                                break; // silence and exit
                            }
                            [_audioFrames removeObjectAtIndex:0];
                            if (delta > 0.1 && count > 1) {
                                
#ifdef DEBUG
                                _debugAudioStatus   = 2;
                                _debugAudioStatusTS = [NSDate date];
#endif
                                continue;
                            }
                        } else {
                            [_audioFrames removeObjectAtIndex:0];
                            _moviePosition      = frame.position;
                            _bufferedDuration   -= frame.duration;
                        }
                        _currentAudioFramePos   = 0;
                        _currentAudioFrame      = frame.samples;
                    }
                }
            }
            if (_currentAudioFrame) {
                const void *bytes = (Byte *)_currentAudioFrame.bytes + _currentAudioFramePos;
                const NSUInteger bytesLeft = (_currentAudioFrame.length - _currentAudioFramePos);
                const NSUInteger frameSizeOf = numChannels * sizeof(float);
                const NSUInteger bytesToCopy = MIN(numFrames * frameSizeOf, bytesLeft);
                const NSUInteger framesToCopy = bytesToCopy / frameSizeOf;
                memcpy(outData, bytes, bytesToCopy);
                numFrames -= framesToCopy;
                outData += framesToCopy * numChannels;
                
                if (bytesToCopy < bytesLeft)
                    _currentAudioFramePos += bytesToCopy;
                else
                    _currentAudioFrame = nil;
                
            } else {
                memset(outData, 0, numFrames * numChannels * sizeof(float));
                
#ifdef DEBUG
                _debugAudioStatus   = 3;
                _debugAudioStatusTS = [NSDate date];
#endif
                break;
            }
        }
    }
}

- (void) handleDecoderMovieError: (NSError *) error
{
    [self handleTap:nil];
    //[error localizedDescription]
    [self makeToast:NSLocalizedString(@"播放影片文件失败", nil) duration:1.0 position:@"bottom" tag:10010];
}

#pragma mark - Actions
#pragma mark - 播放与暂停
- (IBAction)playAndpauseAction:(id)sender
{
    if (self.playing){
        [self state];
    }
    else{
        //[_activityIndicatorView startAnimating];
        [self play];
        [_playBtn setImage:[UIImage imageNamed:@"playback_pause"] forState:UIControlStateNormal];
    }
}

- (void)state
{
    if (self.playing){
        [_playBtn setImage:[UIImage imageNamed:@"playback_play"] forState:UIControlStateNormal];
        [_activityIndicatorView stopAnimating];
        [self pause];
    }
}

#pragma mark- 锁屏

- (IBAction)lockAction:(id)sender
{
    _lockBtn.selected = !_lockBtn.selected;
    [PSystemSettingScreenLock screenLock:_lockBtn.selected];
}

- (void)remove
{
    [_glView removeFromSuperview];
    _glView                         = nil;
    _dispatchQueue                  = NULL;
    _decoder                        = nil;
    self.decoding                   = NO;
    self.playing                    = NO;
    [self freeBufferedFrames];
}

#pragma mark- 是否全屏
- (IBAction)fullScreenAction:(id)sender
{
    if (self.limitFullScreenBlock){
        self.isRotate            =!self.isRotate;
        self.limitFullScreenBlock(self.isRotate);
    }
}

#pragma mark- 显示剧集容器
- (void)setupSelector
{
    if (_selectorView == nil) {
        _selectorView           = [PSelectorView initWithNib];
        CGRect  frame           = _selectorView.frame;
        frame.origin.y          = UIScreenHeight;
        _selectorView.frame     = frame;
        _selectorView.dataArray = [@[MP4_2,MP4_1]mutableCopy];
        [self addSubview:_selectorView];
    }
}

- (IBAction)dramaHandle:(id)sender
{
    //1.隐藏上下ContainterView
    [self handleTap:nil];
    
    //2.加载选集View
    [self setupSelector];
    
    //3.resize Frame
    CGRect  frame          = _selectorView.frame ;
    CGFloat bottomH        = CGRectGetHeight(_bottomContainerView.frame);
    CGFloat choiceH        = CGRectGetHeight(_selectorView.frame);
    frame.origin.y         = _bottomContainerView.frame.origin.y - choiceH +bottomH ;
    frame.size.width       = _bottomContainerView.frame.size.width;
    _selectorView.frame    = frame;
    self.showSelectorView  = YES;
    
    //4. 选集block
    WS(weakSelf);
    _selectorView.dramaOptionBlock  = ^(NSString *urlString){
        [weakSelf hideSelectorContainer];
        [weakSelf selectorWithUrl:urlString];
    };
}

- (void)selectorWithUrl:(NSString *)urlString
{
    [self state];
    [self remove];
    [self viewToPrepare];
    
    [self playWithContentPath:urlString parameters:nil];
}

#pragma mark- 隐藏剧集容器
- (void)hideSelectorContainer
{    
    [_selectorView hide];
    self.showSelectorView = NO;
}

#pragma  mark - 手势处理
- (void)handleTap:(id)gesture
{
    //选集出现，隐藏选集容器
    if (self.showSelectorView) {
        [self hideSelectorContainer];
        return;
    }
     self.isShowing ? [self hideControls] : [self showControls];
}

#pragma  mark - 显示隐藏Top Bottm audio容器
- (void)showControls
{
    if (!self.isShowing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(hideControls)
                                                   object:nil];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            if (self.isRotate) {
                self.topContainerView .alpha    = 1.f;
                self.audioContainerView .alpha  = 1.f;
            }
            self.bottomContainerView.alpha      = 1.f;
        } completion:^(BOOL finished) {
            _isShowing = YES;
            [self performSelector:@selector(hideControls) withObject:nil
                       afterDelay:self.fadeDelay];
        }];
    }
}

- (void)hideControls
{
    if (self.isShowing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(hideControls)
                                                   object:nil];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            if (self.isRotate) {
                self.topContainerView .alpha    = 0.f;
                self.audioContainerView .alpha  = 0.f;
            }
            self.bottomContainerView.alpha      = 0.f;
        } completion:^(BOOL finished) {
            _isShowing = NO;
        }];
    }
}

- (void)hidetopContainerView:(BOOL)hide
{
    _topContainerView.hidden   = hide;
    _audioContainerView.hidden = hide;
}
@end
