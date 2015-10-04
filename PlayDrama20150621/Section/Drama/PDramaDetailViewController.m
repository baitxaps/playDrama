//
//  PDramaDetailViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/4/12.
//  Copyright (c) 2015年 times. All rights reserved.
//
#define kInputViewHeight  44
#define kNavHeight        20+44
#define kBottomBarHeight  47
#define kTableViewY       222
#define kBottomBarY       UIScreenHeight - kBottomBarHeight-kNavHeight
#define kTableViewHeight  UIScreenHeight - kNavHeight - kBottomBarHeight -kTableViewY;

#import "PTabEntity.h"
#import "PBottomEntity.h"
#import "PTabControlView.h"
#import "PBottonEntityAdapter.h"
#import "PDramaCommentEntity.h"
#import "PDramaEntity.h"

#import "PShareToolsView.h"
#import "AppDelegate.h"
#import "PDramaDetailViewController.h"
#import "PCustomerBottomBar.h"
#import "PBeautyEntityAdapter.h"
#import "PDramaDetailMovieInFoCell.h"
#import "PSystemSettingScreenLock.h"
#import "FFmpegPlayer.h"
#import "PKeyBoardView.h"
#import "PCommentsTableViewCell.h"
#import "PDramaDetailChapterCell.h"

@interface PDramaDetailViewController () <PShareToolsDelegate,PKeyBoardViewDelegate,UITableViewDataSource,UITableViewDelegate,PDramaDelegate>
{
    AppDelegate              *_app ;
    PTabControlView          *_tabView;
    PKeyBoardView           *_inputView;
}
@property (weak,  nonatomic) IBOutlet UITableView    *dramaDetailTableView;
@property (weak,  nonatomic) IBOutlet UIView         *dramaHeadView;
@property (strong,nonatomic) PCustomerBottomBar     *bottombar;
@property (strong,nonatomic) PShareToolsView        *shareTools;
@property (strong,nonatomic) FFmpegPlayer           *ffmpegPlayer;
@property (strong,nonatomic) PBeautyEntityAdapter   *tabAdapter;
@property (assign,nonatomic) TabInformationType     tabInfomationType;

@property (strong,nonatomic) PDramaEntity          *dramaEntity;
@property (strong,nonatomic) NSMutableArray        *commentData;

@property (strong,nonatomic) NSDictionary          *selectorDict;
@property (strong,nonatomic) NSArray               *keys;
@end

@implementation PDramaDetailViewController

- (void)dealloc
{
    PDebugLog(@"----%s-----",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTabData];
    [self addNav];
    [self addSubViews];
    self.tabInfomationType = StarInformationTypeResumeType;
    
    self.selectorDict =@{
                         @"tripbe": MP4_1,              //tripbe
                         @"qeebu" : MP4_2,              //qeebu
                         @"santai.tv":  MP4_8,          //santai.tv
                         @"BigBuckBunny":  MP4_7,       //BigBuckBunny
                         @"BigBuckBunny.rtsp": MP4_4,   //krtv.qiniudn.com
                         @"krtv.qiniudn.com":MP4_6      //krtv.qiniudn.com
                         };
    
    [self addData];
    
    self.keys    = [self.selectorDict allKeys];
}

//加载Tab选项卡数据
- (void)loadTabData
{
    PTabEntity *tabEntity = [[PTabEntity alloc]init];
    tabEntity.tabOne            = @"详情";
    tabEntity.tabTwo            = @"评论";
    tabEntity.tabThree          = @"章节";
    tabEntity.buttonTintColor   = RGBAColor(96, 174, 243, 1);
    tabEntity.backgroundColor   = RGB(0xd8d8d8, 1);
    self.tabAdapter = [[PBeautyEntityAdapter alloc]initWithData:tabEntity];
}

