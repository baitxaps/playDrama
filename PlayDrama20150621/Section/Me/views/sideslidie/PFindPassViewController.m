//
//  PFindPassViewController.m
//  PlayDrama
//
//  Created by RHC on 15/4/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PFindPassViewController.h"
#import "PCountDownButton.h"
#import "PlayTabBarViewController.h"

@interface PFindPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField        *phoneTextField;
@property (weak, nonatomic) IBOutlet PCountDownButton   *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField        *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField        *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField        *verifyPasswordTextField;

@end

@implementation PFindPassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *leftItem = \
    [[UIBarButtonItem alloc] initWithText:@"返回"
                                   target:self
                                   action:@selector(backAction:)];//presentRightMenuViewController
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self setupView];
}


- (void)backAction:(id)sender
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UIViewController *barvc     =[PlayTabBarViewController shareInstance];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:barvc];
    
    [self.sideMenuViewController setContentViewController:nav animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)setupView
{
    self.view.backgroundColor = RGB(0xd9552a, 1);
    [self.view textFieldPlaceholder:self.phoneTextField textWithFont:13];
    [self.view textFieldPlaceholder:self.verifyCodeTextField textWithFont:13];
    [self.view textFieldPlaceholder:self.passwordTextField textWithFont:13];
    [self.view textFieldPlaceholder:self.verifyPasswordTextField textWithFont:13];
    
    [self.verifyCodeBtn setStartTitle:@"获取验证码" withTime:60 endTitle:@"%0.f秒后重新获取"];
}



- (IBAction)submitAction:(id)sender
{
    
}


- (IBAction)reGetVertityCodeBtnClick:(id)sender
{
    [_verifyCodeBtn startCount];
    //重新发送网络请求，获取新的验证码
    [self getVertityCode];
}

#pragma mark -- private
//获取验证码
- (void)getVertityCode
{
    //todo fetchData
    
}

//验证 验证码
- (void)vertityVerCode
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
