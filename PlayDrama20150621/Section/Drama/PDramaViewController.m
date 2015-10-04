//
//  DramaViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PDramaViewController.h"
#import "PDramaEntity.h"
#import "PDramaTableViewCell.h"
#import "PDramaDetailViewController.h"

const NSInteger kActivityTableTagBase   = 1000;
const NSInteger kActivityDataSize       = 10;
const NSInteger kPageSize               = 10;

@interface PDramaViewController ()<searchForDataDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL isStart;
    PSearcherView *_searchView;
    NSInteger pageCounter[5] /*分页*/;
    BOOL      hasMore[5];   /*是否有更多*/;
}
@property (assign, nonatomic) NSInteger                 currentIndex;//当前选中的item index
@property (assign, nonatomic)BOOL                       refreshShowHud;//标记是上拉下拉刷新（这时候不显示hud），还是第一次请求数据（显示hud）。
@property (strong, nonatomic) PNoDataView           *noDataView;
@property (nonatomic, strong) PSegmentMenuView          *menuView;
@property (nonatomic, strong) UIScrollView              *scrollView;
@property (nonatomic, strong) UITableView               *currentTable;
@property (nonatomic, strong) NSMutableArray            *dataArray;

@end

@implementation PDramaViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self addMenuItem];
    [self addScrollView];
    [self setStatues];
    [self addNoDataView];
    
    _dataArray = [@[@"绯闻女孩",@"暮光之城",@"全城戒备",@"指环王"]mutableCopy];
}


- (void)setupViews
{
    self.view.layer.contents =  (__bridge id)([UIImage imageNamed:@"toy_BG"].CGImage);
    
    _searchView                 = [PSearcherView initNib];
    _searchView.textLabel.text  = @"玩剧";
    _searchView.delegate        = self;
    _searchView.viewController  = self;
    
    CGRect searchFrame  = (CGRect){CGPointMake(25.,0.),UIScreenWidth -25,44};
    _searchView.frame   = searchFrame;
    UIBarButtonItem *selectionItem = [[UIBarButtonItem alloc] initWithCustomView:_searchView];
    
    //[selectionItem.customView drawBounderWidth:1 Color:[UIColor greenColor]];
    self.navigationItem.rightBarButtonItems = @[selectionItem];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setStatues
{
    _currentIndex   = 0;
    [self setScrollViewContentOffsetWithIndex:_currentIndex];
    [_menuView setCurrentSelectedIndex:_currentIndex];
    _dataArray = [NSMutableArray arrayWithCapacity:6];
    for (NSInteger i = 0; i < 6; i ++) {
        _dataArray[i]  = [NSMutableArray array];
        pageCounter[i] = 1;
        hasMore[i]     = YES;
    }
}



- (void)addMenuItem
{
    _menuView = [[PSegmentMenuView alloc] initWithFrame:CGRectMake(0.0, 0, UIScreenWidth, kGOSegmentMenuViewH) type:GOMenuContentTypeContentWithUnreadMark];
    _menuView.maxItemsCountPerPage = 6;
    _menuView.selectColor = RGB(0xf7653e, 1);//RGB(0xf6a126, 1);
    _menuView.menuItemArray = [NSMutableArray arrayWithArray:
                               @[NSLocalizedString(@"情感", nil),
                                 NSLocalizedString(@"侦探", nil),
                                 NSLocalizedString(@"动作", nil),
                                 NSLocalizedString(@"喜剧", nil),
                                 NSLocalizedString(@"最新", nil),
                                 NSLocalizedString(@"人气", nil)]
                               ];
    
    __weak typeof(self) weakSelf = self;
    _menuView.menuItemBlock = ^(NSInteger index){
        // 点击切换到其他子模块
        [weakSelf handleSlideToOtherType:index];
    };
    [self.view addSubview:_menuView];
}

- (void)addNoDataView
{
    _noDataView = [[PNoDataView alloc]initWithFrame:CGRectMake(0, 0,  UIScreenWidth,UIScreenHeight)];
    [_noDataView createNoDataView:@"" HaveAdd:NO];
    
    [_scrollView addSubview:_noDataView];
    _noDataView.hidden = YES;
}

- (void)handleSlideToOtherType:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    weakSelf.currentIndex = index;
    weakSelf.noDataView.frame = CGRectMake(UIScreenWidth*index, 0, UIScreenWidth, UIScreenHeight);
    weakSelf.noDataView.hidden = YES;
    [weakSelf setCurrentTableBySelectedIndex:index];
    [weakSelf setScrollViewContentOffsetWithIndex:index];
    BOOL shouldRefresh = [weakSelf shouldRefresh];//本地有缓存就不刷新，让用户主动去刷新
    if (!shouldRefresh)
    {
        [weakSelf.currentTable reloadData];
        return;
    }
    //[weakSelf performSelector:@selector(queryServiceList) withObject:nil afterDelay:0.3];
}

