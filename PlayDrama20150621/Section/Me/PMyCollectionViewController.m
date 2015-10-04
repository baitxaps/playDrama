//
//  PMyCollectionViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/4/11.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMyCollectionViewController.h"
#import "UIBarButtonItem+PBarButtonItem.h"
#import "PresentEntity.h"
#import "PMePresentCollectionCell.h"
#import "PToyDetailViewController.h"

@interface PMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger pageCounter /*分页*/;
    BOOL      hasMore;   /*是否有更多*/;
}

@property (weak,  nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray       *datas;
@property (assign,nonatomic) BOOL                 moreData;
@property (assign,nonatomic) BOOL                refreshShowHud;

@end

@implementation PMyCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNav];
    [self setsubViews];
    
    [self fetchData];
}

- (void)addNav
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithText:NSLocalizedString(@"我的收藏", nil)
                                                               target:self
                                                               action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setsubViews
{
    [self clipExtraCellLine:self.tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView  addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

- (void)fetchData
{
    for (int i = 0; i < 4; i ++) {
        PresentEntity *presentEnity = [PresentEntity new];
       // presentEnity.imgUrl = @"http://a.hiphotos.baidu.com/baike/g%3D0%3Bw%3D268/sign=636a7a122cdda3cc1be4bd2b76d40b37/b64543a98226cffc364b5c3fbb014a90f703eade.jpg";
        presentEnity.imgUrl = [NSString stringWithFormat:@"我的收藏图片%d",i];
        presentEnity.goodsName = @"ios 6";
        presentEnity.additionName= @"Kevin2008";
        presentEnity.coin = @"500";
        [self.datas addObject:presentEnity];
    }
    [self.tableView reloadData];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMePresentCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMePresentCollectionCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PresentEntity *presentEntity = self.datas[indexPath.row];
    cell.presentEntity           = presentEntity;
    [cell updateColorWithIndexPath:indexPath];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *toyBoard = [UIStoryboard storyboardWithName: @"PToy" bundle: nil];

    PToyDetailViewController* toyVC = [toyBoard instantiateViewControllerWithIdentifier: @"toyDetailID"];
    PresentEntity *presentEntity = self.datas[indexPath.row];
    toyVC.joyId = presentEntity.imgUrl;
    [self.navigationController pushViewController:toyVC animated:YES];
    
}

- (void)clipExtraCellLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
}

- (void)headerRereshing
{
    _refreshShowHud = NO;
    pageCounter     = 1;
    
    //query
}

- (void)endRefreshing
{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}


- (BOOL)currentServiceHasMore
{
    BOOL moreData   = NO;
    moreData        = hasMore;
    return moreData;
}

- (void)setHasMoreWithBool:(BOOL)moreData
{
    hasMore = moreData;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
