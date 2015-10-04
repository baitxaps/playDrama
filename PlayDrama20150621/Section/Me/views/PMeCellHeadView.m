//
//  PMeCellHeadView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/4.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMeCellHeadView.h"
@interface PMeCellHeadView ()


@end

@implementation PMeCellHeadView

- (void) awakeFromNib
{
    [super awakeFromNib];
//    self.lineView.backgroundColor=RGBAColor(206, 207, 208, 0.5);
//    self.lineView.hidden         = YES;
//    self.backgroundColor         = [UIColor whiteColor];
}

+ (PMeCellHeadView *) initWithNib
{
    PMeCellHeadView *view = nil;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PMeCellHeadView" owner:self options:nil];
    for (id obj in array) {
        if ([obj isKindOfClass:[PMeCellHeadView class]]) {
            view = (PMeCellHeadView *)obj;
            break;
        }
    }
    return view;
}

- (IBAction)recordVideoAction:(id)sender
{
    if (self.videoCaptureBlock) {
        self.videoCaptureBlock();
    }
}

@end
