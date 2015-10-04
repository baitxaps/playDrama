//
//  PMeCellHeadView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/4.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^VideoCaptureBlock) ();

@interface PMeCellHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *headNamelabel;
@property (weak, nonatomic) IBOutlet UIButton *RecordVideoBtn;
@property (copy, nonatomic) VideoCaptureBlock videoCaptureBlock;

+ (PMeCellHeadView *) initWithNib;
@end


