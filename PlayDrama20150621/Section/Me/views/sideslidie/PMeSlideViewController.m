//
//  PMeSlideViewController.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/29.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMeSlideViewController.h"
#import "PMeSilderTableViewCell.h"
#import "PFindPassViewController.h"
#import "PLevelInFoViewController.h"
#import "PAboutDramaViewController.h"
#import "PUserEntity.h"
#import "PKeyChainHelper.h"

@interface PMeSlideViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSArray *datas;
@property (strong,nonatomic)NSArray *imgs;
@property (weak, nonatomic) IBOutlet UIImageView *logImageView;

@end

@implementation PMeSlideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //logImage
    CGRect logFrame         = self.logImageView.frame;
    CGFloat offset          = self.tableView.frame.size.width/4.0;
    CGFloat x               =(UIScreenWidth - 30)/2.0f -logFrame.size.width / 2.f +offset;
    logFrame.origin.x       = x;
    self.logImageView.frame = logFrame;
    
    //tableView
//    CGRect tabRect          = self.tableView.frame;
//    tabRect.size.height     = UIScreenHeight - logFrame.size.height -100 ;
//    self.tableView.frame    = tabRect;
    
    
    self.view.layer.contents = (__bridge id)([UIImage imageNamed:@"slider_BG"].CGImage);
    
    //[self.tableView drawBounderWidth:1 Color:[UIColor redColor]];
    
    //数据不够，去掉下面多余的表格线
    [self clipExtraCellLine:self.tableView];
    self.datas = @[@"帐户",
                   @"修改密码",
                  /* @"支付方式",*/
                   @"等级介绍",
                   @"关于玩剧",
                   @"退出登录"];
    
    self.imgs  = @[@"paccount",
                   @"pmodifypassword",
                   /*@"payment",*/
                   @"playmeLevel",
                   @"paccount",
                   @"pcomplain"];
    
  PDebugLog(@"currentDevice:%@",  [[PUserEntity sharedInstance]currentDeviceType]);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"PDramaTableViewCell";
    PMeSilderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell =  [PMeSilderTableViewCell loadCell];
    }
    
    [cell updateData:self.datas images:self.imgs indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 1://修必密码
            [self sliderSiderWithViewController:[[PFindPassViewController alloc] init]];
            break;

        case 2://等级介绍
            
            [self sliderSiderWithViewController:[[PLevelInFoViewController alloc] init]];
            break;
            
        case 3://关于玩剧
            
            [self sliderSiderWithViewController:[[PAboutDramaViewController alloc] init]];
            break;
            
        case 4://退出
        {
            [PVerifyFunc loginOut:self];
            [self destory];
            [self performSelector:@selector(hideMenuViewController) withObject:self afterDelay:.5];
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)destory
{
    //删除密码
    //[PKeyChainHelper deleteWithUserNameService:KEY_USERNAME psaawordService:KEY_PASSWORD];
    
    [PKeyChainHelper  deletePsaawordService:KEY_PASSWORD];
    PUserEntity *Puser = [PUserEntity sharedInstance];
    [Puser destroy];
    
}

#pragma mark -隐藏左边栏
- (void)hideMenuViewController
{
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDEMENUVIEWCONTROLLER object:nil];
}

#pragma mark -左栏侧滑
- (void)sliderSiderWithViewController:(UIViewController *)vc
{
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}


#pragma mark - 去掉多余的线
- (void)clipExtraCellLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
