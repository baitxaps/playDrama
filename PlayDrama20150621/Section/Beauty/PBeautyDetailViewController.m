//
//  PBeautyDetailViewController.m
//  PlayDrama
//
//  Created by RHC on 15/6/24.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyDetailViewController.h"
#import "PShareToolsView.h"
#import "PBeautyDetailHeadView.h"
#import "PTabControlView.h"
#import "PCustomerBottomBar.h"
#include "PBeautyDetailResumeCell.h"
#import "PCommentsTableViewCell.h"
#import "PBeautyDetailPresentCell.h"
#import "PKeyBoardView.h"
#import "PToyDetailViewController.h"

#import "PBeautyEntity.h"
#import "PBeautyCommentEntity.h"

#import "PTabEntity.h"
#import "PBeautyEntityAdapter.h"
#import "PBottomEntity.h"
#import "PBottonEntityAdapter.h"


@interface PBeautyDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PShareToolsDelegate,PKeyBoardViewDelegate,PDramaDelegate>
{
    PBeautyDetailHeadView    *_headView;
    PCustomerBottomBar       *_bottombar;
    PTabControlView          *_tabView;
    PKeyBoardView           *_inputView;
}

@property (weak,  nonatomic) IBOutlet UITableView   *detailTableView;
@property (assign ,nonatomic) TabInformationType    tabInfomationType;
@property (strong ,nonatomic) PBeautyEntity         *beautyEntity;
@property (strong ,nonatomic) PTabAdapter           *tabAdapter;
@property (strong,nonatomic) NSMutableArray         *commentData;

@end

@implementation PBeautyDetailViewController

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTabData];
    [self addData];
    [self loadBottomData];
    [self addNav];
    [self setupSubViews];
}

//加载Tab数据
- (void)loadTabData
{
    PTabEntity *tabEntity = [[PTabEntity alloc]init];
    tabEntity.tabOne            = @"简历";
    tabEntity.tabTwo            = @"留言";
    tabEntity.tabThree          = @"已有礼物";
    tabEntity.buttonTintColor   = RGBAColor(250, 164, 164, 1);
    tabEntity.backgroundColor   = RGB(0xd8d8d8, 1);
    self.tabAdapter = [[PBeautyEntityAdapter alloc]initWithData:tabEntity];
}


//加载底部Tab条数据
- (PBottomAdapter *)loadBottomData
{
    PBottomEntity *bottomEntity       = [[PBottomEntity alloc]init];
    bottomEntity.bottomTabOneImage    = [UIImage imageNamed:@"beautyBarLike_up"];
    bottomEntity.bottomTabTwoImage    = [UIImage imageNamed:@"beautyBarPresent_up"];
    bottomEntity.bottomTabThreeImage  = [UIImage imageNamed:@"beautybarComments_up"];
    bottomEntity.backGroundColor      = RGBAColor(55, 211, 118, 1);
    PBottomAdapter *bottomAdapter     = [[PBottonEntityAdapter alloc]initWithData:bottomEntity];
    
    return bottomAdapter;
}


- (NSMutableArray *)commentData
{
    if (!_commentData) {
        _commentData = [NSMutableArray new];
    }
    return _commentData;
}

