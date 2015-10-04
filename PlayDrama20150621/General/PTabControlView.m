//
//  PBeautyTableViewHeadView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PTabControlView.h"
#import "PTabAdapterProtocol.h"

#define kPeautyViewResumeBtnTag         100101
#define kPeautyViewNewsBtnTag           kPeautyViewResumeBtnTag +1
#define kPeautyViewPresentBtnTag        kPeautyViewNewsBtnTag+1

@interface PTabControlView()

@property (weak, nonatomic) IBOutlet UIButton    *tabOne;       //选项卡1
@property (weak, nonatomic) IBOutlet UIButton    *tabTwo;       //选项卡2
@property (weak, nonatomic) IBOutlet UIButton    *tabThree;     //选项卡3
@property (weak, nonatomic) IBOutlet UIImageView *cursorImgView;//游标
@property (weak,nonatomic ) id<PTabAdapterProtocol> data;

@end

@implementation PTabControlView

+ (PTabControlView *) initWithNib
{
    PTabControlView *view = nil;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PTabControlView" owner:self options:nil];
    for (id obj in array) {
        if ([obj isKindOfClass:[PTabControlView class]]) {
            view = (PTabControlView *)obj;
            break;
        }
    }
    return view;
}
//红杏

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.tabOne.tag     = kPeautyViewResumeBtnTag;
    self.tabTwo.tag     = kPeautyViewNewsBtnTag;
    self.tabThree.tag   = kPeautyViewPresentBtnTag;
    //self.backgroundColor= RGB(0xd8d8d8, 1);
}


- (void)loadData:(id <PTabAdapterProtocol>)data
{
    self.data = data;
    //设置按钮标题
    [self.tabOne setTitle:[data tabOne] forState:UIControlStateNormal];
    
    [self.tabTwo setTitle:[data tabTwo] forState:UIControlStateNormal];
    
    [self.tabThree setTitle:[data tabThree] forState:UIControlStateNormal];

    //设置背景颜色
    self.backgroundColor = [data backgroundColor];
}

#pragma mark - 按钮 颜色还原
- (void)btnTitleColorRestore
{
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
}

- (void)setTitleColorWithBtn:(UIButton *)btn
{
    [btn setTitleColor:[self.data buttonTintColor] forState:UIControlStateNormal];
}


//回调
- (void)tableTypeBlockWithType:(NSInteger)type
{
    if (self.startInfoTypeBlock) {
        self.startInfoTypeBlock(type);
    }
}

/*
 明星详情类型
 */
- (IBAction)headViewBtnAction:(UIButton *)sender
{
    NSInteger index = sender.tag ;
    switch (index) {
        case kPeautyViewResumeBtnTag:
            [self tableTypeBlockWithType:StarInformationTypeResumeType];
            
            break;
            
        case kPeautyViewNewsBtnTag:
            [self tableTypeBlockWithType:StarInformationTypeLeaveAMSGType];
            
            break;
            
        case kPeautyViewPresentBtnTag:
            [self tableTypeBlockWithType:StarInformationTypePresentType];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 更新选项卡
- (void)updateWithListType:(NSInteger)listType
{
    [self btnTitleColorRestore];
    switch (listType) {
        case StarInformationTypeResumeType:
        {
            [self customerocationAction:self.tabOne];
            [self setTitleColorWithBtn:self.tabOne];
            
        }
            break;
            
        case StarInformationTypeLeaveAMSGType:
        {
            [self customerocationAction:self.tabTwo];
            [self setTitleColorWithBtn:self.tabTwo];
            
        }
            break;
            
        case StarInformationTypePresentType:
        {
            [self customerocationAction:self.tabThree];
            [self setTitleColorWithBtn:self.tabThree];
        }
            break;
            
        default:
            break;
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
    
    CGFloat cusPoxW = CGRectGetWidth(self.cursorImgView.frame);
    CGPoint point   = [PContainerCoords getMidCoordWithSFrame:btn.frame
                                                       dWitdh:cusPoxW
                                                       offset:0];
    CGRect frame    = self.cursorImgView.frame;
    frame.origin.x  = point.x ;
    frame.origin.y  = point.y ;
    
    [UIView animateWithDuration:.3 animations:^{
        self.cursorImgView.frame = frame;
    }];
}

@end
