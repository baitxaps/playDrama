//
//  PProgressHUB.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/22.
//  Copyright (c) 2015年 times. All rights reserved.
//

#define DATACOUNT   25
#define KCoversTag  8080
#import "PProgressHUB.h"

@interface PProgressHUB()
@property (weak, nonatomic ) IBOutlet UIImageView   *loadImgView;
@property (strong,nonatomic) NSMutableArray         *loadingData;
@end

@implementation PProgressHUB

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.layer.opacity = 0.5f;
    self.layer.cornerRadius = self.frame.size.height / 2;
}

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view {
    PProgressHUB *hud = [PProgressHUB initWithNib];
    hud.center = view.center;
    [view addSubview:hud];
    [hud show];
    return MB_AUTORELEASE(hud);
}

- (void)hide {
    [self.loadImgView stopAnimating];
    [self removeFromSuperview];
    [self.loadingData removeAllObjects];
    _loadingData = nil;
}

- (void)hideForScreen
{
    UIWindow *win = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *covers = [win viewWithTag:KCoversTag];
    if (covers) {
        [covers removeFromSuperview];
    }
    [self hide];
}

+ (PProgressHUB *) initWithNib{
    PProgressHUB *view = nil;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PProgressHUB" owner:self options:nil];
    for (id obj in array) {
        if ([obj isKindOfClass:[PProgressHUB class]]) {
            view = (PProgressHUB *)obj;
            break;
        }
    }
    return view;
}

+ (MB_INSTANCETYPE)showHUDAddedToForScreen:(UIView *)view
{
    UIWindow *win = [[UIApplication sharedApplication].windows objectAtIndex:0];
    //加一个覆盖层
    CGRect winFrame = win.frame;
    UIView * covers = [[UIView alloc]initWithFrame:winFrame];
    covers.alpha = 0.7;
    covers.backgroundColor = [UIColor darkGrayColor];
    covers.tag = KCoversTag;
    [win addSubview:covers];
    
    PProgressHUB *hud = [PProgressHUB initWithNib];
    hud.center = view.center;
    [covers addSubview:hud];
    [hud show];
    return MB_AUTORELEASE(hud);
}
#pragma mark - Show & hide

- (void)show {
    self.loadImgView.animationImages = self.loadingData;
    [self.loadImgView setAnimationDuration:1.3f];
    [self.loadImgView setAnimationRepeatCount:0];
    [self.loadImgView startAnimating];
}


- (NSMutableArray *)loadingData
{
    if (!_loadingData) {
        _loadingData = [NSMutableArray arrayWithCapacity:DATACOUNT];
        for (NSInteger i = 0; i <DATACOUNT; i ++) {
            NSString *data = [NSString stringWithFormat:@"loading%zd",i];
            [_loadingData addObject:[UIImage imageNamed:data]];
        }
    }
    return _loadingData;
}

@end
