//
//  PMeMessageCell.h
//  PlayDrama
//Users/hairongchen/Desktop/drama 切图/玩我/3x玩我 我的消息.jpg/
//  Created by hairong.chen on 15/8/5.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "MessageEntity.h"

@interface PMeMessageCell : UITableViewCell
@property (weak,  nonatomic) IBOutlet RTLabel *msgRTlabel;
@property (strong,nonatomic) MessageEntity    *messageEntity;

@end
