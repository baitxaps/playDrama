//
//  PBillBaseDetailCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillBaseDetailCell.h"
#import "PBillBaseCellFrame.h"
#import "PBillEntitiy.h"

@implementation PBillBaseDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addBaseSubviews];
    }
    return self;
}

- (void)addBaseSubviews
{
    //bill单名
    _billTypeNameLabel = [[UILabel alloc]init];
    _billTypeNameLabel.font = [UIFont systemFontOfSize:13.0f];
    _billTypeNameLabel.backgroundColor =  [UIColor clearColor];
    [self.contentView addSubview:_billTypeNameLabel];
    
    //bill票图
    
    _billTypeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_billTypeImageView];
    
    //lineView
    _lineView = [[UIView alloc]init];
    [_lineView setBackgroundColor:RGBAColor(218, 218, 218, 1)];
    [self.contentView addSubview:_lineView];
    
    //voteBtn
    _voteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _voteBtn.exclusiveTouch  = YES;
    _voteBtn.backgroundColor = RGBAColor(240, 79, 48, 0.98);
    _voteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_voteBtn setTitle:@"投票" forState:UIControlStateNormal];
    [_voteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_voteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_voteBtn setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
     [_voteBtn setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateHighlighted];
    [_voteBtn drawBounderWidth:0.5 radius:kVoteButtonHeight/2.0
                         Color:[UIColor redColor].CGColor];
    [self.contentView addSubview:_voteBtn];
}

- (void)setBaseCellFrame:(PBillBaseCellFrame *)baseCellFrame
{
    _baseCellFrame = baseCellFrame;
    
    PBillEntitiy *billEntity = baseCellFrame.billEntity;
    //bill单名
    _billTypeNameLabel.text  = billEntity.billTypeName;
    _billTypeNameLabel.frame = baseCellFrame.billTypeNameLabelRect;
    
    //bill票图
    NSString *image           = \
    baseCellFrame.billEntity.isRole ?@"castbill":@"dramavote";
    _billTypeImageView.image  = [UIImage imageNamed:image];
    _billTypeImageView.frame  = baseCellFrame.billTypeImageViewRect;
    
    //lineView
    //_lineView.backgroundColor = [UIColor darkGrayColor];
    _lineView.frame           = baseCellFrame.lineViewRect;
    
    //_voteBtn
    _voteBtn.frame             = baseCellFrame.voteBtnRect;
    PDebugLog(@"%f",_voteBtn.titleLabel.bounds.size.width);
    _voteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _voteBtn.imageEdgeInsets   = UIEdgeInsetsMake(5, 15, 21,-10);//右:_voteBtn.titleLabel.bounds.size.width
    _voteBtn.titleEdgeInsets   = UIEdgeInsetsMake(30,-25, 0, 0); //左:_voteBtn.titleLabel.bounds.size.width
    
    /*
     1.在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets titleEdgeInsets imageEdgeInsets
     2.设置image在button上的位置（上top,左left ,下bottom,右right）这里可以写负值，对上写－5,那么image就象上移动5个像素
     3.设置title在button上的位置（上top,左left,下bottom,右right）
     */
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
