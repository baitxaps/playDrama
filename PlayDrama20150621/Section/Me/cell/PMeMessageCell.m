//
//  PMeMessageCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/5.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMeMessageCell.h"
#import "PUILayoutConst.h"

@implementation PMeMessageCell

- (void)awakeFromNib {
    self.msgRTlabel.textColor = [UIColor grayColor];
    self.msgRTlabel.font      = kBase15Font;
    self.msgRTlabel.frame     = CGRectMake(KCellXGapBetweenSubViews, KCellYGapBetweenSubViews, UIScreenWidth - kWidthOffset, 0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.msgRTlabel.frame = _messageEntity.rtLabelViewRect;
}

- (void)setMessageEntity:(MessageEntity *)msgEntity
{
    _messageEntity = msgEntity;
    
    _msgRTlabel.text = msgEntity.msg;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
