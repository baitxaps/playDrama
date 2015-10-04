//
//  PDramaChoiceAorBView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/6.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^DramaOptionBlcok)(NSString *urlString);

@interface PDramaChoiceAorBView : UIView
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,copy )DramaOptionBlcok dramaOptionBlock;

+ (PDramaChoiceAorBView *) initWithNib;
- (void)hide;
@end