//加载底部Tab条数据
- (PBottomAdapter *)loadBottomData
{
    PBottomEntity *bottomEntity       = [[PBottomEntity alloc]init];
    bottomEntity.bottomTabOneImage    = [UIImage imageNamed:@"beautyBarLike_up"];
    bottomEntity.bottomTabTwoImage    = [UIImage imageNamed:@"drama_collection_up"];
    bottomEntity.bottomTabThreeImage  = [UIImage imageNamed:@"beautybarComments_up"];
    bottomEntity.bottomTabTwoSelectedImage = [UIImage imageNamed:@"drama_collection_down"];
    bottomEntity.backGroundColor      = RGBAColor(96, 174, 243, 1);
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
    for (int i = 0; i < 1; i ++) {
        PDramaCommentEntity *commentEntity = [PDramaCommentEntity new];
        commentEntity.fUserFaceUrl = @"http://a.hiphotos.baidu.com/image/pic/item/908fa0ec08fa513dee943c09396d55fbb2fbd92f.jpg";
        commentEntity.fromUserName = @"RHC";
        commentEntity.level  = @"lv.7";
        commentEntity.content=@"极客头条新版上线已经一个月，其间大家对新版极客头条给出了不少改进建议和意见，特此感谢！为了更加深入了解各位社区成员的亲身使用感悟，为未来的极客头条产品改进提供重要参考，特举办面向全体社区成员的 极客头条使用体验征文活动。希望各位社区成员尽情地用博文向我们说出您使用极客头条的感觉。";
        
        [self.commentData addObject:commentEntity];
        
        if (i ==0) {
            self.dramaEntity = [[PDramaEntity alloc]init];
            self.dramaEntity.movieName = @"金钢侠";
            self.dramaEntity.movieDist = @"海外";
            self.dramaEntity.movieType = @"古装/爱情/传奇";
            self.dramaEntity.movieYear = @"2016";
            self.dramaEntity.moviePlayCount = @"100万";
            self.dramaEntity.movieDesc =  @"试试点击列表中的星星,将好友设为星标联系人吧！设为星标联系人后，该联系人将添加至收件箱的左侧栏，可以很方便的查看他们的往来邮件。左侧栏的联系组也可以设为星标联系组哦!";
        }
    }
    [self.dramaDetailTableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_ffmpegPlayer viewDidAppear];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_ffmpegPlayer viewWillDisappear];
}

- (void)addNav
{
    UIBarButtonItem *leftItem =\
    [[UIBarButtonItem alloc]initWithText:NSLocalizedString(self.movieName, nil)
                                  target:self
                                  action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightBarItem =\
    [[UIBarButtonItem alloc]initWithNavigationItem:self.navigationItem
                                            target:self
                                            action:@selector(shareAction:)
                                       bgImgString:@"share"];
    self.navigationItem.rightBarButtonItems = @[rightBarItem];
    self.navigationController.navigationBar.barTintColor = RGB(0x242525, 0.75);
}

- (void)addSubViews
{
    //1 底部条
    _bottombar = [PCustomerBottomBar initNib];
    [_bottombar setFrame:CGRectMake(0, kBottomBarY, UIScreenWidth, kBottomBarHeight)];
    [self.view addSubview:_bottombar];
    [_bottombar setDelegate:self];
    [_bottombar loadData:[self loadBottomData]];
    
    //2 分享视图
    _shareTools                     = [PShareToolsView initNib];
    _shareTools.withController_     = self;
    
    //3 tableView frame
    CGRect tFrame                   = self.dramaDetailTableView.frame;
    tFrame.size.height              = kTableViewHeight;
    tFrame.origin.y                 = kTableViewY;
    self.dramaDetailTableView.frame = tFrame;
    self.dramaDetailTableView.backgroundColor = RGB(0xd8d8d8, 1);
    [_dramaDetailTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self clipExtraCellLine:self.dramaDetailTableView];
    
    //4 ffmpegPlayer
    WS(weakSelf);
    _ffmpegPlayer                   = [FFmpegPlayer initNib];
    CGRect mpFrame                  = _ffmpegPlayer.frame;
    mpFrame.size.width              = UIScreenWidth;
    _ffmpegPlayer.frame             = mpFrame;
    _ffmpegPlayer.viewController    = self;
    [self.view addSubview: _ffmpegPlayer];

    NSDictionary *parameters = @{@"KxMovieParameterMinBufferedDuration" :@(5.0),
                                 @"KxMovieParameterDisableDeinterlacing":@(YES)};
    [_ffmpegPlayer playWithContentPath:MP4_9 parameters:parameters];
    [weakSelf.ffmpegPlayer.movieTextLabel setText:weakSelf.movieName];
    
    _ffmpegPlayer.limitFullScreenBlock= ^(BOOL isFullScreen){
        //ios 7 与ios 8 不同
        if (isFullScreen) {
            [weakSelf resizePlayerFrame:isFullScreen];
            [weakSelf limitRotateScreen:isFullScreen];
        }else{
            [weakSelf limitRotateScreen:isFullScreen];
            [weakSelf resizePlayerFrame:isFullScreen];
        }
    };
    
    //5 inputView
    _inputView = [[PKeyBoardView alloc] initWithFrame:CGRectMake(0,
                                                                 UIScreenHeight,
                                                                 UIScreenWidth,
                                                                 kInputViewHeight)];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];
}


