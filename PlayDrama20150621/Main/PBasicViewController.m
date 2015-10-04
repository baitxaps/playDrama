//
//  PBasicViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/22.
//  Copyright (c) 2015年 times. All rights reserved.
//
const NSInteger kToastTag = 0x121212;

#import "PBasicViewController.h"
#import "PConfig.h"
#import "NSString+Extension.h"

@implementation PBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
   if (IS_IOS7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }else{
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }
 
}



#pragma mark - HUDView -
- (void)showHudWithAnimated:(BOOL)animated
{
    [self showHudWithTitle:@"努力加载中..."];
}

- (void)showHudScreenAnimated:(BOOL)animated
{
   // _hud = [PProgressHUB showHUDAddedToForScreen:self.view];
    //_hud.loadingTLabelext.text = @"努力加载中...";
    
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
     _hud.labelText = @"处理中...";
     [_hud show:YES];
}

- (void)showHudWithTitle:(NSString *)title
{
   // _hud = [PProgressHUB showHUDAddedTo:self.view];
   // _hud.loadingTLabelext.text = title;
    
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
       
        [self.view addSubview:_hud];
    }
    _hud.labelText = title;
    [_hud show:YES];
}


- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg
{
    title = [NSString checkNull:title];
    msg = [NSString checkNull:msg];
    if (title.length)
    {
        [[UIApplication sharedApplication].keyWindow makeToast:msg duration:1.0 position:@"bottom" title:title tag:kToastTag];
    }else{
        [[UIApplication sharedApplication].keyWindow makeToast:msg duration:1.0 position:@"bottom" tag:kToastTag];
    }
}


#pragma mark- 横屏处理
- (BOOL)shouldAutorotate{
    return YES;
}


//返回最上层的子Controller的supportedInterfaceOrientations
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//强制转为竖屏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