- (BOOL)shouldRefresh
{
    BOOL shouldRefresh = YES;
    // shouldRefresh = ![_dataArray[_currentIndex] count];
    _refreshShowHud = shouldRefresh;
    return shouldRefresh;
}

- (void)addScrollView
{
    CGFloat scrollViewHeight = UIScreenHeight - 64.0 - 40;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kGOSegmentMenuViewH, UIScreenWidth, scrollViewHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(UIScreenWidth * 6, scrollViewHeight);
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    for (NSInteger i = 0; i < 6; i ++)
    {
        CGFloat orginX = i*UIScreenWidth;
        CGFloat orginY = 0;
        CGFloat tableH = scrollViewHeight;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(orginX, orginY, UIScreenWidth, tableH-49) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (IS_IOS7)
        {
            tableView.separatorInset = UIEdgeInsetsMake(0.0, 90.0, 0.0, 0.0);
        }
        tableView.delegate      = self;
        tableView.dataSource    = self;
        tableView.tag = i + kActivityTableTagBase;
        [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        [_scrollView addSubview:tableView];
        if (i == 0)
        {
            _currentTable = tableView;
        }
    }
}

- (void)setCurrentTableBySelectedIndex:(NSInteger)index
{
    UITableView *table = (UITableView *)[_scrollView viewWithTag:index + kActivityTableTagBase];
    _currentTable = table;
}

- (void)setScrollViewContentOffsetWithIndex:(NSInteger)index
{
    CGPoint point = CGPointMake(index * UIScreenWidth, 0);
    [_scrollView setContentOffset:point animated:YES];
}

- (NSInteger)currentPage
{
    NSInteger currentPage = 1;
    currentPage = pageCounter[_currentIndex];
    return currentPage;
}

- (void)queryServiceList
{
    if (_refreshShowHud){
        [self showHudWithAnimated:YES];
    }else{
        //[_hud hide];;
    }
    
    
    NSInteger page = [self currentPage];
    __weak typeof(self) weakSelf = self;
    [PDramaEntity fetchDataWithFilm:@"RHC" sex:@"1" success:^(NSArray *dataA) {
        PDebugLog(@"%@",dataA);
       // [_hud hide];
        [weakSelf endRefreshing];
        //服务器返回有数据
        if (dataA && [dataA isKindOfClass:[NSArray class]]&& dataA.count)
        {
            _noDataView.hidden = YES;
            if (dataA.count < kPageSize)
            {
                [weakSelf setHasMoreWithBool:NO];
            }else
            {
                [weakSelf setHasMoreWithBool:YES];
            }
            [weakSelf handleServiceListDataWithArray:dataA];
            [_currentTable reloadData];
        }else
        {
            //服务器返回没有数据了
            if (page == 1)
            {
                [self.view makeToast:@"亲，暂无您所需要类型的套餐" duration:1.0 position:@"bottom" tag:10010];
                [_currentTable reloadData];
                _noDataView.hidden = NO;
            }else
            {
                [self.view makeToast:NSLocalizedString(@"没有更多记录了...", nil) duration:1.0 position:@"bottom" tag:10010];
            }
            [weakSelf setHasMoreWithBool:NO];
        }
        
        
    } failure:^(NSError *error) {
        PDebugLog(@"%@",error.localizedDescription);
        //[_hud hide];
        [weakSelf endRefreshing];
        [self.view makeToast:error.localizedDescription duration:1.0 position:@"bottom" tag:10010];
        [_currentTable reloadData];
        _noDataView.hidden = NO;
    }];
    
}

- (void)handleServiceListDataWithArray:(NSArray *)array
{
    NSMutableArray *repairShopDataA = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i ++)
    {
        NSDictionary *dic = array[i];
        if (dic && [dic isKindOfClass:[NSDictionary class]])
        {
            //GOGoodsEntity *tmpModel = [GOGoodsEntity convertDicToEntity:dic];
            //[repairShopDataA addObject:tmpModel];
        }
    }
    
    [_dataArray addObjectsFromArray:repairShopDataA];
}



