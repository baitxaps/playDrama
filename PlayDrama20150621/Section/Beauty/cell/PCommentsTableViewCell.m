//
//  PBeautyDetailLeaveMsgCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/10.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PCommentsTableViewCell.h"
#import "PBeautyEntity.h"
#import "PCommentsEntity.h"
#import "UIImageView+WebCache.h"
#define OringinHight  35

@interface PCommentsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;


@end

@implementation PCommentsTableViewCell


+ (PCommentsTableViewCell*)loadCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"PCommentsTableViewCell"
                                        owner:self
                                      options:nil].firstObject;
}

- (void)awakeFromNib
{
    self.backgroundColor = RGB(0xd8d8d8, 1);
    [self.avatarImageView drawBounderWidth:0.5 Color:[UIColor clearColor] radius:self.avatarImageView.frame.size.height/ 2.0];
    
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headGestureAction:)];
    [self.avatarImageView addGestureRecognizer:headTap];
    headTap.view.exclusiveTouch     = YES;
}

#pragma mark - 转到个人中心
- (void)headGestureAction:(UIGestureRecognizer*)gesture
{
    if ([self.delegate respondsToSelector:@selector(tableViewCellClickInCell:)]) {
        [self.delegate tableViewCellClickInCell:self];
    }
}

#pragma mark - cell 中评论
- (IBAction)CommentsAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tableViewCommentsCell:)]){
        [self.delegate tableViewCommentsCell:self];
    }
}

- (CGFloat)tableViewWithData:(id<PCommentsCellContentDelegate>)data heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = UIScreenWidth - 53- 37;
    CGFloat height = [data.content heightWithFixWidth:width font:[UIFont systemFontOfSize:13.0f]];
    
    height = height + OringinHight;
    
    if (height <=self.bounds.size.height) {
        height = self.bounds.size.height;
    }
    return height ;
}


-(void)setData:(id<PCommentsCellContentDelegate>)data
{
    _data                   = data;
    self.nameLabel.text     = data.fromUserName;
    self.levelLabel.text    = data.level;
    self.commentsLabel.text = data.content;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString: data.fUserFaceUrl]
                            placeholderImage:nil
                                     options:SDWebImageRetryFailed|SDWebImageLowPriority ];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
