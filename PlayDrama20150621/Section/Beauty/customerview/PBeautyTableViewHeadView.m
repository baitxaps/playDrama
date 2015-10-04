//
//  PBeautyTableViewHeadView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyTableViewHeadView.h"
#define kPeautyViewResumeBtnTag         100101
#define kPeautyViewNewsBtnTag           kPeautyViewResumeBtnTag +1
#define kPeautyViewRoleBtnTag           kPeautyViewNewsBtnTag+1
#define kPeautyViewPresentBtnTag        kPeautyViewRoleBtnTag+1

@interface PBeautyTableViewHeadView()
@property (weak, nonatomic) IBOutlet UIButton    *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton    *newsBtn;
@property (weak, nonatomic) IBOutlet UIButton    *roleBtn;
@property (weak, nonatomic) IBOutlet UIButton    *presentBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cursorImgView;//游标

@end

@implementation PBeautyTableViewHeadView

+ (PBeautyTableViewHeadView *) initWithNib
{
    PBeautyTableViewHeadView *view = nil;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PBeautyTableViewHeadView" owner:self options:nil];
    for (id obj in array) {
        if ([obj isKindOfClass:[PBeautyTableViewHeadView class]]) {
            view = (PBeautyTableViewHeadView *)obj;
            break;
        }
    }
    return view;
}
//红杏

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.resumeBtn.tag  = kPeautyViewResumeBtnTag;
    self.newsBtn.tag    = kPeautyViewNewsBtnTag;
    self.roleBtn.tag    = kPeautyViewRoleBtnTag;
    self.presentBtn.tag = kPeautyViewPresentBtnTag;
    self.backgroundColor= RGB(0xd8d8d8, 1);
}

/*
 明星详情类型
 */
- (IBAction)headViewBtnAction:(UIButton *)sender
{
    [self customerocationAction:sender];
    
    NSInteger index = sender.tag ;
    switch (index) {
        case kPeautyViewResumeBtnTag:
            [self tableTypeBlockWithType:StarInformationTypeResumeType];
            break;
            
        case kPeautyViewNewsBtnTag:
            [self tableTypeBlockWithType:StarInformationTypeNewsType];
            break;
            
            
        case kPeautyViewRoleBtnTag:
            [self tableTypeBlockWithType:StarInformationTypeRoleType];
            break;
            
            
        case kPeautyViewPresentBtnTag:
            [self tableTypeBlockWithType:StarInformationTypePresentType];
            break;
            
        default:
            break;
    }
}

- (void)tableTypeBlockWithType:(NSInteger)type
{
    if (self.startInfoTypeBlock) {
        self.startInfoTypeBlock(type);
    }
}

/*
 *光标移动
 */
- (void)customerocationAction:(UIButton *)btn
{
    /*
     (minX,minY)
     A--------------------B(maxX,minY)
     -                    -
     -                    -
     -                    -
     C--------------------D(maxX,maxY)
     (minX,maxY)
     */
    CGPoint point =  [PContainerCoords widgetWithLowerLeftCoordinates:btn.frame];
    CGFloat btnPoxW = CGRectGetWidth(btn.frame);
    CGFloat cusPoxW = CGRectGetWidth(self.cursorImgView.frame);

    CGRect frame    = self.cursorImgView.frame;
    frame.origin.x  = point.x + btnPoxW /2 - cusPoxW/2;
    frame.origin.y  = point.y ;
    
    [UIView animateWithDuration:0.3 animations:^{
       self.cursorImgView.frame = frame;
    }];
}

@end
