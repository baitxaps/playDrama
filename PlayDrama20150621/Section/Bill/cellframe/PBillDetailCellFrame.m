//
//  PBillDetailRoleCellFrame.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillDetailCellFrame.h"


@implementation PBillDetailCellFrame

- (void)setBillEntity:(PBillEntitiy *)baseEntity
{
    [super setBillEntity:baseEntity];

    [self handleRoleCellLayout];
}

- (void)handleRoleCellLayout
{
    BOOL hasRoleName         = self.billEntity.dramaRoleName.length >= 1;
    CGFloat textContentWidth = \
    kBaseCellWith - self.billTypeNameLabelRect.origin.x - kBaseGapBetweenSubViews;
    if (hasRoleName){
        //性别Rect
        CGPoint sexImagePoint = \
        [PContainerCoords widgetWithLowerLeftCoordinates:self.lineViewRect];
        CGFloat y = sexImagePoint.y + kBaseGapBetweenSubViews;
        _sexImgViewRect  =  (CGRect){{kBaseGapBetweenSubViews,y}, {20.0f,20.0f}};
        
        //角色名
        CGPoint roleNamePoint   = \
        [PContainerCoords widgetWithUpperRightCoordinates:_sexImgViewRect];
        CGSize roleNameSize     =\
        [self.billEntity.dramaRoleName getWidthWithText:self.billEntity.dramaRoleName
                                                andFont:kBase13Font];
        _roleNameLabelRect = (CGRect){{roleNamePoint.x+kBaseGapBetweenSubViews,roleNamePoint.y}, {roleNameSize.width, 21}};
  
        //角色内容信息
        CGPoint roleTextPoint   = \
        [PContainerCoords widgetWithLowerLeftCoordinates:_sexImgViewRect];
        
        CGFloat textContentHeight =\
        [self.billEntity.dramaRoleText heightWithFixWidth:textContentWidth
                                                     font:kBase13Font];
        _roleTextLabelRect  = (CGRect){{_sexImgViewRect.origin.x,roleTextPoint.y +kBaseGapBetweenSubViews}, {textContentWidth, textContentHeight}};
         _cellHeight = CGRectGetMaxY(_roleTextLabelRect);
    }
    //柱状图
    _histogramViewWidth  = self.billEntity.datas.count*(UIScreenWidth /4.0f);
    _histogramViewRect   = (CGRect){{0,0}, {_histogramViewWidth,kBaseHistogramSubViews}};
    
    //200+32 +30
    CGFloat scrollViewH = self.billEntity.isRole ?kBaseHistogramSubViews +32:kBaseHistogramSubViews;
    //滚动视图
    _scrollViewRect     = (CGRect){{0,_cellHeight},{kBaseCellWith,scrollViewH}};

    //总高度
    _cellHeight = CGRectGetMaxY(_scrollViewRect);
}

@end
