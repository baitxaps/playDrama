//
//  PBillDetailRoleCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillDetailTableViewCell.h"
#import "PBillDetailCellFrame.h"
#import "PHistogramView.h"
#import "PVoteView.h"

@interface PBillDetailTableViewCell ()<PDramaDelegate>
{
    UIImageView     *_sexImageView;
    UILabel         *_roleNameLabel;
    UILabel         *_roleTextLabel;
    
    UIScrollView    *_scrollView;
    UIView          *_bottomView;
    PHistogramView  *_histogramView;
    BOOL            isExpand;
    CGRect          _voteRect;
}
@property(nonatomic,strong)PVoteView   *voteView;
@end

@implementation PBillDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}


- (void)addSubviews
{
     //投票按钮加事件
    [_voteBtn addTarget:self action:@selector(voteAction:)
       forControlEvents:UIControlEventTouchUpInside];

    //sexImage
    _sexImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_sexImageView];
    
    //roleNameLabel
    _roleNameLabel                              = [[UILabel alloc]init];
    _roleNameLabel.font                         = [UIFont systemFontOfSize:13.0f];
    _roleNameLabel.backgroundColor              =  [UIColor clearColor];
    [self.contentView addSubview:_roleNameLabel];
    
    //roleText
    _roleTextLabel                              = [[UILabel alloc]init];
    _roleTextLabel.font                         = [UIFont systemFontOfSize:13.0f];
    _roleTextLabel.backgroundColor              = [UIColor clearColor];
    _roleTextLabel.numberOfLines                = 0;
    _roleTextLabel.textColor                    = [UIColor darkGrayColor];
    [self.contentView addSubview:_roleTextLabel];
    
    //柱状图
    _scrollView                                 = [[UIScrollView alloc]init];
    _scrollView.bounces                         = NO;
    _scrollView.showsVerticalScrollIndicator    = NO;
    _scrollView.showsHorizontalScrollIndicator  = NO;
    _scrollView.userInteractionEnabled          = YES;
    _scrollView.backgroundColor                 = [UIColor clearColor];
    [self.contentView addSubview:_scrollView];
    
    _histogramView = [[PHistogramView alloc] initWithFrame:CGRectMake(0, 0, kBaseCellWith, kBaseHistogramSubViews)];
   // _histogramView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
   //_histogramView.layer.borderWidth = 0.5f;
    [_scrollView addSubview:_histogramView];
}


- (void)setCellFrame:(PBillDetailCellFrame *)cellFrame
{
    [super setBaseCellFrame:cellFrame];
    _cellFrame              = cellFrame;
    //性别图标
    _sexImageView.image     =[UIImage imageNamed:@"rolehead"];
    _sexImageView.frame     = cellFrame.sexImgViewRect;
    
    //角色名
    _roleNameLabel.text     = cellFrame.billEntity.dramaRoleName;
    _roleNameLabel.frame    = cellFrame.roleNameLabelRect;
    
    //角色介绍信息
    _roleTextLabel.text     = cellFrame.billEntity.dramaRoleText;
    _roleTextLabel.frame    = cellFrame.roleTextLabelRect;
    
    //柱状图
    _scrollView.frame       = cellFrame.scrollViewRect;
    CGFloat scrollViewHight = cellFrame.scrollViewRect.size.height;
    _scrollView.contentSize = CGSizeMake(cellFrame.histogramViewWidth, scrollViewHight);
    
    _histogramView.frame    = cellFrame.histogramViewRect;
    _histogramView.datas    = cellFrame.billEntity.datas;
    _histogramView.colors   = cellFrame.billEntity.colors;
    _histogramView.isText   = cellFrame.billEntity.isRole;
    
    //临时投票按钮CGrect
    _voteRect               = cellFrame.voteBtnRect;
}

#pragma mark - @synthesize voteView
- (PVoteView *)voteView
{
    if (_voteView == nil) {
        _voteView           = [PVoteView initNib];
        _voteView.delegate  = self;
        CGPoint btnPoint    = [PContainerCoords widgetWithLowerLeftCoordinates:_voteRect];
        _voteView.frame     = CGRectMake(btnPoint.x,
                                      btnPoint.y-kVoteTableViewOffset,
                                      kVoteTableViewWidth, 0);
        [self.contentView addSubview:_voteView];
    }
    return _voteView;
}

- (void)updateVoteTableViewData
{
    if (_cellFrame) {
        PBillEntitiy *billEntity = _cellFrame.billEntity;
        if (billEntity.datas.count > 0) {
            _voteView.data = billEntity.datas;
        }
    }
}

#pragma  mark -
#pragma mark - 投票事件
- (void)voteAction:(UIButton *)sender
{
    CGPoint btnPoint =  [PContainerCoords widgetWithLowerLeftCoordinates:sender.frame];
    isExpand         = ! isExpand;
    if (isExpand){
        [self.voteView showAnimaitonDuration:0.3 animation:YES point:btnPoint];
        
        //投票表格数据更新
        [self updateVoteTableViewData];
        
        //将sender放置到最顶层
        [self.contentView bringSubviewToFront:sender];
    }else{
        
        [self.voteView hideAnimationDuration:0.3 animation:YES point:btnPoint];
    }
}

#pragma mark - PDramaDelegate
- (void)tableViewCellClickInIndexPath:(NSIndexPath *)indexPath
{
    [self voteAction:_voteBtn];
    
    if ([self.delegate respondsToSelector:@selector(tableViewCellClickInIndexPath:cellIndex:)]) {
        [self.delegate tableViewCellClickInIndexPath:self.indexPath cellIndex:indexPath.row ];
    }
}


@end