- (void)resizePlayerFrame:(BOOL)isFullScreen
{
    if (isFullScreen) {
        CGRect frame                        = _ffmpegPlayer.frame;
        frame.size.height                   = UIScreenWidth;
        frame.size.width                    = UIScreenHeight;
        _ffmpegPlayer.frame                 = frame;
        
    }else{
        _ffmpegPlayer.frame = self.dramaHeadView.frame;
    }
    _tabView.hidden                         = isFullScreen;
    self.dramaDetailTableView.scrollEnabled =!isFullScreen;
    [_ffmpegPlayer hidetopContainerView:!isFullScreen];
}

- (void)backAction
{
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _app.allowRotation = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadData
{
    [self.dramaDetailTableView reloadData];
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_inputView setInputBarViewResignFirstResponder];
}


#pragma mark -footRereshing
- (void)footerRereshing
{
    BOOL serviceHasMore = [self currentServiceHasMore];
    if (!serviceHasMore)
    {
        [self endRefreshing];
        [self.view makeToast:NSLocalizedString(@"没有更多记录了", nil) duration:1.0 position:@"bottom" tag:10010];
        return;
    }
}



- (BOOL)currentServiceHasMore
{
    BOOL moreData = NO;
    return moreData;
}


- (void)endRefreshing
{
    [_dramaDetailTableView footerEndRefreshing];
    
}

#pragma mark -  YcKeyBoardViewDelegate
-(void)keyBoardViewHide:(PKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    //发评论接口请求
    PDramaCommentEntity *commentEntity = [PDramaCommentEntity new];
    commentEntity.fUserFaceUrl = @"http://a.hiphotos.baidu.com/image/pic/item/908fa0ec08fa513dee943c09396d55fbb2fbd92f.jpg";
    commentEntity.fromUserName = @"RHC";
    commentEntity.level  = @"lv.7";
    commentEntity.content=contentView.text;
    
    [self.commentData insertObject:commentEntity atIndex:0];
    [self.dramaDetailTableView reloadData];
}

#pragma mark - PShareToolsDelegate

- (void)bottomBarActionDelegateShareType:(PBottomBarType)barType
{
    switch (barType) {
        case PBottomBarTypeLike://点赞接口请求
        {
            //todo
            
        }
            break;
            
        case PBottomBarTypeCollection://收藏接口请求
        {
            
        }
            break;
            
        case PBottomBarTypeForwarding://发评论键盘激活
        {
            [self startInfoType:StarInformationTypeLeaveAMSGType];
            [_inputView.msgTextView becomeFirstResponder];
        }
            break;
            
            
        default:
            break;
    }
}


- (void)tableViewCellClickInCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.dramaDetailTableView indexPathForCell:cell];
    PDebugLog(@"%@",self.commentData[indexPath.row]);
}


