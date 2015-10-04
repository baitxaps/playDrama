//
//  PMeMessageViewController.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/4.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMeMessageViewController.h"
#import "PMeMessageCell.h"
#import "MessageEntity.h"

@interface PMeMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray      *msgData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PMeMessageViewController

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithText:NSLocalizedString(@"我的消息", nil)
                                                               target:self
                                                               action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self fetchDataFromeService];
    [self clipExtraCellLine:self.tableView];
}


- (void)fetchDataFromeService
{
    self.msgData = [@[
                      @"腹黑萌宝高冷娘亲的简介：她是杀手界的传奇，却被自己一手教出来的徒弟背叛惨死",
                      @"异世重生，她穿越在一个因未婚先孕而被逐出家族的变废天才身上。",
                      @"是不是觉得在一行数据上划动一下,然后出现一个删除按钮很酷?废话少说,直奔正题,就由笔者来向您展示一下这个功能的实现是多么容易先前的准备工作",
                       @"男人赚钱女人花，我就是想让你买买买花我的钱而已！",
                      @"什么？异世大陆，强者为尊，像她这样的废物，就活该被人欺负？燕子妫抱着萌萌哒的儿子冷笑，身后跟着杀气腾腾的万兽！她倒要看看，哪个不长眼不怕被踩成肉泥，敢来惹她！什么？家族后悔了，想接她回去，顺便让她打下来的势力充公？",
                      @"不好意思，她早已自立门户，属于她的东西，谁也不能动！什么？又有人打她宝贝儿子的主意，想威胁她？呵呵，这是老寿星上吊，嫌自己命长啊，她燕子妫的儿子，岂是好算计的？！但她万万没想到，这世上还真有那么一个人，胆敢杀她威风，抢她家业，坑她儿子！但等她半夜上门去报仇，却被他霸道的困在怀里道：“别气了！"
                     
                      ]mutableCopy];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSString *msg in self.msgData) {
        MessageEntity *msgEntity = [[MessageEntity alloc]initWithString:msg];
        [temp addObject:msgEntity];
    }
    
    [self.msgData removeAllObjects];
    self.msgData = [NSMutableArray arrayWithArray:temp];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.msgData removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageEntity *msgEntity = self.msgData[indexPath.row];
    return msgEntity.rtLabelViewRect.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMeMessageCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"PMeMessageCell"];
    MessageEntity *msgEntity = self.msgData[indexPath.row];
    cell.messageEntity       = msgEntity;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)clipExtraCellLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
