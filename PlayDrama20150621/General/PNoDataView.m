//
//  GOMapNoDataView.m
//
//  Created by chenhairong on 14-7-29.
//  Copyright (c) 2014年 LAUNCH. All rights reserved.
//

#import "PNoDataView.h"

@interface PNoDataView()
@property (strong, nonatomic) PNoDataViewBlock actionBlock;
@end

@implementation PNoDataView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) tapAction:(PNoDataViewBlock) block{
    
    self.actionBlock = block;
}

- (void)createNoDataView:(NSString *)name HaveAdd:(BOOL)fg
{
    self.backgroundColor = [UIColor whiteColor];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 145, 126)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 145, 126)];
    imgView.image = [UIImage imageNamed:@"playdrama_no_data"];
    imgView.userInteractionEnabled = YES;
    [backView addSubview:imgView];
    
    if (fg) {
        
        UILabel *datalabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 75, 140, 20)];
        datalabel.backgroundColor = [UIColor clearColor];
        datalabel.text = NSLocalizedString(@"抱歉，暂无数据", nil);
        datalabel.font = [UIFont systemFontOfSize:13];
        datalabel.textAlignment = NSTextAlignmentCenter;
        datalabel.adjustsFontSizeToFitWidth = YES;
        [datalabel setTextColor:[UIColor grayColor]];
        [imgView addSubview:datalabel];
        
        UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(2, 95, 140, 25)];
        addView.backgroundColor = [UIColor clearColor];
        [imgView addSubview:addView];
        
        NSMutableAttributedString *addContent = [[NSMutableAttributedString alloc] initWithString:name];
        NSRange contentRange = {0, [addContent length]};
        [addContent addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        
        UILabel *addlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 25)];
        addlabel.backgroundColor = [UIColor clearColor];
        addlabel.attributedText = addContent;
        addlabel.textAlignment = NSTextAlignmentCenter;
        addlabel.adjustsFontSizeToFitWidth = YES;
        datalabel.font = [UIFont systemFontOfSize:14];
        [addlabel setTextColor:LightGreenColor];
        [addView addSubview:addlabel];
        
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createNewSomething)];
        [addView addGestureRecognizer:tapAction];
    }
    else{
        
        UILabel *datalabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 80, 140, 30)];
        datalabel.backgroundColor = [UIColor clearColor];
        datalabel.textAlignment = NSTextAlignmentCenter;
        datalabel.adjustsFontSizeToFitWidth = YES;
        datalabel.text = name.length > 0 ? name :NSLocalizedString(@"抱歉，暂无数据", nil);
        datalabel.font = [UIFont systemFontOfSize:13];
        [datalabel setTextColor:[UIColor grayColor]];
        [imgView addSubview:datalabel];
    }
    backView.center = CGPointMake(UIScreenWidth*0.5, UIScreenHeight*0.5 - 100);
}

- (void)createNoDataViewWithTip:(NSString *)tip btnTitle:(NSString *)btnTitle
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect imgFrame = CGRectMake(0, 0, 145, 126);
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 145, 126)];
//    imgView.image = [UIImage imageNamed:@"gomp_no_data"];
    UIImage *image = [UIImage imageNamed:@"playdrama_no_data"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(78, 10, 10, 10)];
    imgView.image = image;
    imgView.userInteractionEnabled = YES;
    [self addSubview:imgView];
    
    CGSize textSize = [tip textSizeWithFont:[UIFont systemFontOfSize:13]
                          constrainedToSize:CGSizeMake(140, CGFLOAT_MAX)];
    if (textSize.height > 20) {
        textSize.height = 32;
        imgFrame.size.height = imgFrame.size.height + 16;
        imgView.frame = imgFrame;
    }
    
    UILabel *datalabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 87, 140, textSize.height)];
    datalabel.backgroundColor = [UIColor clearColor];
    datalabel.text = tip;
    datalabel.font = [UIFont systemFontOfSize:13];
    //ios6 适配
    if (!IS_IOS7) {
       datalabel.font = [UIFont systemFontOfSize:12];
    }
    datalabel.numberOfLines = 2;
    datalabel.adjustsFontSizeToFitWidth = YES;
    datalabel.textAlignment = NSTextAlignmentCenter;
    [datalabel setTextColor:[UIColor grayColor]];
    [imgView addSubview:datalabel];
    
    if (btnTitle.length > 0) {
        datalabel.frame = CGRectMake(2, 77, 140, textSize.height);
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(2, datalabel.frame.origin.y + datalabel.frame.size.height, 140, 25);
        addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        addButton.titleLabel.backgroundColor = [UIColor clearColor];
        [addButton addTarget:self action:@selector(createNewSomething) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *dict = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                               NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:LightGreenColor};
        NSAttributedString *titleAttString = [[NSAttributedString alloc] initWithString:btnTitle
                                                                             attributes:dict];
        [addButton setAttributedTitle:titleAttString forState:UIControlStateNormal];
        
        [imgView addSubview:addButton];
    }
    imgView.center = CGPointMake(UIScreenWidth*0.5, UIScreenHeight*0.5 - 100);
}

- (void)createNoDataBGViewWithTip:(NSString *)tip
                         btnTitle:(NSString *)btnTitle
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 273)];
    backView.backgroundColor = [UIColor clearColor];
    [self addSubview:backView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((UIScreenWidth - 202)/2, 0, 202, 150)];
    imgView.image = [UIImage imageNamed:@"playdrama_welcome"];
    imgView.userInteractionEnabled = YES;
    [backView addSubview:imgView];
    
    UILabel *datalabel = [[UILabel alloc]initWithFrame:CGRectMake(29, 83, 142, 52)];
    datalabel.backgroundColor = [UIColor clearColor];
    datalabel.textAlignment = NSTextAlignmentCenter;
    datalabel.adjustsFontSizeToFitWidth = YES;
    datalabel.text = tip;
    datalabel.numberOfLines = 0;
    datalabel.font = [UIFont systemFontOfSize:13];
    [datalabel setTextColor:[UIColor grayColor]];
    [imgView addSubview:datalabel];
    
    if(btnTitle.length > 0){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 230, UIScreenWidth - 20, 43);
        [button setTitle:btnTitle forState:UIControlStateNormal];
        button.backgroundColor = RGBAColor(28, 178, 167, 1);
        [button addTarget:self action:@selector(createNewSomething) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }else{
        backView.frame = CGRectMake(0, 0, 202, 150);
        imgView.frame = backView.frame;
    }
    
    backView.center = CGPointMake(UIScreenWidth*0.5, UIScreenHeight*0.5 - 100);
}

- (void)createNewSomething{
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
