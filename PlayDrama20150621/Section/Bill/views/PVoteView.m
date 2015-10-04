//
//  PVoteView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/22.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PVoteView.h"
#import "PVoteTableViewCell.h"
#import "PUILayoutConst.h"

@interface PVoteView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation PVoteView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.backgroundColor        = RGBAColor(240, 79, 48, 0.98);
    self.tableView.backgroundColor=[UIColor clearColor];
    
    [self drawBounderWidth:0.5 radius:25 Color:[UIColor clearColor].CGColor];
    
    /*
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight|UIRectCornerTopLeft| UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(25, 25)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
     */
}

+ (PVoteView *)initNib
{
    return [[NSBundle mainBundle]loadNibNamed:@"PVoteView" owner:self options:nil].firstObject;
}


- (void)showAnimaitonDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                        point:(CGPoint)point
{
    CGRect frame        = self.frame;
    frame.size.height   = kVoteTableViewHeight;
    frame.size.width    = kVoteTableViewWidth;
    
    if (animation) {
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(point.x,
                                      point.y-kVoteTableViewOffset,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(point.x,
                                      point.y-kVoteTableViewOffset,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }
}

//隐藏
- (void)hideAnimationDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                        point:(CGPoint)point
{
    CGRect frame        = self.frame;
    frame.size.height   = 0;
    if (animation) {
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(point.x,
                                      point.y-kVoteTableViewOffset,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(point.x,
                                      point.y-kVoteTableViewOffset,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }
}



#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"PVoteTableViewCell";
    PVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [PVoteTableViewCell loadCell];
    }
    cell.typeLabel.text = [NSString stringWithFormat:@"%@",self.data[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(tableViewCellClickInIndexPath:)]) {
        [self.delegate tableViewCellClickInIndexPath:indexPath];
    }
}

@end