- (void)addData
{
    for (int i = 0; i < 2; i ++) {
        PBeautyCommentEntity *beautyEntity = [PBeautyCommentEntity new];
        beautyEntity.fUserFaceUrl =@"http://a.hiphotos.baidu.com/image/pic/item/908fa0ec08fa513dee943c09396d55fbb2fbd92f.jpg";
        
        
        beautyEntity.fromUserName = @"RHC";
        beautyEntity.level  = @"lv.7";
        beautyEntity.content= @"10.13";
        beautyEntity.content=@"极客头条新版上线已经一个月，其间大家对新版极客头条给出了不少改进建议和意见，特此感谢！为了更加深入了解各位社区成员的亲身使用感悟，为未来的极客头条产品改进提供重要参考，特举办面向全体社区成员的 极客头条使用体验征文活动。希望各位社区成员尽情地用博文向我们说出您使用极客头条的感觉。";
        
        [self.commentData addObject:beautyEntity];
        
        if (i == 1) {
            PBeautyEntity * bEntity = [PBeautyEntity new];
            bEntity.castHoroscope = @"animal";
            bEntity.castName = @"dev";
            bEntity.castJob = @"cast";
            bEntity.castHoroscope = @"tianxie";
            bEntity.precentDatas= [@[
                                     @"http://pic.dfhon.com/pictures/200912041016/dd8451_huang.jpg",
                                     @"http://pic4.nipic.com/20090724/1951702_065619013_2.jpg",
                                     @"http://pic4.nipic.com/20091201/1951702_084317003934_2.jpg"
                                     ]mutableCopy];
            
            self.beautyEntity = bEntity;
        }
    }
    [self.detailTableView reloadData];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNav
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithText:NSLocalizedString(@"明星详情", nil) target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)setupSubViews
{
    // 1.headView
    _headView               = [PBeautyDetailHeadView initWithNib];
    CGRect frame            = _headView.frame;
    _headView.frame         = CGRectMake(0, 0, UIScreenWidth, frame.size.height);
    _headView.imageArray    = @[
                                @"明星详情-范冰冰1",
                                @"明星详情-范冰冰2",
                                @"明星详情-范冰冰3",
                                //@"http://pic.dfhon.com/pictures/200912041016/dd8451_huang.jpg",
                                //@"http://pic4.nipic.com/20090724/1951702_065619013_2.jpg",
                               // @"http://pic4.nipic.com/20091201/1951702_084317003934_2.jpg"
                                ];
    _detailTableView.tableHeaderView = _headView;
    
    //2.底部视图PCustomerBottomBar,此控件很多地方复用，现改变按钮图片，标题
    _bottombar = [PCustomerBottomBar initNib];
    [_bottombar setFrame:CGRectMake(0,
                                    UIScreenHeight - _bottombar.frame.size.height -64,
                                    self.view.frame.size.width,
                                    _bottombar.frame.size.height)];
    [self.view addSubview:_bottombar];
    [_bottombar setDelegate:self];
    [_bottombar loadData:[self loadBottomData]];
    
    
    //3.tableView
    CGFloat tableH = UIScreenHeight - _bottombar.frame.size.height -64;
    self.detailTableView.frame           = CGRectMake(0, 0,self.view.frame.size.width ,tableH);
    self.detailTableView.backgroundColor = RGB(0xd8d8d8, 1);
    [self.detailTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self clipExtraCellLine: self.detailTableView];
    
    //4.inputView
    _inputView = [[PKeyBoardView alloc] initWithFrame:CGRectMake(0, UIScreenHeight, self.view.frame.size.width, 44)];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];
}

- (void)reloadData
{
    [self.detailTableView reloadData];
}

#pragma mark - 详情不同的类型
- (void)startInfoType:(NSInteger)type
{
    self.tabInfomationType = type;
    [self performSelector:@selector(reloadData)
               withObject:self
               afterDelay:.2];
    
    [_tabView updateWithListType:self.tabInfomationType];
    [_inputView setInputBarViewResignNoClearFirstResponder];
}


- (void)bottomBarActionDelegateShareType:(PBottomBarType)barType
{
    switch (barType) {
        case PBottomBarTypeLike://点赞
        {
            
        }
            break;
            
        case PBottomBarTypeCollection://礼物
        {
            [self.view makeToast:@"礼物" duration:1.0 position:@"center" tag:10010];
        }
            break;
            
        case PBottomBarTypeForwarding:
        {
            [self startInfoType:StarInformationTypeLeaveAMSGType];
            [_inputView.msgTextView becomeFirstResponder];
        }
            break;
            
        default:
            break;
    }
}



- (void)footerRereshing
{
    BOOL serviceHasMore = [self currentServiceHasMore];
    if (!serviceHasMore)
    {
        [self endRefreshing];
        [self.view makeToast:NSLocalizedString(@"没有更多记录了", nil) duration:1.0 position:@"bottom" tag:10010];
        return;
    }
    //    _refreshShowHud = NO;
    //    NSInteger page = pageCounter[_currentIndex];
    //    page ++;
    //    pageCounter[_currentIndex] = page;
    //    [self queryServiceList];
}



