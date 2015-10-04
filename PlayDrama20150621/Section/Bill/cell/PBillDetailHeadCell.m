//
//  PBillDetailHeadCellTableViewCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillDetailHeadCell.h"
#import "PBillDetailCellFrame.h" 
#import "RTLabel.h"

#define kRTLabelX    160
#define kRTlabelY    33
#define kRTlabelW    UIScreenWidth -kRTLabelX - 8
#define kOffsetHeight 33


@interface PBillDetailHeadCell()

@property (weak, nonatomic) IBOutlet UIView     *lineView;
@property (weak, nonatomic) IBOutlet UILabel    *dramaTitleLabel;
@property (weak, nonatomic) IBOutlet RTLabel    *dramaContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView*dramaImageView;

@end

@implementation PBillDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
   // self.lineView.backgroundColor       = RGB(0xf7653e, 1);
     [_lineView setBackgroundColor:RGBAColor(218, 218, 218, 1)];
    self.lineView.frame                 = CGRectMake(kRTLabelX, 28, kRTlabelW, 1);
    self.dramaContentLabel.frame        = CGRectMake(kRTLabelX, kRTlabelY, kRTlabelW , 0);
    self.dramaContentLabel.font         = kBase13Font;
    self.dramaContentLabel.textColor    = [UIColor darkGrayColor];
}


-(void)headCellWithData:(PBillDetailCellFrame *)cellFrame
              indexPath:(NSIndexPath *)indexPath
                  image:(UIImage *)image;
{
    _dramaContentLabel.text = cellFrame.billEntity.dramaContent;
//    if (cellFrame.billEntity.dramaImgUrl) {
//        NSURL *dramaUrl = [NSURL URLWithString:cellFrame.billEntity.dramaImgUrl];
//       [_dramaImageView sd_setImageWithURL:dramaUrl];
//    }
    _dramaImageView.image = image;
    [self labelContentSizeToFit];
}

- (void)labelContentSizeToFit
{
    self.dramaContentLabel.lineSpacing  = klineSpacing;
    CGSize pSize                        = [self.dramaContentLabel optimumSize];
    if (pSize.height + kOffsetHeight>=160) {
        pSize.height = 160;
    }
    self.dramaContentLabel.frame        =   (CGRect){{kRTLabelX,kRTlabelY}, {pSize.width, pSize.height}};
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
