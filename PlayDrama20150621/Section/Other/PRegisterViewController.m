//
//  PRegisterViewController.m
//  PlayDrama
//
//  Created by RHC on 15/4/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PRegisterViewController.h"
#import "PClauseViewController.h"
#import "PFindPassViewController.h"
#import "PVerifyFunc.h"

@interface PRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField    *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField    *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField    *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField    *validpassWordTextField;
@property (weak, nonatomic) IBOutlet UIButton       *agreementBtn;
@property (weak, nonatomic) IBOutlet UILabel        *agreementLable;

@end

@implementation PRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setGUresture];
}


- (void)setupView
{
    self.agreementBtn.selected          = YES;
    self.agreementBtn.exclusiveTouch    = YES;
    self.view.backgroundColor           = RGB(0xd9552a, 1);
    [self.view textFieldPlaceholder:self.phoneTextField textWithFont:13];
    [self.view textFieldPlaceholder:self.nickNameTextField textWithFont:13];
    [self.view textFieldPlaceholder:self.passWordTextField textWithFont:13];
    [self.view textFieldPlaceholder:self.validpassWordTextField textWithFont:13];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithText:@"注册" target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)setGUresture
{
    UITapGestureRecognizer *clauseGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clauseAction:)];
    [_agreementLable addGestureRecognizer:clauseGuesture];
}


- (BOOL)verify
{
    if ([self.phoneTextField.text length] ==0) {
        [self.view makeToast:@"请输入手机号" duration:1 position:@"center"];
        return NO;
    }
    
    if ( ![PVerifyFunc isMobileNumber:self.phoneTextField.text]) {
       [self.view makeToast:@"请输入正确的手机号" duration:1 position:@"center"];
        return NO;
    }
    
    if ([self.nickNameTextField.text length] ==0) {
        [self.view makeToast:@"请输入昵称" duration:1 position:@"center"];
        return NO;
    }
    
    if ([self.passWordTextField.text length] ==0) {
        [self.view makeToast:@"请输入密码" duration:1 position:@"center"];
        return NO;
    }
    
    if ([self.validpassWordTextField.text length] ==0) {
        [self.view makeToast:@"请输入确认密码" duration:1 position:@"center"];
        return NO;
    }
    
    if (![self.validpassWordTextField.text isEqualToString:self.passWordTextField.text]) {
        [self.view makeToast:@"两次输入的密码不一致" duration:1 position:@"center"];
        return NO;
    }
    
    if (!self.agreementBtn.selected) {
        [self.view makeToast:@"您还未同意注册协议" duration:1 position:@"center"];
        return NO;
    }
    
    return YES;
}

- (IBAction)registerAction:(id)sender
{
    if ([self verify]) {
        
    }
}

- (IBAction)agreementBtnStateType:(id)sender
{
    _agreementBtn.selected = !_agreementBtn.selected;
}

- (void)backAction:(id)sender
{
//    if (_isNotRegisterTumpTo) {
//        [self.navigationController popViewControllerAnimated:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)clauseAction:(UITapGestureRecognizer *)gesture
{
    PClauseViewController *clause = [[PClauseViewController alloc]initWithNibName:@"PClauseViewController" bundle:nil];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:clause];
    [self presentViewController:na animated:YES completion:nil];
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
    
}


@end
