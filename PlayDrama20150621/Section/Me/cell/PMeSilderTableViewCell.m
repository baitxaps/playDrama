//
//  PMeSilderTableViewCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/29.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMeSilderTableViewCell.h"
@interface PMeSilderTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhifubaoLabel;

@end

@implementation PMeSilderTableViewCell


+ (PMeSilderTableViewCell *)loadCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"PMeSilderTableViewCell" owner:self options:nil].firstObject;
}

- (void)awakeFromNib {
    self.typeLabel.textColor     = [UIColor whiteColor];
    self.zhifubaoLabel.textColor = [UIColor whiteColor];
}

-(void)updateData:(NSArray *)datas
           images:(NSArray*)iamges
        indexPath:(NSIndexPath *)indexPath
{
   
  
    self.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    self.zhifubaoLabel.text = @"";
    switch (indexPath.row) {
        case 0:
        {
            self.accessoryType      = UITableViewCellAccessoryNone;
            self.zhifubaoLabel.text = @"william";
            CGRect frame            = self.zhifubaoLabel.frame;
            frame.origin.x          = frame.origin.x - 15;
            self.zhifubaoLabel.frame= frame;
            
        }
            break;
                        
        case 4:
        {
            self.accessoryType      = UITableViewCellAccessoryNone;
            self.imgView.hidden     = YES;
            self.typeLabel.textAlignment = NSTextAlignmentCenter;
            
            CGRect frame            = self.typeLabel.frame;
            frame.origin.x          = CGRectGetWidth(self.frame)/2.0 - frame.size.width/2.0;
            self.typeLabel.frame    = frame;
        }
    
        default:
            break;
    }
    self.typeLabel.text  = datas[indexPath.row];
    self.imgView.image = [UIImage imageNamed:iamges[indexPath.row]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
