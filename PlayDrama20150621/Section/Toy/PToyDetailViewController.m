//
//  PToyDetailViewController.m
//  PlayDrama
//
//  Created by RHC on 15/6/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PToyDetailViewController.h"
#import "PShareToolsView.h"
#import "RTLabel.h"
#import "UIImageView+WebCache.h"

#define HEIGHTSPACE 100

@interface PToyDetailViewController ()
{
    BOOL isExpand;
}
@property (weak, nonatomic) IBOutlet UIScrollView   *pToyScrollView;
@property (weak, nonatomic) IBOutlet UILabel     *productNameLabel; //商品名
@property (weak, nonatomic) IBOutlet UIView      *productDetailView; //商品详情描述背景
@property (weak, nonatomic) IBOutlet UIView      *buyProductView;   //购买视图
@property (weak, nonatomic) IBOutlet UIImageView *productImageView; //商品图片
@property (weak, nonatomic) IBOutlet UIButton    *priceBtn;         //价格按钮
@property (weak, nonatomic) IBOutlet UIButton    *collectionBtn;    //收藏按钮
@property (weak, nonatomic) IBOutlet UIButton    *showDtailBtn;     //查看详情按钮
@property (strong,nonatomic) PShareToolsView     *shareTools;
@property (weak, nonatomic) IBOutlet RTLabel     *rtLabel;          //商品详情描述

@end

@implementation PToyDetailViewController

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    [self setupSubViews];
    [self relizeFrameDetailText];
}


- (void)setupSubViews
{
    self.productDetailView.layer.contents   = (__bridge id)([UIImage imageNamed:@"toy_TopBG"].CGImage);
    self.buyProductView.layer.contents      = (__bridge id)([UIImage imageNamed:@"toy_BottomBG"].CGImage);
    
    self.pToyScrollView.backgroundColor     = RGB(0x000000, 0.2);
    self.pToyScrollView.bounces             = NO;
    self.pToyScrollView.showsHorizontalScrollIndicator = NO;
    [self.pToyScrollView drawBounderWidth:0.5 Color: RGB(0x000000, 0.2) radius:3.0];

    [_priceBtn drawBounderWidth:1.0 Color:[UIColor grayColor] radius:3.0];
    self.productImageView.image = [UIImage imageNamed:@"商品详情-车"];
    //[self.productDetailView drawBounderWidth:1 Color:[UIColor redColor]];
    //[self.buyProductView drawBounderWidth:1 Color:[UIColor redColor]];
    
    
    //分享视图
    _shareTools                 = [PShareToolsView initNib];
    _shareTools.withController_ = self;
    
//    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:self.joyId]
//                             placeholderImage:[UIImage imageNamed:@"2"]
//                                      options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

- (void)relizeFrameDetailText
{
    self.rtLabel.text = @"虎牙直播\n\t第一游戏直播互动平台,200万人同时在线,提供高清、流畅的赛事直播和游戏直播.虎牙包含英雄联盟lol直播、dota2直播、dnf直播等热门游戏直播以及单机游戏、手游.Y娱乐是全国最大的真人互动视频直播社区,支持百万人同时在线视频聊天、美女直播 、K歌跳舞、视频交友。看网络节目,与明星歌手、美女主播互动就在YY娱乐社区。\n\tyy语音是多玩研发的一款团队语音通信平台,本站提供yy语音官方下载。yy语音（歪歪语音）功能强大，音质清晰，安全稳定，不占资源,是适应游戏玩家装机必备语音软件，可以让您高效的与朋友一起游戏对作战。yy语音将群内人员进行分组，每个小组相当于一个小群，金字塔式的管理架构，您可以按照会员类型、军团分配分组，极大方便公会进行人事管理。服务器保存所有聊天记录，您可以在任何一台电脑上登陆yy语音，查看群内全部聊天记录。\n\t一切尽在您的掌握之中。另外，yy直播提供游戏直播、k歌跳舞直播、美女视频直播，英雄联盟直播等等。歪歪知道专区：http://product.pconline.com.cn/itbk/software/waiwai/";
    
    self.rtLabel.font = [UIFont systemFontOfSize:13.0];
    self.rtLabel.lineSpacing = 10.0;
    
    CGSize optimumSize  = [self.rtLabel optimumSize];
    CGRect frame        = [self.rtLabel frame];
    frame.size.height   = (int)optimumSize.height+5;
    [self.rtLabel setFrame:frame];
    
    
    CGPoint dPoint   = [PContainerCoords widgetWithLowerLeftCoordinates:self.productDetailView.frame];
    CGPoint rtPoint  = [PContainerCoords widgetWithLowerLeftCoordinates:frame];
    
    if (rtPoint.y >= dPoint.y -250) {
        rtPoint.y = dPoint.y  -250;
    }
    CGRect scrollViewFrame      = self.pToyScrollView.frame;
    self.pToyScrollView.frame   = \
    (CGRect){{scrollViewFrame.origin.x,scrollViewFrame.origin.y }, {scrollViewFrame.size.width,rtPoint.y }};
    
    self.pToyScrollView.contentSize= CGSizeMake(290  ,frame.size.height);
    
}


#pragma mark - 购买
- (IBAction)buyProductAction:(UIButton *)sender
{
    
}

#pragma mark - 收藏
- (IBAction)collectionAction:(UIButton*)sender
{
    sender.selected  = !sender.selected;
    if (sender.selected) {
        
    }else{
        
    }
}


#pragma mark - 查看详情
- (IBAction)showContentAction:(id)sender
{
    isExpand     = !isExpand;
    CGFloat alp  = isExpand ? 0.f: 1.0f;
    double x     = isExpand ? M_PI:0;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.showDtailBtn.transform = CGAffineTransformMakeRotation(x);
        self.pToyScrollView.alpha   = alp;
    }];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNav
{
    UIBarButtonItem *leftItem = \
    [[UIBarButtonItem alloc] initWithText:NSLocalizedString(@"商品详情", nil)
                                   target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightBarItem =\
    [[UIBarButtonItem alloc]initWithNavigationItem:self.navigationItem
                                            target:self
                                            action:@selector(shareAction:)
                                       bgImgString:@"share"];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarItem,nil];
}

#pragma mark - share

- (void)shareAction:(id)sender
{
    [_shareTools show];
}


#pragma mark - PShareToolsDelegate

- (void)bottomBarActionDelegateShareType:(PBottomBarType)barType
{
    switch (barType) {
        case PBottomBarTypeCollection:
        {
            [self.view makeToast:@"收藏" duration:1.0 position:@"center" tag:10010];
        }
            break;
            
        case PBottomBarTypeForwarding:
        {
            [self shareAction:nil];
        }
            break;
            
        case PBottomBarTypeLike:
        {
            [self.view makeToast:@"喜欢" duration:1.0 position:@"center" tag:10010];
        }
            break;
        default:
            break;
    }
}


@end
