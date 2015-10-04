//
//  PToyViewController.m
//  PlayDra。ma
//
//  Created by chenhairong on 15/3/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PToyViewController.h"
#import "PToyCollectionViewCell.h"
#import "PToyDetailViewController.h"
#import "PAuctionViewController.h"

#define kPToyCollectionViewTag    2008

@interface PToyViewController ()<searchForDataDelegate,UICollectionViewDelegate\
,UICollectionViewDataSource>
{
    PSearcherView *_searchView;
    NSInteger pageCounter[2] /*分页*/;
    BOOL      hasMore[2];   /*是否有更多*/;
}
@property (weak,   nonatomic) UICollectionView          *currentCollectionView;
@property (strong, nonatomic) PSegmentMenuView          *menuView;
@property (strong, nonatomic) UIScrollView              *scrollView;
@property (assign, nonatomic) NSInteger                 currentIndex;//当前选中的item
@property (assign, nonatomic) BOOL                      refreshShowHud;
@property (strong, nonatomic) PNoDataView           *noDataView;
@property (strong, nonatomic) NSMutableArray            *dataArray;
@property (strong, nonatomic) NSArray                   *imgs;

@end

@implementation PToyViewController

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSearch];
    [self addMenuItem];
    [_menuView setCurrentSelectedIndex:0];
    [self addScrollView];
    [self addNoDataView];
    
    self.imgs = @[
                  @"包", @"车",@"手表1",@"手表2",@"香水",@"香水2"
                  
                  
//                  @"http://a.hiphotos.baidu.com/image/pic/item/908fa0ec08fa513dee943c09396d55fbb2fbd92f.jpg",
//                  @"http://a.hiphotos.baidu.com/image/pic/item/377adab44aed2e7323bcd7fb8301a18b86d6fa94.jpg",
//                  @"http://e.hiphotos.baidu.com/image/pic/item/7c1ed21b0ef41bd5c16bb82355da81cb39db3d28.jpg",
//                  @"http://c.hiphotos.baidu.com/image/pic/item/fcfaaf51f3deb48fa6daf009f41f3a292cf578b1.jpg",
//                  @"http://f.hiphotos.baidu.com/image/pic/item/bd315c6034a85edfb845aff44d540923dc54751f.jpg",
//                  @"http://e.hiphotos.baidu.com/image/pic/item/d833c895d143ad4b553d10e787025aafa40f0681.jpg",
                  ];
}

- (void)addSearch
{
    _searchView = [PSearcherView initNib];
    _searchView.textLabel.text   = @"玩具";
    _searchView.delegate         = self;
    
    CGRect searchFrame =   (CGRect){CGPointMake(25.,0.),UIScreenWidth -25,44};
    _searchView.frame   = searchFrame;
    UIBarButtonItem *selectionItem = \
    [[UIBarButtonItem alloc] initWithCustomView:_searchView];
    
    self.navigationItem.rightBarButtonItems = @[selectionItem];
}

- (void)addMenuItem
{
    _menuView =\
    [[PSegmentMenuView alloc] initWithFrame:CGRectMake(0.0,
                                                       0,
                                                       UIScreenWidth,
                                                       kGOSegmentMenuViewH)
                                       type:GOMenuContentTypeContentWithUnreadMark];
    _menuView.maxItemsCountPerPage  = 3;
    _menuView.selectColor           = RGB(0xf7653e, 1);// f6e60d
    _menuView.menuItemArray         = [NSMutableArray arrayWithArray:
                                       @[NSLocalizedString(@"新品", nil),
                                         NSLocalizedString(@"拍卖", nil),
                                         NSLocalizedString(@"热门", nil)
                                         ]];
    
    __weak typeof(self) weakSelf    = self;
    _menuView.menuItemBlock = ^(NSInteger index){
        // 点击切换到其他子模块
        [weakSelf handleSlideToOtherType:index];
    };
    [self.view addSubview:_menuView];
}

