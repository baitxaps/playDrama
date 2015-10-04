//
//  PBillBaseCellFrame.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillBaseCellFrame.h"
#import "PBillEntitiy.h"

@implementation PBillBaseCellFrame


- (void)setBillEntity:(PBillEntitiy *)baseEntity
{
    _billEntity = baseEntity;
    
    // 剧集类型（下季提要，角色介绍）
    CGFloat billX = kBaseGapBetweenSubViews;
    CGFloat billY = kBaseGapBetweenSubViews;
    CGSize billSize =\
    [_billEntity.billTypeName getWidthWithText:_billEntity.billTypeName
                                      andFont:kBase13Font];
    _billTypeNameLabelRect = (CGRect){{billX, billY}, {billSize.width,21.0f}};
    
    //bill票图
    CGPoint imagePoint = \
    [PContainerCoords widgetWithUpperRightCoordinates:_billTypeNameLabelRect];
    _billTypeImageViewRect  = CGRectMake(imagePoint.x + billX, imagePoint.y,20, 20);
    
    //lineView
    CGPoint linePoint = \
    [PContainerCoords widgetWithLowerLeftCoordinates:_billTypeNameLabelRect];
    _lineViewRect =  CGRectMake(0,linePoint.y +kBaseGapBetweenSubViews ,kBaseCellWith, 0.5);
    
    //voteBtnRect
    _voteBtnRect = CGRectMake(UIScreenWidth -70, 5, kVoteButtonHeight, kVoteButtonHeight);
  
    _cellHeight += CGRectGetMaxY(_lineViewRect);
}


@end
