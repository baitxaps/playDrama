//
//  PMyPresentViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/4/11.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMyPresentViewController.h"
#import "UIBarButtonItem+PBarButtonItem.h"
#import "PMePresentCollectionCell.h"
#import "PresentEntity.h"
#import "PToyDetailViewController.h"

@interface PMyPresentViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    NSInteger pageCounter /*分页*/;
    BOOL      hasMore;   /*是否有更多*/;
}
@property (weak,  nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray       *datas;
@property (assign,nonatomic) BOOL                 moreData;
@property (assign,nonatomic) BOOL                refreshShowHud;
@end

@implementation PMyPresentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNav];
    [self setsubViews];
    [self fetchData];
}

- (void)addNav
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithText:NSLocalizedString(@"我的礼物", nil)
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
        //presentEnity.imgUrl = @"http://d.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=a44fa6bf42a7d933aba5ec21cc22ba76/242dd42a2834349ba8c7f22ec9ea15ce37d3be5c.jpg";
        presentEnity.imgUrl = [NSString stringWithFormat:@"礼物箱图片%d",i ];
        presentEnity.goodsName = @"map";
        presentEnity.additionName= @"technical information";
        presentEnity.coin = @"12500";
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
    UIStoryboard *toyBoard = [UIStoryboard storyboardWithName: @"PToy" bundle:[NSBundle mainBundle]];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