- (BOOL)currentServiceHasMore
{
    BOOL moreData = NO;
    
    // moreData = h
    return moreData;
}


- (void)endRefreshing
{
    [_detailTableView footerEndRefreshing];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifer = @"PBeautyTableViewHeadView";
    _tabView = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    WS(weakSelf);
    if (_tabView==nil) {
        _tabView =   [PTabControlView initWithNib];
        [_tabView loadData:self.tabAdapter];
        
        _tabView.startInfoTypeBlock = ^(NSInteger type){
            [weakSelf startInfoType:type];
        };
    }
    [_tabView updateWithListType:self.tabInfomationType];
    return _tabView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (self.tabInfomationType) {
        case StarInformationTypeResumeType:
            height = 220;
            break;
        case StarInformationTypeLeaveAMSGType:
        {
            PCommentsTableViewCell *cell = [PCommentsTableViewCell loadCell];
            
            height=  [cell tableViewWithData:self.commentData[indexPath.row]
                     heightForRowAtIndexPath:indexPath];
        }
            break;
            
        case StarInformationTypePresentType:
            height = 100;
            break;
            
        default:
            break;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    switch (self.tabInfomationType) {
        case StarInformationTypeResumeType:
            count = 1;
            break;
        case StarInformationTypeLeaveAMSGType:
            count = self.commentData.count;
            break;
            
        case StarInformationTypePresentType:
            count = self.beautyEntity.precentDatas.count;;
            break;
            
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer          = @"PBeautyDetailResumeCell";
    static NSString *cellMSgIdentifer       = @"PCommentsTableViewCell";
    static NSString *cellPresentIdentifer   = @"PBeautyDetailPresentCell";
    switch (self.tabInfomationType) {
        case StarInformationTypeResumeType:
        {
            PBeautyDetailResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
            if (cell == nil) {
                cell = [PBeautyDetailResumeCell loadCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.beautyEntity = self.beautyEntity;
            return cell;
        }
            break;
        case StarInformationTypeLeaveAMSGType:
        {
            PCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMSgIdentifer];
            if (cell == nil) {
                cell = [PCommentsTableViewCell loadCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate       = self;
            }
            cell.data = self.commentData[indexPath.row];
            return cell;
        }
            break;
        case StarInformationTypePresentType:
        {
            PBeautyDetailPresentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellPresentIdentifer];
            if (cell == nil) {
                cell = [PBeautyDetailPresentCell loadCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark - 进入用户中心

- (void)tableViewCellClickInCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.detailTableView indexPathForCell:cell];
    PDebugLog(@"%@", self.commentData[indexPath.row]);
}


#pragma mark - cell中点击评论

- (void)tableViewCommentsCell:(UITableViewCell *)cell
{
    [_inputView.msgTextView becomeFirstResponder];
    NSIndexPath *indexPath = [self.detailTableView indexPathForCell:cell];
    PDebugLog(@"%@", self.commentData[indexPath.row]);
}

#pragma mark - YcKeyBoardViewDelegate

-(void)keyBoardViewHide:(PKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    PBeautyCommentEntity *commentEntity = [PBeautyCommentEntity new];
    commentEntity.fUserFaceUrl = @"http://a.hiphotos.baidu.com/image/pic/item/908fa0ec08fa513dee943c09396d55fbb2fbd92f.jpg";
    commentEntity.fromUserName = @"RHC";
    commentEntity.level  = @"lv.7";
    commentEntity.content=contentView.text;
    
    [self.commentData insertObject:commentEntity atIndex:0];
    [self.detailTableView reloadData];
    //接口请求
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tabInfomationType ==StarInformationTypePresentType) {
        UIStoryboard *toyBoard = [UIStoryboard storyboardWithName: @"PToy" bundle:[NSBundle mainBundle]];
        
        PToyDetailViewController* toyVC = [toyBoard instantiateViewControllerWithIdentifier: @"toyDetailID"];
        //PresentEntity *presentEntity = self.datas[indexPath.row];
        //toyVC.joyId = presentEntity.imgUrl;
        [self.navigationController pushViewController:toyVC animated:YES];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_inputView setInputBarViewResignFirstResponder];
}

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