#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 149.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _dataArray.count;
    return count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"PDramaTableViewCell";
    PDramaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PDramaTableViewCell" owner:self options:nil].firstObject;
    }
    [cell cellUpdateForData:_dataArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *textContent = [_dataArray objectAtIndex:indexPath.row];
    PDebugLog(@"%@",textContent);
    [self performSegueWithIdentifier:PDRAMAVC_TO_PDRAMADETAILVC sender:textContent];
    
//    PDramaDetailViewController *vc  = [[PDramaDetailViewController alloc] init];
//    [self presentViewController:vc animated:NO completion:^{
//        
//    }];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PDramaDetailViewController *ctr = (PDramaDetailViewController *)segue.destinationViewController;
    NSString *textContent   = (NSString *)sender;
    ctr.movieName           = textContent;
}
#pragma mark - UIScroll View

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView])
    {
        CGPoint point = scrollView.contentOffset;
        NSInteger index = point.x/UIScreenWidth;
        if (_currentIndex == index) return;
        _currentIndex = index;
        [_menuView setCurrentSelectedIndex:index];
    }
}

#pragma mark - refresh

- (void)footerRereshing
{
    BOOL serviceHasMore = [self currentServiceHasMore];
    if (!serviceHasMore)
    {
        [self endRefreshing];
        [self.view makeToast:NSLocalizedString(@"没有更多记录了", nil) duration:1.0 position:@"bottom" tag:10010];
        return;
    }
    _refreshShowHud = NO;
    NSInteger page = pageCounter[_currentIndex];
    page ++;
    pageCounter[_currentIndex] = page;
    [self queryServiceList];
}

- (void)headerRereshing
{
    _refreshShowHud = NO;
    pageCounter[_currentIndex] = 1;
    [self queryServiceList];
}

- (void)endRefreshing
{
    [_currentTable headerEndRefreshing];
    [_currentTable footerEndRefreshing];
}


- (BOOL)currentServiceHasMore
{
    BOOL moreData = NO;
    
    moreData = hasMore[_currentIndex];
    return moreData;
}

- (void)setHasMoreWithBool:(BOOL)moreData
{
    hasMore[_currentIndex] = moreData;
}

- (void)clearCurrentTableData
{
    [_dataArray[_currentIndex] removeAllObjects];
}

#pragma mark - searchDataDelegate

- (void)searchForData:(NSString *)text
{
    if (![text length]) {
        [self.view makeToast:NSLocalizedString(@"请输入搜索关键字", nil) duration:1.0 position:@"center" tag:10010];
        return;
    }
    
    if (isStart) {
       // [_hud hide];
    }else{
        [self showHudWithAnimated:YES];
        
    }
    isStart = !isStart;
    PDebugLog(@"%@",text);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  NO;
}

#pragma mark- 旋转处理屏幕适配问题
- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - 取消键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchView.searchTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
