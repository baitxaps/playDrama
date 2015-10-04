//
//  PLoginViewController.m
//  PlayDrama
//
//  Created by RHC on 15/4/14.
//  Copyright (c) 2015年 times. All rights reserved.
//



#import "PLoginViewController.h"
#import "PRegisterViewController.h"
#import "PFindPassViewController.h"
#import "PLoginManager.h"
#import "PlayTabBarViewController.h"
#import "PUserEntity.h"
#import "PKeyChainHelper.h"
#import "PShareTools.h"

@interface PLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView    *loginBGView;
@property (weak, nonatomic) IBOutlet UITextField    *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField    *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel        *forgetPassLabel;
@property (weak, nonatomic) IBOutlet UILabel        *registerLabel;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userToken;

@end

@implementation PLoginViewController

+ (id)sharedInstance
{
    static PLoginViewController *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIStoryboard *drama_storyboard = [UIStoryboard storyboardWithName:PLOGIN_STORYBOARD bundle:[NSBundle mainBundle]];
       sharedInstace = drama_storyboard.instantiateInitialViewController;
    });
    
    return sharedInstace;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view textFieldPlaceholder:self.userNameTextField textWithFont:13];
    [self.view textFieldPlaceholder:self.passwordTextField textWithFont:13];
    self.view.backgroundColor = RGB(0xd9552a, 1);
    
    //_loginBGView.image = [_loginBGView.image resizableImageWithCapInsets:UIEdgeInsetsMake(80, 142, 80, 142)];
    
    UITapGestureRecognizer *regGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerAction:)];
    [_registerLabel addGestureRecognizer:regGesture];
    
    UITapGestureRecognizer *forgetGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(findPasswordAction:)];
    [_forgetPassLabel addGestureRecognizer:forgetGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userNameTextField.text = [PKeyChainHelper getUserNameWithService:KEY_USERNAME];    
}

- (IBAction)closeAction:(id)sender
{
    PlayTabBarViewController *vc = [[PLoginManager sharedInstance] playTabbarVC];
    [vc setSelectedIndex:0];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)loginSuccessWithUserId:(NSString *)userId account:(NSString *)account passWord:(NSString *)passWord
{
    [PKeyChainHelper saveUserName:account userNameService:KEY_USERNAME psaaword:passWord psaawordService:KEY_PASSWORD];
    
    PUserEntity *PUser = [PUserEntity sharedInstance];
    PUser.userName     = account;
    PUser.userId       = userId;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)loginAction:(id)sender
{
    LoginPlatFormType loginType = (LoginPlatFormType)((UIButton *)sender).tag;
    switch (loginType) {
        case LoginPlatFormTypeSystem:
        {
            [self loginSuccessWithUserId:self.userNameTextField.text
                                 account:self.passwordTextField.text
                                passWord:self.passwordTextField.text];
        }
            break;
        case LoginPlatFormTypeSinaWeibo:
        {
             [[PShareTools sharedInstance] loginWithPlatformWithType:LoginPlatFormTypeSinaWeibo];
        }
            break;
        case LoginPlatFormTypeQQ:
        {
            [[PShareTools sharedInstance] loginWithPlatformWithType:LoginPlatFormTypeQQ];
        }
            break;
        case LoginPlatFormTypeWX:
        {
             [[PShareTools sharedInstance] loginWithPlatformWithType:LoginPlatFormTypeWX];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)thirdLoginSeverWithTpye:(thirdpartyLoginType)type openId:(NSString *)openId accessToken:(NSString *)accessToken
{
   // [self showHudWithAnimated:YES title:NSLocalizedString(@"GO_Common_Loding_Title_Logining", nil)];
//    [GOAuthenticationBLL thirdpartyLogin:type openid:openId accessToken:accessToken success:^(NSDictionary *dict) {
//        [_hud hide:YES];
//        [self dealWithlonginSuccess:dict logKey:nil passwd:nil];
//    } failure:^(NSString *errorDes) {
//        [_hud hide:YES];
//        if (self.loginFailureBlock){
//            self.loginFailureBlock();
//        }else{
//            [self showAlertWithTitle:nil message:errorDes];
//        }
//    }];
    
}



- (void)registerAction:(UITapGestureRecognizer *)gesture
{
    PRegisterViewController *register_Ctr = [[PRegisterViewController alloc] initWithNibName:@"PRegisterViewController"
                                                                                     bundle:nil];
    UINavigationController *nav_ctrl = [[UINavigationController alloc] initWithRootViewController:register_Ctr];
    [self presentViewController:nav_ctrl animated:YES completion:nil];
}

- (void)findPasswordAction:(UITapGestureRecognizer *)gesture
{
    PFindPassViewController *finderPass_Ctr = [[PFindPassViewController alloc] initWithNibName:@"PFindPassViewController"
                                                                                      bundle:nil];
    UINavigationController *nav_ctrl = [[UINavigationController alloc] initWithRootViewController:finderPass_Ctr];
    [self presentViewController:nav_ctrl animated:YES completion:nil];
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