- (void)addScrollView
{
    CGFloat scrollViewHeight = UIScreenHeight - 64.0 - 40;
    _scrollView = \
    [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                   kGOSegmentMenuViewH,
                                                   UIScreenWidth,
                                                   scrollViewHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(UIScreenWidth * 3, scrollViewHeight);
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UINib *nib = [UINib nibWithNibName:@"PToyCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    for (NSInteger i = 0; i < 3; i ++)
    {
        CGFloat orginX = i*UIScreenWidth;
        CGFloat orginY = 0;
        CGFloat tableH = scrollViewHeight;
        if (i ==1) {
            PAuctionViewController *pvc = \
            [[PAuctionViewController alloc]init];
            pvc.view.frame = CGRectMake(orginX, orginY, UIScreenWidth, tableH-49);
            [self addChildViewController:pvc];
            [_scrollView addSubview:pvc.view];
            continue;
        }
        
        UICollectionView *collectionView =\
        [[UICollectionView alloc] initWithFrame:CGRectMake(orginX, orginY,
                                                           UIScreenWidth,
                                                           tableH-49)
                           collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.backgroundView   = nil;
        collectionView.delegate         = self;
        collectionView.dataSource       = self;
        collectionView.tag = i + kPToyCollectionViewTag;
        [collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
        [collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
        [collectionView registerNib:nib
         forCellWithReuseIdentifier:@"PToyCollectionViewCell"];
        [_scrollView addSubview:collectionView];
        if (i == 0)
        {
            _currentCollectionView = collectionView;
        }
    }
}


- (void)addNoDataView
{
    _noDataView = [[PNoDataView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   UIScreenWidth,
                                                                   UIScreenHeight)];
    [_noDataView createNoDataView:@"" HaveAdd:NO];
    [_scrollView addSubview:_noDataView];
    _noDataView.hidden = YES;
}

- (BOOL)shouldRefresh
{
    BOOL shouldRefresh = YES;
    shouldRefresh = ![_dataArray[_currentIndex] count];
    _refreshShowHud = shouldRefresh;
    return shouldRefresh;
}

- (void)handleSlideToOtherType:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    weakSelf.currentIndex = index;
    weakSelf.noDataView.frame = CGRectMake(UIScreenWidth*index, 0,
                                           UIScreenWidth,
                                           UIScreenHeight);
    weakSelf.noDataView.hidden = YES;
    if (index == 1) {
        [_searchView hide];
        [weakSelf setScrollViewContentOffsetWithIndex:index];
        
    }else{
        [_searchView show];
        [weakSelf setCurrentTableBySelectedIndex:index];
        [weakSelf setScrollViewContentOffsetWithIndex:index];
        BOOL shouldRefresh = [weakSelf shouldRefresh];//本地有缓存就不刷新，让用户主动去刷新
        if (!shouldRefresh)
        {
            [weakSelf.currentCollectionView reloadData];
            return;
        }
        //[weakSelf performSelector:@selector(queryServiceList) withObject:nil afterDelay:0.3];
    }
}
- (void)setCurrentTableBySelectedIndex:(NSInteger)index
{
    UICollectionView *table = \
    (UICollectionView *)[_scrollView viewWithTag:index + kPToyCollectionViewTag];
    _currentCollectionView = table;
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



#pragma mark - UIScroll View

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_searchView textFieldResignFirstResponder];
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
        [self.view makeToast:NSLocalizedString(@"没有更多记录了", nil)
                    duration:1.0 position:@"bottom" tag:10010];
        return;
    }
    _refreshShowHud = NO;
    NSInteger page = pageCounter[_currentIndex];
    page ++;
    pageCounter[_currentIndex] = page;
    ///[self queryServiceList];
}

- (void)headerRereshing
{
    _refreshShowHud = NO;
    pageCounter[_currentIndex] = 1;
    //[self queryServiceList];
}

- (void)endRefreshing
{
    [_currentCollectionView headerEndRefreshing];
    [_currentCollectionView footerEndRefreshing];
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
    //  [_dataArray[_currentIndex] removeAllObjects];
}


#pragma mark - searchDataDelegate

- (void)searchForData:(NSString *)text
{
    if (![text length]) {
        [self.view makeToast:NSLocalizedString(@"请输入搜索关键字", nil)
                    duration:1.0 position:@"center" tag:10010];
        return;
    }
    PDebugLog(@"%@",text);
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.imgs.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PToyCollectionViewCell";
    
    PToyCollectionViewCell * cell = \
    [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                              forIndexPath:indexPath];
    
    cell.toyImgView.image = [UIImage imageNamed:self.imgs[indexPath.item]];
    
#if 0
    [cell.toyImgView sd_setImageWithURL:[NSURL URLWithString:self.imgs[indexPath.item]]
                             placeholderImage:[UIImage imageNamed:@"Default.png"]
                                      options:SDWebImageLowPriority | SDWebImageRetryFailed];
#endif
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDebugLog(@"w = %f,h = %f",UIScreenWidth, UIScreenHeight);
    return CGSizeMake(UIScreenWidth/2-14, UIScreenWidth/2 +18);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10, 10, 10);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"PTOYDETAIL" sender:self.imgs[indexPath.row]];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PToyDetailViewController *ctr = (PToyDetailViewController *)segue.destinationViewController;
    NSString *textContent   = (NSString *)sender;
    ctr.joyId               = textContent;
    //ctr.delegate            = (NSString *)sender;
}

#pragma mark - 取消键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchView.searchTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
