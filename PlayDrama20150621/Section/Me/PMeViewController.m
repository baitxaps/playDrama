//
//  PMeViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMeViewController.h"
#import "PMeTableViewCell.h"
#import "PMyCollectionViewController.h"
#import "PRegisterViewController.h"
#import "PResetPasswordViewController.h"
#import "UIView+Size.h"
#import "PMeCellHeadView.h"
#import "PAvatarView.h"
#import "GCD.h"
#import "MPMoviePlayerSubViewController.h"
#import "PCaptureViewController.h"


@interface PMeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView     *pMeTableView;
@property (weak, nonatomic) IBOutlet UIView           *headBottomView;
@property (weak, nonatomic) IBOutlet UIView           *headTopView;
@property (strong,nonatomic)PAvatarView               *avatarView;//用户头像
@property (weak, nonatomic) IBOutlet UILabel          *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel          *levelLabel;
@property (strong,nonatomic) NSArray                  *dataArray;

@end

@implementation PMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataArray = @[@"我的收藏",@"我的钱袋",@"我的礼物箱",@"我的等级"];
    
    [self addNav];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


- (void)setupSubviews
{
    [self.headBottomView drawBounderWidth:0.5 Color:RGBAColor(245, 132, 105, 1)];
    
    //用户名
    self.levelLabel.right = self.userNameLabel.right + 50;
    [self clipExtraCellLine:self.pMeTableView];
    
    //头像
    _avatarView                = [PAvatarView initWithNib];
    _avatarView.withController_= self;
    WS(weakSelf);
    _avatarView.uploadAvatarBlock = ^(UIImage *image){
        [weakSelf uploadAvaterImage];
    };;
    [self.headTopView  addSubview: _avatarView];
    _avatarView.frame         = CGRectMake(
                                           self.headTopView.frame.size.width/2.0 - _avatarView.frame.size.width/2.0 ,
                                           17,
                                           _avatarView.frame.size.width,
                                           _avatarView.frame.size.height
                                           );
}


- (void)addNav
{
    self.navigationItem.leftBarButtonItem  =\
    [[UIBarButtonItem  alloc ]initWithNavigationItem:self.navigationItem
                                            WithText:@"玩我"];
    UIBarButtonItem *rightBarItem = \
    [[UIBarButtonItem alloc]initWithNavigationItem:self.navigationItem
                                            target:self
                                            action:@selector(presentRightMenuViewController:)
                                       bgImgString:@"playme_setting"];
    
    self.navigationItem.rightBarButtonItems = @[rightBarItem];
}

#pragma mark - 录制视频

- (void)videoCaptureAction
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        [self.view makeToast:@"当前设备不支持摄像" duration:2 position:@"center" tag:11111];
        return;
    }

    UINavigationController *navCon = [[UINavigationController alloc] init];
    navCon.navigationBarHidden     = YES;
    
    PCaptureViewController *captureViewCon = [[PCaptureViewController alloc] initWithNibName:@"PCaptureViewController" bundle:nil];
    [navCon pushViewController:captureViewCon animated:NO];
    [self presentViewController:navCon animated:YES completion:nil];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    return YES;
}


#pragma mark - 修改密码
- (void)modifyPassWordAction
{
    PResetPasswordViewController *resetPass_Ctr = [[PResetPasswordViewController alloc] initWithNibName:@"PResetPasswordViewController" bundle:nil];
    UINavigationController *nav_ctrl = [[UINavigationController alloc] initWithRootViewController:resetPass_Ctr];
    [self presentViewController:nav_ctrl animated:YES completion:nil];
}

#pragma mark - 我的消息、收藏，礼物
- (IBAction)headViewBtnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
            [self performSegueWithIdentifier:PMEVC_TO_PMMSGVC sender:self];
            break;
            
        case 1001:
            [self performSegueWithIdentifier:PMEVC_TO_PMYCOLLECTIONVC sender:self];
            break;
            
        case 1002:
            [self performSegueWithIdentifier:PMEVC_TO_PMYPRESENTVC sender:self];
            break;
            
        default:
            break;
    }
}

#pragma mark - 登录
- (void)loginAction
{
    UIStoryboard *drama_storyboard = [UIStoryboard storyboardWithName:PLOGIN_STORYBOARD bundle:[NSBundle mainBundle]];
    UIViewController *loginVC = drama_storyboard.instantiateInitialViewController;
    [self presentViewController:loginVC animated:YES completion:^{}];
    
}


#pragma mark - 上传头像

- (void)uploadAvaterImage
{
    [self showHudWithAnimated:YES];
    [GCDQueue executeInMainQueue:^{
        //[_hud hide];
    }afterDelaySecs:3.0];
    
}

#pragma mark - UITableViewDelegare

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifer = @"PMeCellHeadView";
    PMeCellHeadView *view = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (view==nil) {
        view = [PMeCellHeadView initWithNib];
        
        WS(weakSelf);
        view.videoCaptureBlock = ^{
            [weakSelf videoCaptureAction];
        };
    }
    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMeTableViewCell"];
    [cell cellWithIndexPath:indexPath data:_dataArray];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *textContent = [_dataArray objectAtIndex:indexPath.row];
    PDebugLog(@"%@",textContent);
    
    MPMoviePlayerSubViewController* playerView = [[MPMoviePlayerSubViewController alloc] initWithContentURL:[NSURL URLWithString:MP4_8]];//MP6_6
    
    UINavigationController *navCon  = [[UINavigationController alloc] init];
    navCon.navigationBarHidden      = YES;
    
    [navCon pushViewController:playerView animated:NO];
    [self presentViewController:navCon animated:YES completion:nil];
}

#pragma mark - 去掉多余的线
- (void)clipExtraCellLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
