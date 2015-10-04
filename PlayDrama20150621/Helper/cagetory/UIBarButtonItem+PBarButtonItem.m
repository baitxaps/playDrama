//
//  UIBarButtonItem+PBarButtonItem.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "UIBarButtonItem+PBarButtonItem.h"

@implementation UIBarButtonItem (PBarButtonItem)

- (id)initWithBarButtonItemType:(PBarButtonItemType)type target:(id)target action:(SEL)action
{
    UIImage *img = nil;
    NSString *btnName = @"";
    
    switch (type)
    {
        case PBarButtonItemTypeCancel:
            img = [UIImage imageNamed:@"go_common_navigation_back"];
            //btnName = NSLocalizedString(@"GO_Navigation_Title_Back", nil);
            break;
        case PBarButtonItemTypeClose:
            img = [UIImage imageNamed:@"baritem_delete"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Delete", nil);
            break;
        case PBarButtonItemTypeClear:
            img = [UIImage imageNamed:@"baritem_clear"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Clear", nil);
            break;
        case PBarButtonItemTypeOK:
            img = [UIImage imageNamed:@"baritem_ok"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_OK", nil);
            break;
        case PBarButtonItemTypeAdd:
            img = [UIImage imageNamed:@"baritem_add"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Add", nil);
            break;
        case PBarButtonItemTypeSave:
            img = [UIImage imageNamed:@"btn_Unsave"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Unsave", nil);
            break;
        case PBarButtonItemTypeOthers:
            img = [UIImage imageNamed:@"MultiPersonSelected"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_ShareMore", nil);
            break;
        case PBarButtonItemTypeSearch:
            img = [UIImage imageNamed:@"golo_search_green"];
            // btnName = NSLocalizedString(@"GO_Navigation_Title_Search", nil);
            break;
        case PBarButtonItemTypeRefresh:
            img = [UIImage imageNamed:@"GoRefreshBtn"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Refresh", nil);
            break;
        case PBarButtonItemTypeStreamPicture:
            img = [UIImage imageNamed:@"StreamPictureBtn"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_StreamPicture", nil);
            break;
        case PBarButtonItemTypeStreamValue:
            img = [UIImage imageNamed:@"StreamValueBtn"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Listing", nil);
            break;
        case PBarButtonItemTypeHistogram:
            img = [UIImage imageNamed:@"gomp_trip_record_statistic_histogram_btn"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_StreamPicture", nil);
            break;
        case PBarButtonItemTypeExit:
            img = [UIImage imageNamed:@"ExitBtn"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Exit", nil);
            break;
        case PBarButtonItemTypeMyShareOthers:
            img = [UIImage imageNamed:@"MyShareMore"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Details", nil);
            break;
        case PBarButtonItemTypeMessageMore:
            img = [UIImage imageNamed:@"IM_Message_More_high"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Details", nil);
            break;
        case PBarButtonItemTypeMessageMode:
            img = [UIImage imageNamed:@"IM_Message"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Message", nil);
            break;
        case PBarButtonItemTypeDriveMode:
            img = [UIImage imageNamed:@"IM_Drivemode"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Drivemode", nil);
            break;
        case PBarButtonItemTypeWrite:
            img = [UIImage imageNamed:@"GOAddShareNav"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Publish", nil);
            break;
        case PBarButtonItemTypeSuperSearch:
            img = [UIImage imageNamed:@"senior_search_normal"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Search", nil);
            break;
        case PBarButtonItemTypeShare:
            img = [UIImage imageNamed:@"navshare"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Share", nil);
            break;
        case PBarButtonItemTypeExchange:
            img = [UIImage imageNamed:@"IM_Exchange"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Exchange", nil);
            break;
            
            // 图形有边框的
        case PBarButtonItemTypeTxtNext:
            img = [UIImage imageNamed:@"nextBtnBg"];
            btnName = NSLocalizedString(@"GO_Register_Next", nil);
            break;
        case PBarButtonItemTypeTxtComplete:
            img = [UIImage imageNamed:@"nextBtnBg"];
            btnName = NSLocalizedString(@"GO_Register_Complete", nil);
            break;
        case PBarButtonItemTypeMore:
            img = [UIImage imageNamed:@"nextBtnBg"];
            btnName = NSLocalizedString(@"GOServiceFilter_More", nil);
            break;
        case PBarButtonItemTypePosts:
            img = [UIImage imageNamed:@"GOAddShareNav"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Posts", nil);
            break;
            
        case PBarButtonItemTypeReply:
            img = [UIImage imageNamed:@"GOAddShareNav"];
            btnName = NSLocalizedString(@"GO_Navigation_Title_Reply", nil);
            break;
            
    }
    
    UIBarButtonItem *buttonItem = nil;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width+(IS_IOS7?0:20), img.size.height)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.exclusiveTouch = YES;
    
    if ((type == PBarButtonItemTypeTxtNext) ||
        (type == PBarButtonItemTypeTxtComplete) ||
        (type == PBarButtonItemTypeMore ))
    {
        btn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
        [btn setTitle:btnName forState:UIControlStateNormal];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        
        buttonItem = [self initWithCustomView:btn];
    }else if (type == PBarButtonItemTypeSearch)
    {
        btn.frame = CGRectMake(0, 0, 24 + (IS_IOS7?0:20), 24);
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        buttonItem = [self initWithCustomView:btn];
    }else
    {
        CGFloat fontSize = 17.0;
        if (type == PBarButtonItemTypeMessageMore ||
            type == PBarButtonItemTypeMyShareOthers) {
            fontSize = 15.0;
        }
        
        NSString *tmpName = [NSString stringWithFormat:@" %@", btnName];
        CGFloat labelWidth = [self goWidthForString:tmpName fontSize:fontSize andWidth:60];
        
        CGFloat height = img.size.height;
        CGFloat width = img.size.width + labelWidth;
        
        btn.frame = CGRectMake(0, 0, width, height);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setImage:img forState:UIControlStateNormal];
        
        [btn setTitle:tmpName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:RGBAColor(117, 117, 117, 1) forState:UIControlStateHighlighted];
        
        buttonItem = [self initWithCustomView:btn];
    }
    
    return buttonItem;
}


- (id)initWithText:(NSString*)text target:(id)target action:(SEL)action
{
    UIImage *img = [UIImage imageNamed:@"pcommon_nav_back"];
    CGSize titleSize = [text sizeWithAttributes:@{NSFontAttributeName: PNAVGATION_Font}];
    CGFloat width = img.size.width + titleSize.width + 5 > UIScreenWidth - 130?UIScreenWidth - 130:img.size.width + titleSize.width + 5;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,width, 30)];
    [backButton.titleLabel setFont: PNAVGATION_Font];
    [backButton setTitle:text forState:UIControlStateNormal];
    backButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [backButton setImage:img forState:UIControlStateNormal];
    [backButton setImageEdgeInsets: UIEdgeInsetsMake((backButton.frame.size.height - img.size.height)/2.0,0, 0, 0)];
    [backButton setTitleEdgeInsets: UIEdgeInsetsMake((backButton.frame.size.height - titleSize.height)/2.0,0, 0, 0)];//left:img.size.width - 5
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [self initWithCustomView:backButton];
    return item;
}

- (id)initWithLineAndText:(NSString*)text target:(id)target action:(SEL)action
{
    UIImage *img = [UIImage imageNamed:@"pcommon_nav_back"];
    CGSize titleSize = [text sizeWithAttributes:@{NSFontAttributeName: PNAVGATION_Font}];
    CGFloat width = img.size.width + titleSize.width + 10 > UIScreenWidth - 130?UIScreenWidth - 130:img.size.width + titleSize.width + 10;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,width, 30)];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [backButton setTitle:text forState:UIControlStateNormal];
    backButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [backButton setTitleColor:LightBlackColor forState:UIControlStateNormal];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [backButton setImage:img forState:UIControlStateNormal];
    [backButton setImageEdgeInsets: UIEdgeInsetsMake((backButton.frame.size.height - img.size.height)/2.0,0, 0, 0)];
    [backButton setTitleEdgeInsets: UIEdgeInsetsMake((backButton.frame.size.height - titleSize.height)/2.0,img.size.width - 5, 0, 0)];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width-1, 7, 1, 16)];
    lineView.backgroundColor = LightGrayColor;
    [backButton addSubview:lineView];
    
    UIBarButtonItem *item = [self initWithCustomView:backButton];
    return item;
}

- (instancetype)initPlainStyleItemWithTitle:(NSString*)title target:(id)target action:(SEL)action
{
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: PNAVGATION_Font}];
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.frame = CGRectMake(0.0, 0.0, titleSize.width + 10, 44.0);//加10是为了让按钮大一点便于点击。
    itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    itemBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [itemBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [itemBtn setTitleColor:LightGreenColor forState:UIControlStateNormal];
    itemBtn.exclusiveTouch = YES;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
    return buttonItem;
}

- (instancetype)initWithNavigationItem:(UINavigationItem *)barItem WithText:(NSString*)text
{
    UIView *titleView           = [[UIView alloc]init];
    UILabel *titleLabel         = [[UILabel alloc] init];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.font             = PNAVGATION_Font;
    titleLabel.textAlignment    = NSTextAlignmentLeft;
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.frame            = CGRectMake(0,0,200,44);
    titleLabel.text             = text ;
    titleView.frame             = CGRectMake(0,
                                             barItem.titleView.frame.size.height/2 - titleLabel.frame.size.height/2,
                                             titleLabel.frame.size.width,
                                             titleLabel.frame.size.height);
    
    [titleView addSubview:titleLabel];
    titleView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    return BarButtonItem;
}


- (instancetype)initWithNavigationItem:(UINavigationItem *)barItem
                                target:(id)target
                                action:(SEL)action
                           bgImgString:(NSString*)bgImgString
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(UIScreenWidth - 40, 5, 25, 25)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage imageNamed:bgImgString] forState:UIControlStateNormal];
    btn.exclusiveTouch = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (CGFloat) goWidthForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    CGSize textSize;
    
    if (IS_IOS7) {
        textSize = [value boundingRectWithSize:CGSizeMake(width, HUGE_VAL)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                       context:nil].size;
    }
    else {
        textSize = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, HUGE_VAL) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    // 去除小数点后加1
    return textSize.width + 1;
}




@end
