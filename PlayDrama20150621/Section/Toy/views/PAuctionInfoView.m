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


@end

@implementation PAuctionInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.delegate     =  self;
    self.tableView.dataSource   = self;
    //[self drawBounderWidth:0.5 Color:[UIColor grayColor] radius:3];
}

+(PAuctionInfoView *)initNib
{
    PAuctionInfoView *view = nil;
    view = [[NSBundle mainBundle] loadNibNamed:@"PAuctionInfoView" owner:self options:nil][0];
    return view;
}

- (void)showAnimaitonDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                        point:(CGPoint)point
                   offsetSize:(CGSize)offsetSize
{
    CGRect frame        = self.frame;
    frame.size.height   = offsetSize.height;
    frame.size.width    = offsetSize.width;;
    
    if (animation) {
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(point.x,
                                      point.y,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(point.x,
                                      point.y,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }
}

- (void)hideAnimationDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
{
    CGRect frame        = self.frame;
    frame.size.height   = 0;
    if (animation) {
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(frame.origin.x,
                                      frame.origin.y,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(frame.origin.x,
                                      frame.origin.y,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }
}



#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifer = @"PAuctionInfoHeadCell";
    UIView *view = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
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
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"PAuctionInfoCell";
    PAuctionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [PAuctionInfoCell loadCell];
    }
    [cell updateAucationWithData:self.datas indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}


@end
