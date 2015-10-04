//
//  PBeautyDetailHeadView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/1.
//  Copyright (c) 2015年 times. All rights reserved.


#import "PBeautyDetailHeadView.h"
#import "UIImageView+WebCache.h"
#define  kSCROLLVIEWLEFTBTNTAG   100
#define  kSCROLLVIEWRIGHTBTNTAG  kSCROLLVIEWLEFTBTNTAG +1

@interface PBeautyDetailHeadView()
{
    BOOL               isShow ;
}
@property (weak, nonatomic) IBOutlet UIScrollView *headScrollView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation PBeautyDetailHeadView

+ (PBeautyDetailHeadView *) initWithNib
{
    PBeautyDetailHeadView *view = nil;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PBeautyDetailHeadView" owner:self options:nil];
    for (id obj in array) {
        if ([obj isKindOfClass:[PBeautyDetailHeadView class]]) {
            view = (PBeautyDetailHeadView *)obj;
            break;
        }
    }
    return view;
}


- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.headScrollView.bounces                         = NO;
    self.headScrollView.pagingEnabled                   = YES;
    self.headScrollView.showsVerticalScrollIndicator    = NO;
    self.headScrollView.showsHorizontalScrollIndicator  = NO;
    self.headScrollView.userInteractionEnabled          = YES;
    
    self.leftView.backgroundColor = RGBAColor(42, 43, 54, 0.7);
    self.rightView.backgroundColor = RGBAColor(42, 43, 54, 0.7);
    self.leftBtn.tag  = kSCROLLVIEWLEFTBTNTAG;
    self.rightBtn.tag = kSCROLLVIEWRIGHTBTNTAG;
    isShow            = YES;
}


- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self loadBtnToScrollView:_imageArray];
}

- (void)loadBtnToScrollView:(NSArray *)array
{
    for (UIImageView *view in self.headScrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    for (NSInteger index = 0; index < array.count; ++index) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(index *UIScreenWidth, 0, UIScreenWidth, self.frame.size.height)];
        
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gs = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgGesture:)];
        [imgView addGestureRecognizer:gs];
        
        NSString *imgUrl = array[index];
        if ([imgUrl hasPrefix:@"http://"]) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                       placeholderImage:[UIImage imageNamed:@"Default.png"]
                                options:SDWebImageLowPriority | SDWebImageRetryFailed];
        }else{
            imgView.image = [UIImage imageNamed:imgUrl];
        }
        imgView.contentMode  = UIViewContentModeScaleAspectFit;
        [self.headScrollView addSubview:imgView];
    }
    self.headScrollView.contentSize  = CGSizeMake(UIScreenWidth * array.count, self.headScrollView.frame.size.height);
}

- (void)imgGesture:(UITapGestureRecognizer *)gesture
{
    isShow  = !isShow;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.leftView.alpha =  self.rightView.alpha = isShow ? 1:0;
    }];
}

/*
 *左右侧按钮点击
 */
- (IBAction)btnWithScrollViewAction:(UIButton *)sender
{
    NSInteger index = sender.tag;
    NSInteger page = self.headScrollView.contentOffset.x /self.headScrollView.frame.size.width;
    if (index ==kSCROLLVIEWLEFTBTNTAG && page >0) {
        [self.headScrollView setContentOffset:CGPointMake((page-1) *self.headScrollView.frame.size.width, 0) animated:YES];
    
    }else if (index == kSCROLLVIEWRIGHTBTNTAG && page < _imageArray.count -1){
       
        [self.headScrollView setContentOffset:CGPointMake((page+1) *self.headScrollView.frame.size.width, 0) animated:YES];
    }
}


#pragma mark - Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x /scrollView.frame.size.width;
    [scrollView setContentOffset:CGPointMake(page *scrollView.frame.size.width, 0) animated:YES];
}


@end
