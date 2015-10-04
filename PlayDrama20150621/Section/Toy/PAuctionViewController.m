//
//  PAuctionViewController.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/15.
//  Copyright (c) 2015年 times. All rights reserved.
//

#define kPauctionViewHeight         (UIScreenHeight - 20 -44 - 40 -49)//状态栏H－navgationH - 滑动条H－tabbarH
#define kTableHeadSectionHight      (kPauctionViewHeight / 3.0 - 70)
#define kTableImageSectionHight     (kPauctionViewHeight / 3.0 - 20)
#define kTableAuctionSectionHight   (kPauctionViewHeight / 3.0 + 90)
#define KPauctionOffset             (kTableHeadSectionHight + kTableImageSectionHight)

#import "PAuctionViewController.h"
#import "PAuctionInfoView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Size.h"
#import "PAuctionBottomCell.h"
#import "PAuctionImageCell.h"
#import "PAuctionHeadCell.h"
#import "PAuctionInfoCell.h"

#import "PSocketLogic.h"
#import "PAuctionEntity.h"
#import "PUserEntity.h"

@interface PAuctionViewController ()<UITableViewDataSource,UITableViewDelegate,PDramaDelegate>

@property (strong, nonatomic)PAuctionInfoView     *auctionInfoView;     //拍卖数据
@property (strong ,nonatomic)UITableView          *tableView;
@property (strong,nonatomic )PAuctionEntity        *pauctionEntity;
@property (strong,nonatomic )PUserEntity           *userEntity;
@property (strong,nonatomic )NSMutableArray        *userDatas;
@end

@implementation PAuctionViewController

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
    [self socketInit];
    [self initData];
}

- (void)initData
{
    self.pauctionEntity = [PAuctionEntity new];
    self.pauctionEntity.goodsName = @"法拉利超级跑车";
    self.pauctionEntity.goodsImageUrl =@"商品详情-车";// @"http://c.pic1.ajkimg.com/display/anjuke/fc2186fcadd6f0779685c3c6c77a5776/600x450.jpg";
    self.pauctionEntity.startTime = @"10:00";
    self.pauctionEntity.maxPrice = @"10000";
    self.pauctionEntity.initiatePrice = @"100";
    self.pauctionEntity.isExpand        = NO;
    [self initUserData];
    
    [self.tableView reloadData];
}

- (void)initUserData
{
    for (int i = 0; i < 10; i ++) {
        self.userEntity = [PUserEntity new];
        self.userEntity.userName = @"10000";
        self.userEntity.faceUrl  = @"http://c.pic1.ajkimg.com/display/anjuke/fc2186fcadd6f0779685c3c6c77a5776/600x450.jpg";
       
        [self.userDatas addObject:self.userEntity];
    }
}

- (void)setupSubviews
{
    self.tableView                  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, kPauctionViewHeight) style:UITableViewStylePlain];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    //拍卖数据
    _auctionInfoView        = [PAuctionInfoView initNib];
    [self.view addSubview:_auctionInfoView];
    _auctionInfoView.frame  = CGRectMake(0, kPauctionViewHeight, UIScreenWidth,KPauctionOffset);
     self.view.frame        = CGRectMake(0, 0, UIScreenWidth,
                                         kPauctionViewHeight+ KPauctionOffset);
}

- (void)socketInit
{
    [PSocketLogic sharedInstance].socketHost = @"192.186.100.21";// host设定
    [PSocketLogic sharedInstance].socketPort = 10045;// port设定
    
    // 在连接前先进行手动断开
    [PSocketLogic sharedInstance].socket.userData = SocketOfflineByUser;
    [[PSocketLogic sharedInstance] cutOffSocket];
    
    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    [PSocketLogic sharedInstance].socket.userData = SocketOfflineByServer;
    [[PSocketLogic sharedInstance] socketConnectHost];
}

- (NSMutableArray *)userDatas
{
    if (_userDatas == nil) {
        _userDatas = [[NSMutableArray alloc]init];
    }
    return _userDatas;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3 && self.userDatas.count) {
        static NSString *cellIdentifer = @"PAuctionInfoHeadCell";
        UIView *view = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (view==nil) {
            view = [[NSBundle mainBundle]loadNibNamed:@"PAuctionInfoHeadCell"
                                                owner:nil
                                              options:nil].firstObject;
        }
        return view;
    }
    return  nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section ==0) {
        height = kTableHeadSectionHight;
    }else if (indexPath.section == 1){
        height = kTableImageSectionHight ;
    }else {
        height = kTableAuctionSectionHight;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *headCellIndentiler = @"PAuctionHeadCell";
    static NSString *imageCellIndentiler= @"PAuctionImageCell";
    static NSString *bottomIndentiler   = @"PAuctionBottomCell";
    
    if (indexPath.section == 0) {
       PAuctionHeadCell * cell = [PAuctionHeadCell tableView:tableView dequeueReusableCellWithIdentifier:headCellIndentiler];
        cell.auctionEntity = self.pauctionEntity;
        return cell;
        
    }else if(indexPath.section == 1){
         PAuctionImageCell * cell = [PAuctionImageCell tableView:tableView dequeueReusableCellWithIdentifier:imageCellIndentiler];
        cell.auctionEntity = self.pauctionEntity;
        return cell;
        
    }else{
        PAuctionBottomCell * cell = [PAuctionBottomCell tableView:tableView dequeueReusableCellWithIdentifier:bottomIndentiler];
        cell.delegate       = self;
        cell.auctionEntity  = self.pauctionEntity;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)showAuctionData
{
    self.tableView.scrollEnabled = !self.pauctionEntity.isExpand;
    
    CGFloat height = self.pauctionEntity.isExpand ? kPauctionViewHeight +KPauctionOffset:kPauctionViewHeight;
    _auctionInfoView.datas = self.userDatas;
    [_auctionInfoView.tableView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat marginY     = self.pauctionEntity.isExpand ? -KPauctionOffset:0;
        CGRect frame        = self.view.frame;
        frame.size.height   = height;
        frame.origin.y      = marginY ;
        self.view.frame     = frame;
    }];
}


#pragma mark - 数据显示详情
- (void)tableViewCellClickWithView:(id )view indexPath:(NSIndexPath *)indexPath
{
    [self showAuctionData];
}

#pragma mark - 拍卖发送命令
- (void)tableViewCellClickInCell:(UITableViewCell *)cell
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
@end
