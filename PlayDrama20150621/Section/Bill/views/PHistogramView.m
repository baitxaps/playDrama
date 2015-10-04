//
//  PHistogramView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/21.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PHistogramView.h"
#import "CGContextObject.h"
#import "RedGradientColor.h"
#import "PUILayoutConst.h"
#import "NSString+AttributeStyle.h"
#import "PForeGroundColorStyle.h"
#import "PFontStyle.h"


@interface PHistogramView ()
@property (nonatomic, strong) CGContextObject  *contextObject;
@property (nonatomic, assign) double historyRange;
@end

@implementation PHistogramView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 显示没有数据
- (void)noData
{
    self.layer.contents = (__bridge id)(([UIImage imageNamed:@"playdrama_welcome"].CGImage));
}

- (void)drawRect:(CGRect)rect
{
    [self histogramViewHeigth];
    [self histogramView];
}

/*
 * 0   + 80/2  - 25/2
 * 80  + 80/2  - 25/2
 * 160 + 80/2  - 25/2
 * 320 + 80/2  - 25/2
 * ........
 */

- (void)histogramView
{
    //总高度
    CGFloat height = self.frame.size.height -32 -30;//168
    
    // 获取操作句柄
    _contextObject = [[CGContextObject alloc] initWithCGContext:UIGraphicsGetCurrentContext()];
    
    CGFloat xOffset = 0;
    // 开始绘图
    for (int count = 0; count < self.datas.count; count++) {
        //每行宽度
        CGFloat tempWidth = (kBaseCellWith) /4.0f;
        //x每次的偏移量
        xOffset  = (count * tempWidth) + tempWidth/2.0f - kHistogramVithWidth/2.0f;
        // 获取随机高度
        CGFloat lineHeight = (height - 20)/self.historyRange * [self.datas[count] doubleValue];
        //arc4random() % (int)(height - 20);
        
        CGRect historyRect = CGRectMake(xOffset,
                                        height - lineHeight,
                                        kHistogramVithWidth,
                                        lineHeight);
        // 绘制矩形
        [_contextObject drawFillBlock:^(CGContextObject *contextObject) {
            if (count <4) {
                _contextObject.fillColor = self.colors[count];
            }else{
               _contextObject.fillColor = [RGBColor randomColorWithAlpha:1];
            }
            [contextObject addRect:historyRect];
            PDebugLog(@"x= %f",xOffset);
        }];
        
        // 绘制顶部文字居中
        NSString *votes   = [NSString stringWithFormat:@"%@票", self.datas[count]];
        CGSize voteSize   = [votes getWidthWithText:votes andFont:kBase10Font];
        
        CGPoint votePoint = [PContainerCoords getMidCoordWithSFrame:historyRect
                                                             dWitdh:voteSize.width
                                                             offset:0];
        [_contextObject drawString:votes
                           atPoint:CGPointMake(votePoint.x, height - lineHeight - 12)
                    withAttributes:@{NSFontAttributeName:kBase10Font,
                                     NSForegroundColorAttributeName:[UIColor grayColor]}];
        
        // 图片文字中点坐标
        CGPoint histogramPoint = [PContainerCoords getMidCoordWithSFrame:historyRect
                                                                  dWitdh:kImageView
                                                                  offset:kOffset];
        
        CGPoint labelPoint     = [PContainerCoords getMidCoordWithSFrame:historyRect
                                                                   dWitdh:kLabelWidth
                                                                   offset:kOffset];
        
        NSString *text  =@"A.李金铭和孙艺修的成正果 ";
        
        if (self.isText) {
            labelPoint.y = histogramPoint.y+kImageView;
            [self drawImageViewWithPoint:histogramPoint
                               urlString:@"http://pic1.nipic.com/2008-09-08/200898163242920_2.jpg"];
            [self drawLabelWithPoint:labelPoint text:text];
        }else{
            [self drawLabelWithPoint:labelPoint text:text];
        }
    }
}

- (void)histogramViewHeigth
{
    double max = 0;
    for (NSNumber *number in self.datas) {
        if (max < [number doubleValue]) {
            max =[number doubleValue];
        }
    }
    if (max <=100) {
        self.historyRange = 100;
    }else if(max <=1000){
        self.historyRange = 1000;
    }else if(max <=5000){
        self.historyRange = 5000;
    }else if(max <=10000){
        self.historyRange = 10000;
    }else if(max <=50000){
        self.historyRange = 50000;
    }else if(max <=100000){
        self.historyRange = 100000;
    }else{
        self.historyRange = 500000;
    }
}


#pragma  mark - 加底部图
- (void)drawImageViewWithPoint:(CGPoint )point urlString:(NSString *)url
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                        point.x,
                                                                        point.y ,
                                                                        kImageView,
                                                                        kImageView
                                                                        )];
    [imgView sd_setImageWithURL:[NSURL URLWithString:url]];
    [self addSubview:imgView];
    [imgView drawBounderWidth:0.5
                       radius:imgView.frame.size.height/2.0
                        Color:[UIColor clearColor].CGColor];
}

#pragma  mark - 加底部文字
- (void)drawLabelWithPoint:(CGPoint)point text:(NSString *)text
{
    CGFloat  textHight   = [text widthWithFont:kBase11Font maxWidth:kLabelWidth];
    UILabel *label       = [[UILabel alloc]initWithFrame:CGRectMake(point.x,
                                                                    point.y,
                                                                    kLabelWidth,
                                                                    textHight
                                                                    )];
    //加富文本
    label.attributedText = \
    [text createAttributedStringWithStyles:\
     @[colorStyle([UIColor redColor],             NSMakeRange(0, 1)),
       fontStyle ([UIFont systemFontOfSize:11.f], NSMakeRange(1, 1))]];
    
    label.numberOfLines     = 0;
    label.backgroundColor   = [UIColor clearColor];
    label.font              = kBase11Font;
    [self addSubview:label];
}

/*
 绘制图片
 [_contextObject drawImage:[UIImage imageNamed:@"loading22"] inRect:CGRectMake(xOffset, height - lineHeight, 15, 15)];
 
 [_contextObject drawString:votes
 atPoint:CGPointMake(2 + xOffset, height - lineHeight - 12)
 
 withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Times New Roman" size:10.f],
 NSForegroundColorAttributeName : [UIColor grayColor]}];
 */
@end