#pragma mark - cell中点击评论

- (void)tableViewCommentsCell:(UITableViewCell *)cell
{
    [_inputView.msgTextView becomeFirstResponder];
    NSIndexPath *indexPath = [self.dramaDetailTableView indexPathForCell:cell];
    PDebugLog(@"%@",self.commentData[indexPath.row]);
}



#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifer = @"PBeautyTableViewHeadView";
    _tabView    = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
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
    NSInteger height = 0;
    if (self.tabInfomationType == StarInformationTypeResumeType) {
        PDramaDetailMovieInFoCell *cell = [PDramaDetailMovieInFoCell loadCell];
        height =  [cell tableViewWithData:self.dramaEntity heightForRowAtIndexPath:indexPath];
        
    }else if(self.tabInfomationType ==StarInformationTypeLeaveAMSGType ){
        PCommentsTableViewCell *cell = [PCommentsTableViewCell loadCell];
        
        height=  [cell tableViewWithData:self.commentData[indexPath.row]
                 heightForRowAtIndexPath:indexPath];
    }else if(self.tabInfomationType == StarInformationTypePresentType){
        height = 44;
    }
    return height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (self.tabInfomationType == StarInformationTypeResumeType) {
        count = 1;
    }else if(self.tabInfomationType ==StarInformationTypeLeaveAMSGType ){
        count = self.commentData.count;
    }else if(self.tabInfomationType ==StarInformationTypePresentType){
        count = self.selectorDict.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailCellIdentifer       = @"PDramaDetailTableViewCel";
    static NSString *cellChapterIdentifer      = @"cellChapterIdentifer";
    static NSString *commentCellIdentifer      = @"PDramaCommentCell";
    
    switch (self.tabInfomationType ){
        case StarInformationTypeResumeType://影片详情
        {
            PDramaDetailMovieInFoCell  *cell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifer];
            if (cell == nil) {
                cell                = [PDramaDetailMovieInFoCell loadCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.dramaEntity        = self.dramaEntity;
            return cell;
            
        }
            break;
            
        case StarInformationTypeLeaveAMSGType://影片评论
        {
            PCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifer];
            if (cell == nil) {
                cell                = [PCommentsTableViewCell loadCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate       = self;
            }
            cell.data               = self.commentData[indexPath.row];
            return cell;
        }
            break;
            
        case StarInformationTypePresentType: //影片章节
        {
            PDramaDetailChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellChapterIdentifer];
            if (cell == nil) {
                cell = [PDramaDetailChapterCell initCellWithNib];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.movieName = self.keys[indexPath.row];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSString *textContent = [_dataArray objectAtIndex:indexPath.row];
    //PDebugLog(@"%@",textContent);
    //[self performSegueWithIdentifier:PDRAMAVC_TO_PDRAMADETAILVC sender:textContent];
    
    if (self.tabInfomationType == StarInformationTypePresentType) {
        
        NSString *key = self.keys[indexPath.row];
    
        [_ffmpegPlayer selectorWithUrl:self.selectorDict[key]];
    }
}

- (void)clipExtraCellLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



#pragma mark - share

- (void)shareAction:(id)sender
{
    [_shareTools show];
}

#pragma mark- 旋转处理屏幕适配问题

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  YES;
}

//返回最上层的子Controller的supportedInterfaceOrientations

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_app.allowRotation) {
        return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void) limitRotateScreen:(BOOL)isRotate
{
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //强制转屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        _app.allowRotation = isRotate ?YES:NO;
        UIInterfaceOrientation orientation = isRotate ? UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft:UIInterfaceOrientationPortrait;
        //[PSystemSettingScreenLock fullscreenMode:NO];
        [PSystemSettingScreenLock screenLock:isRotate];
        [self navigationHidden:isRotate];
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)navigationHidden:(BOOL)hidden
{
    [self.navigationController setNavigationBarHidden:hidden animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)unwindSegueToRedViewController:(UIStoryboardSegue *)segue {
    
}

@end
