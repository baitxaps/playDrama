//
//  PTicketViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillViewController.h"
#import "PBillCollectionCell.h"
#import "PBillDetailViewController.h"

@interface PBillViewController ()<searchForDataDelegate>
{
    PSearcherView *_searchView;
}
@property (strong,nonatomic)NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UICollectionView *billCollectionView;


@end

@implementation PBillViewController

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubvews];
    [self fetchData];
}


- (void)fetchData
{
    _datas = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 7; i ++) {
       [ _datas addObject:[UIImage imageNamed:[NSString stringWithFormat:@"玩票图片%d",i]]];
    }
    
    [self.billCollectionView reloadData];
}

- (void)setupSubvews
{
    //1.searchView
    _searchView = [PSearcherView initNib];
    _searchView.textLabel.text = @"玩票";
    _searchView.delegate        = self;
    CGRect searchFrame          =(CGRect){CGPointMake(25.,0.),UIScreenWidth -25,44};
    _searchView.frame           = searchFrame;
    UIBarButtonItem *selectionItem = \
    [[UIBarButtonItem alloc] initWithCustomView:_searchView];
    self.navigationItem.rightBarButtonItems =@[selectionItem];
    
    //2.register the collectionView
    UINib *nib = [UINib nibWithNibName:@"PBillCollectionCell"
                                bundle: [NSBundle mainBundle]];
    
    [_billCollectionView registerNib:nib
          forCellWithReuseIdentifier:@"PBillCollectionCell"];
    [_billCollectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_billCollectionView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)searchForData:(NSString *)text
{

}


- (void)headerRereshing
{
    [self endRefreshing];
}

- (void)endRefreshing
{
    [self.billCollectionView headerEndRefreshing];
    [self.billCollectionView footerEndRefreshing];
}

- (void)footerRereshing
{
    [self endRefreshing];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return 7;
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
    static NSString * CellIdentifier = @"PBillCollectionCell";
    
    PBillCollectionCell * cell = \
    [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                              forIndexPath:indexPath];
    cell.billImageView .image   = self.datas[indexPath.item];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // return CGSizeMake(UIScreenWidth/2,243);//243
   return CGSizeMake(UIScreenWidth/2-14, UIScreenWidth/2 +18);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    //(top.left .bottom.right)
    return UIEdgeInsetsMake(10,10, 10, 10);
}
#pragma mark --UICollectionViewDelegate
//回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:PBillVC_To_BillDetailVC sender:indexPath];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    PBillDetailViewController *ctr =\
    (PBillDetailViewController *)segue.destinationViewController;
    
    ctr.image = self.datas[sender.item];
    
}



-(CGFloat )collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - scrollViewWillBeginDragging

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchView.searchTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
