//
//  PShareTools.m
//  PlayDrama
//
//  Created by RHC on 15/4/25.
//  Copyright (c) 2015年 times. All rights reserved.
//
//#import "YXEasing.h"
#define kInputGraviewTag  8889
#define kShareViewHeight  289

#import "PShareToolsView.h"
#import "PShareTools.h"
#import <Social/Social.h>

@interface PShareToolsView ()<PShareToolDeleage>
@property (nonatomic, strong) SLComposeViewController *slComposeVC;
@end

@implementation PShareToolsView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = RGB(0xdeded3, 0.95);//RGBAColor(214, 216, 207, 0.95);
}

+(PShareToolsView *)initNib
{
    PShareToolsView *view = nil;
    view = [[NSBundle mainBundle] loadNibNamed:@"PShareToolsView" owner:self options:nil][0];
    return view;
}


- (void)setWithController_:(UIViewController *)controller
{
    _withController_    =  controller;
    //加一个覆盖层
    CGRect winFrame     = (CGRect){CGPointMake(0.,UIScreenHeight),controller.view.frame.size};
    UIView * coverView  = [[UIView alloc]initWithFrame:winFrame];
    coverView.backgroundColor = [UIColor clearColor];
    coverView.tag       = kInputGraviewTag;
    [controller.view addSubview:coverView];
    [controller.view addSubview:self];
    
    [self setFrame:CGRectMake(0, UIScreenHeight, UIScreenWidth, 213)];
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [coverView addGestureRecognizer:guesture];
    
}

- (void)show
{
    UIView *win =  _withController_.view;
    UIView *coverView = [win viewWithTag:kInputGraviewTag];
    [UIView animateWithDuration:0.5 animations:^{
        
        [coverView setFrame:(CGRect){CGPointMake(0.,0),win.frame.size}];
        [self setFrame:CGRectMake(0, UIScreenHeight - kShareViewHeight - 64, UIScreenWidth, kShareViewHeight)];
    }];
    

//     创建模拟的菜单
//    UIImageView *imageView = [[UIImageViewalloc] initWithFrame:CGRectMake(320,0, 320, 568)];
//    imageView.image        = [UIImageimageNamed:@"pic"];
//    [self.viewaddSubview:imageView];

// 创建关键帧动画
//    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animation];
//    keyFrameAnimation.keyPath              =@"position";
//    keyFrameAnimation.duration             =1.f;
//    keyFrameAnimation.values               = \
//    [YXEasing calculateFrameFromPoint:self.center
//                             toPoint:CGPointMake(self.center.x, self.center.y)
//                                func:CubicEaseOut
//                          frameCount:1 *30];//插入帧数
//
//    // 加载关键帧动画
//    self.center =CGPointMake(self.center.x, self.center.y);
//    [self.layer addAnimation:keyFrameAnimation forKey:nil];XD  V
}


- (void)dismiss
{
    [self cancelAction:nil];
}


- (IBAction)shareAction:(id)sender
{
    SharePlatFormType shareType = (SharePlatFormType)((UIButton *)sender).tag;
    PDebugLog(@"%ld",((UIButton *)sender).tag);
    
    WS(weakSelf);
    switch (shareType) {
        case SharePlatFormTypeWXSession:
            [weakSelf shareContentToWXAndQQPlatFormWithScene:SharePlatFormTypeWXSession url:weakSelf.shareURL];
            break;
            
        case SharePlatFormTypeWXTimeline:
            [weakSelf shareContentToWXAndQQPlatFormWithScene:SharePlatFormTypeWXSession url:weakSelf.shareURL];
            break;
            
        case SharePlatFormTypeQQFriend:
            [weakSelf shareContentToWXAndQQPlatFormWithScene:SharePlatFormTypeWXSession url:weakSelf.shareURL];
            break;
            
        case SharePlatFormTypeQQZone:
            [weakSelf shareContentToWXAndQQPlatFormWithScene:SharePlatFormTypeWXSession url:weakSelf.shareURL];
            break;
            
        case SharePlatFormTypeSinaWeibo:
            [weakSelf shareContentToSystemPlatWithType:SLServiceTypeSinaWeibo andUrl:weakSelf.shareURL];
            break;
        default:
            break;
    }
    
    
    [self cancelAction:nil];
}

#pragma mark - qq weixin

- (void)shareContentToWXAndQQPlatFormWithScene:(SharePlatFormType)type url:(NSString *)url
{
    if ([Networking checkNetworkState]) {
        [PUtility showAlertWithTitle:nil message:NSLocalizedString(@"网络连接失败,请稍后重试", nil)];
        return;
    }
    
    [[PShareTools sharedInstance] shareContentToPlatFormWithType:type
                                                           bText:NO
                                                           title:self.shareContent
                                                     description:nil
                                                           image:_shareImageForPlates ? _shareImageForPlates : [UIImage imageNamed:@"log"]
                                                      webpageUrl:url
                                                        delegate:self];
}

#pragma mark - sina

- (void)shareContentToSystemPlatWithType:(NSString *)type andUrl:(NSString *)urlStr
{
    if ([Networking checkNetworkState]) {
        [PUtility showAlertWithTitle:nil message:NSLocalizedString(@"网络连接失败,请稍后重试", nil)];
        return;
    }
    
    NSURL *url = nil;
    if (urlStr && [urlStr length] > 0) {
        url = [NSURL URLWithString:urlStr];
    }
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 6)
    {
        self.slComposeVC = [SLComposeViewController composeViewControllerForServiceType:type];
        WS(weakSelf);
        
        [_slComposeVC setInitialText:self.shareContent];
        [_slComposeVC addImage:(_shareImageForPlates ? _shareImageForPlates : [UIImage imageNamed:@"golo_extern.png"])];
        [_slComposeVC addURL:url];
        
        [_slComposeVC setCompletionHandler:^(SLComposeViewControllerResult result) { // 注册回调
            NSString *output = nil;
            switch (result)
            {
                case SLComposeViewControllerResultCancelled:
                    output = NSLocalizedString(@"分享取消！", nil);
                    break;
                case SLComposeViewControllerResultDone:
                    output = NSLocalizedString(@"分享成功", nil);
                    break;
                default:
                    break;
            }
            
            if (output) {
                [PUtility showAlertWithTitle:@"" message:output];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.slComposeVC dismissViewControllerAnimated:YES completion:^{
                    weakSelf.slComposeVC = nil;
                }];
                return;
            });
        }];
        [self.withController_.navigationController presentViewController:_slComposeVC animated:YES completion:nil];
    }
}

- (IBAction)cancelAction:(id)sender
{
    __block UIView *win =  _withController_.view;
    UIView *coverView = [win viewWithTag:kInputGraviewTag];
    [UIView animateWithDuration:0.5 animations:^{
        
        [coverView setFrame:(CGRect){CGPointMake(0.,UIScreenHeight),win.frame.size}];
        [self setFrame:CGRectMake(0, UIScreenHeight, self.frame.size.width, 213)];
    }];
}

@end
