//
//  PBeautyViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyViewController.h"
#import "PBeautyCollectionCell.h"
#import "PBeautyCollectionHeadView.h"
#import "PBeautyDetailViewController.h"

@interface PBeautyViewController ()<searchForDataDelegate>
{
    PSearcherView *_searchView;
}
@property (strong,nonatomic)NSMutableArray *datas;
@property (weak, nonatomic )IBOutlet UICollectionView *pBeautyColltionView;
@end

@implementation PBeautyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addsubViews];
    [self fetchData];
}

- (void)fetchData
{
    self.datas = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i ++) {
        [ self.datas addObject:[UIImage imageNamed:[NSString stringWithFormat:@"明星图片%d",i]]];
    }
    
    [self.pBeautyColltionView reloadData];
}

- (void)addsubViews
{
    _searchView = [PSearcherView initNib];
    _searchView.textLabel.text = @"玩美";
    _searchView.delegate = self;
    
    CGRect searchFrame  = (CGRect){CGPointMake(25.,0.),UIScreenWidth -25,44};
    _searchView.frame   = searchFrame;
    UIBarButtonItem *selectionItem = [[UIBarButtonItem alloc] initWithCustomView:_searchView];
    self.navigationItem.rightBarButtonItems = @[selectionItem];
    
    UINib *nib = [UINib nibWithNibName:@"PBeautyCollectionCell"
                                bundle:[NSBundle mainBundle]];
    [_pBeautyColltionView registerNib:nib
           forCellWithReuseIdentifier:@"PBeautyCollectionCell"];
    
    [_pBeautyColltionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_pBeautyColltionView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    
    //[_pBeautyColltionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"Cell"];
    
    // [_pBeautyColltionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
}

- (void)headerRereshing
{
    [self endRefreshing];
}

- (void)endRefreshing
{
    [_pBeautyColltionView headerEndRefreshing];
    [_pBeautyColltionView footerEndRefreshing];
}

- (void)footerRereshing
{
    [self endRefreshing];
}


- (void)searchForData:(NSString *)text
{
    
}



#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
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
    static NSString * CellIdentifier = @"PBeautyCollectionCell";
    
    PBeautyCollectionCell * cell = \
    [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                              forIndexPath:indexPath];
    cell.headImgView.image      = self.datas[indexPath.item];
    cell.presentImgView.image   = [UIImage imageNamed:@"beautyBarPresent_up"];
    [cell.priseBtn setBackgroundImage:[UIImage imageNamed:@"beautyLike"]
                             forState:UIControlStateNormal];
    
    if (indexPath.item %2 ==0) {
        cell.leftView.backgroundColor   = RGB(0x4cb17c, 1);
    }else{
        cell.leftView.backgroundColor   = RGB(0xe9ca5d, 1);
    }
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // return CGSizeMake(UIScreenWidth/2, UIScreenWidth/2);//146,178
    return CGSizeMake(UIScreenWidth/2-14, UIScreenWidth/2 +18);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark --UICollectionViewDelegate
//回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:PBEAUTYVC_TO_OBEAUTYDETAILVC sender:@""];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PBeautyDetailViewController *ctr = (PBeautyDetailViewController *)segue.destinationViewController;
    NSString *textContent   = (NSString *)sender;
    ctr.beautyId            = textContent;
}



-(CGFloat )collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    if (kind == UICollectionElementKindSectionHeader){
//        
//        PBeautyCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        
//        headerView.maleImgView.image   = [UIImage imageNamed:@"beautyBoy"];
//        headerView.femaleImgView.image = [UIImage imageNamed:@"beautyGirl"];
//        
//        [headerView feframe];
//        
//        reusableview = headerView;
//    }
//    if (kind == UICollectionElementKindSectionFooter){}
//    return reusableview;
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchView.searchTextField resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
