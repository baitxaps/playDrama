//
//  PChooseDramaView.h
//  PlayDrama
//
//  Created by RHC on 15/5/29.
//  Copyright (c) 2015年 times. All rights reserved.


#import <UIKit/UIKit.h>
typedef void (^PChooseDramaBlock)(NSString  *dramaUrl);

@interface PChooseDramaView : UIView
@property (nonatomic,strong)NSMutableArray *dramaUrlArray;
@property (nonatomic,copy)  PChooseDramaBlock chooseDramaBlock;
+(PChooseDramaView *)initNib;
- (void)relizeFrame;
@end
