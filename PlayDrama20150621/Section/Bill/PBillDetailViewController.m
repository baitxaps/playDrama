//
//  PBillDetailViewController.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillDetailViewController.h"
#import "PShareToolsView.h"
#import "PBillDetailHeadCell.h"
#import "PBillDetailTableViewCell.h"
#import "PBillDetailCellFrame.h"
#import "PBillEntitiy.h"
#import "RGBColor.h"

@interface PBillDetailViewController ()<PDramaDelegate, UITableViewDataSource,UITableViewDelegate>
{
    PShareToolsView *_shareTools;
}
@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray        *cellFrames;
@end

@implementation PBillDetailViewController

- (void)dealloc
{
    PDebugLog(@"%s", __FUNCTION__);
}

- (NSMutableArray *)cellFrames
{
    if (_cellFrames ==nil) {
        _cellFrames = [NSMutableArray new];
    }
    return _cellFrames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubViews];
    
    for (int i = 0  ;i < 3;i++) {
        @autoreleasepool {
            PBillDetailCellFrame *cellFrame = [[PBillDetailCellFrame alloc] init];
            PBillEntitiy *billEntity = [PBillEntitiy new];
            if (i == 0) {
                billEntity.dramaContent = @"故事发生在1937年12月，日本军官黑岩大佐跟随先头部队进入了沦陷的南京城，他接受的任务是掩埋销洗约五万中国士兵的尸体，但他很快就发现，死亡平民的数量远远超过了预期...";
                billEntity.billTypeName = @"下一季剧情投票";
                billEntity.billTypeImageUrl = @"http://pic4.nipic.com/20091201/1951702_084317003934_2.jpg";
                billEntity.dramaImgUrl = @"http://pic4.nipic.com/20091201/1951702_084317003934_2.jpg";
                billEntity.datas = [NSMutableArray arrayWithArray:[self sortData]];//[@[@"小明",@"小李",@"小x",@"小y",@"小c",@"小z"]mutableCopy];
                billEntity.isRole = NO;
                billEntity.colors = [NSMutableArray arrayWithArray:[self dataColors]];
            }else{
                billEntity.billTypeName = @"演员投票";
                billEntity.billTypeImageUrl = @"http://pic4.nipic.com/20091201/1951702_084317003934_2.jpg";
                billEntity.dramaImgUrl = @"http://pic4.nipic.com/20091201/1951702_084317003934_2.jpg";
                billEntity.dramaRoleText = @"外科医生沉稳，对人真诚";
                billEntity.dramaRoleName = @"haha";
                billEntity.datas = [NSMutableArray arrayWithArray:[self sortData]];
                billEntity.colors =[NSMutableArray arrayWithArray:[self dataColors]];
                
                //[@[RGBA(0xfc5454, 1),RGB(0xfca754, 1),RGB(0x4ada79, 1),RGB(0x54b7fc, 1)]mutableCopy];
                billEntity.isRole = YES;
            }
            cellFrame.billEntity = billEntity;
            [self.cellFrames addObject:cellFrame];
        }
    }
    [_tableView reloadData];
}

- (NSArray *)sortData
{
    NSArray *data = [@[@(1030),@(10),@(210),@(500),@(2000),@(5000),@(3202)]mutableCopy];
    
    
    NSArray *sortedArray = [data sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2] == NSOrderedAscending;
    }];
    NSLog(@"排序后:%@",sortedArray);
    
    return sortedArray;
}


- (NSArray *)dataColors
{
    return @[
             [RGBColor colorWithRed:252/255.0f green:84/255.0f  blue:84/255.0f  alpha:1],
             [RGBColor colorWithRed:252/255.0f green:167/255.0f blue:84/255.0f  alpha:1],
             [RGBColor colorWithRed:74/255.0f  green:218/255.0f blue:121/255.0f alpha:1],
             [RGBColor colorWithRed:84/255.0f  green:183/255.0f blue:252/255.0f alpha:1]];
}

- (void)setupSubViews
{
    // 1.the left/right of
    UIBarButtonItem *leftItem =\
    [[UIBarButtonItem alloc]initWithText:NSLocalizedString(@"剧集详细", nil)
                                  target:self
                                  action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightBarItem =\
    [[UIBarButtonItem alloc]initWithNavigationItem:self.navigationItem
                                            target:self
                                            action:@selector(shareAction:)
                                       bgImgString:@"share"];
    self.navigationItem.rightBarButtonItems = @[rightBarItem];
    //self.navigationController.navigationBar.barTintColor = RGB(0x242525, 0.75);
    
    //2._shareTools
    _shareTools                 = [PShareToolsView initNib];
    _shareTools.withController_ = self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - share

- (void)shareAction:(id)sender
{
    [_shareTools show];
}



#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return  0.1;
    }
    return 0.01;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section== 0) {
        height =  190.0f;
    }else if (indexPath.section == 1){
        PBillDetailCellFrame *cellFrame = _cellFrames[indexPath.row];;
        height =cellFrame.cellHeight;
    }else{
        PBillDetailCellFrame *cellFrame = _cellFrames[indexPath.row +1];;
       height = cellFrame.cellHeight;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellHeadIdentifer = @"PBillDetailHeadCell";
    static NSString *cellRoledentifer  = @"PBillDetailTableViewCell";
    static NSString *cellDramadentifer = @"cellDramadentifer";
    if (indexPath.section == 0) {
        PBillDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellHeadIdentifer];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"PBillDetailHeadCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell headCellWithData:_cellFrames[indexPath.row] indexPath:indexPath image:self.image];
       
        return cell;
    }else if (indexPath.section == 1){
        PBillDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRoledentifer];
        if (cell == nil) {
            cell =  [[PBillDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellRoledentifer];
            cell.selectionStyle         = UITableViewCellSelectionStyleNone;
            cell.delegate               = self;
        }
        
        PBillDetailCellFrame *cellFrame = _cellFrames[indexPath.row];//------会重用section
        cell.cellFrame                  = cellFrame;
        cell.indexPath                  = indexPath;
        return cell;
    }else if(indexPath.section == 2){
        PBillDetailTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellDramadentifer];
        if (cell == nil) {
            cell =  [[PBillDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDramadentifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate       = self;
        }
        
        PBillDetailCellFrame *cellFrame = _cellFrames[indexPath.row + 1];
        cell.indexPath                  = indexPath;
        cell.cellFrame                  = cellFrame;
        return cell;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}

#pragma mark - PDramaDelegate

- (void)tableViewCellClickInIndexPath:(NSIndexPath *)indexPath cellIndex:(NSInteger)index
{
    PDebugLog(@"row=%ld,section = %ld",index,indexPath.section);
    PBillDetailCellFrame *cellFrame = _cellFrames[indexPath.section];
    PDebugLog(@"%@", cellFrame.billEntity.datas[index]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
