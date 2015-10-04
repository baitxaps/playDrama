//
//  PAuctionInfoView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/15.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAuctionInfoView.h"
#import "PAuctionInfoCell.h"

@interface PAuctionInfoView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PAuctionInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.delegate =  self;
    self.tableView.dataSource = self;
    [self drawBounderWidth:0.5 Color:[UIColor grayColor] radius:3];
}

+(PAuctionInfoView *)initNib
{
    PAuctionInfoView *view = nil;
    view = [[NSBundle mainBundle] loadNibNamed:@"PAuctionInfoView" owner:self options:nil][0];
    return view;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifer = @"PAuctionInfoHeadCell";
    UITableView *view = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (view==nil) {
        view = [[NSBundle mainBundle]loadNibNamed:@"PAuctionInfoHeadCell"
                                            owner:self
                                          options:nil].firstObject;
    }
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;//self.acutionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"PAuctionInfoCell";
    PAuctionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PAuctionInfoCell"
                                            owner:self
                                          options:nil].firstObject;
    }
    [cell updateAucationWithData:nil indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}


@end
